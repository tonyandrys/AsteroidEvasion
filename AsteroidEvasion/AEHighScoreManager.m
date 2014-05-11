//
//  AEHighScoreManager.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/10/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEHighScoreManager.h"
#import "AEPreferences.h"

@implementation AEHighScoreManager

NSString *const TABLE_ONE_PLAYER_SCORES = @"onePlayerHighScoreTable";
NSString *const TABLE_TWO_PLAYER_SCORES = @"twoPlayerHighScoreTable";

// Keys to index each dictionary stored in the high score array
NSString *const KEY_HIGH_SCORE_PLAYER_NAME = @"highScorePlayerName";
NSString *const KEY_HIGH_SCORE_PLAYER_SCORE = @"highScorePlayerScore";

// Retrieves either the one or two player high scores from memory and returns them.
+(NSArray *)getHighScoreTable:(NSString *)table {
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    
    // One or Two player scores makes no difference in the retrieval process
    if ([table isEqualToString:TABLE_ONE_PLAYER_SCORES] || [table isEqualToString:TABLE_TWO_PLAYER_SCORES]) {
        
        NSArray *scoreArray = [userPrefs valueForKey:table];
        // if a valid table key is passed to this method and nothing is returned, the tables do not exist. Create them and return an empty dictionary.
        if (scoreArray == nil) {
            NSLog(@"It looks like the high score table requested for table %@ doesn't exist. Creating them now.", table);
            [userPrefs setObject:[NSArray array] forKey:table];
            [userPrefs synchronize];
        } else {
            NSLog(@"Found an existing high score table (%@)! Returning it.", table);
            return scoreArray;
        }
        return [NSArray array];
    }
    
    // Unrecognized table
    else {
        NSLog(@"WARNING: Couldn't find the high score table you requested. Returning an empty array.");
        return [NSArray array];
    }

}

// Adds a score to either the one player or two player high score tables
+(void)addScoreToHighScoreTable:(NSString *)table playerName:(NSString *)name score:(NSInteger)score {
    
    // Get the requested high score table and copy it into a mutable array to make changes
    NSArray *a = [self getHighScoreTable:table];
    NSMutableArray *scoreArray = [NSMutableArray arrayWithArray:a];
    
    // Create a new dictionary to store the score we are about to add to the table
    NSMutableDictionary *newHighScoreEntry = [NSMutableDictionary dictionary];
    [newHighScoreEntry setValue:name forKey:KEY_HIGH_SCORE_PLAYER_NAME];
    [newHighScoreEntry setValue:[NSString stringWithFormat:@"%i", score] forKey:KEY_HIGH_SCORE_PLAYER_SCORE];
    NSLog(@"Created new high score entry {name: %@ -> score: %@}", name, [NSString stringWithFormat:@"%i", score]);
    
    // We want to add this score to the high score table while ensuring the table is still sorted. An ordered insertion is necessary.
    
    // Edge case I: array is empty
    if ([scoreArray count] == 0) {
        // A 0 size array is sorted, so just add the new score.
        [scoreArray addObject:newHighScoreEntry];
        NSLog(@"Added new score to the high score table (%@).", table);
        [self writeHighScoreTable:table arrayToWrite:scoreArray];
    
    } else {
        
        // Store the index to add the new score
        int k = 0;
        
        NSLog(@"Starting ordered insertion...");
        // Perform an ordered insertion of this new score on the master high score array.
        for (int i=0; i<[scoreArray count]; i++) {
            NSDictionary *d = [scoreArray objectAtIndex:i];
            NSInteger s = [[d objectForKey:KEY_HIGH_SCORE_PLAYER_SCORE] integerValue];
            
            // if score to add >= s, we need to add the object at index k.
            if (score >= s) {
                NSLog(@"Need to add score at index %i", k);
                k = i;
                break;
            }
            // If we are at the last element of the array and have not placed the score yet, the new high score is lower than all other scores in the array. We can add it to the end of the array and write the result.
            else if (i == [scoreArray count] - 1) {
                NSLog(@"Score is lower than every other high score so far. Adding it to the back of the array.");
                [scoreArray addObject:newHighScoreEntry];
                [self writeHighScoreTable:table arrayToWrite:scoreArray];
                return;
            }

        }
        
        // Contains the elements we will write to memory
        NSMutableArray *writeArray = [NSMutableArray array];
        
        // Edge Case II: index to add is at 0
        if (k == 0) {
            
            [writeArray addObject:newHighScoreEntry];
            [writeArray addObjectsFromArray:scoreArray];
        }
        
        
        // Add the new high score at index=k by splitting the array into two parts, [0,k-1] and [k,n], and adding the new high score value to the first part.
        else {
            
            // Array [0,k-1]
            NSMutableArray *a1 = [NSMutableArray array];
            // Array [k,n]
            NSMutableArray *a2 = [NSMutableArray array];
            
            for (int i=0; i<k; i++) {
                [a1 addObject:[scoreArray objectAtIndex:i]];
            }
            
            // Build array [k,n]
            for (int i=k; i<[scoreArray count]; i++){
                [a2 addObject:[scoreArray objectAtIndex:i]];
            }
            
            // Add the new high score entry to the back of the array containing items [0,k-1]
            [a1 addObject:newHighScoreEntry];
            
            // Merge the two arrays and write the result to NSUserDefaults
            writeArray = [[NSMutableArray alloc] init];
            [writeArray addObjectsFromArray:a1];
            if ([a2 count] > 0) {
                [writeArray addObjectsFromArray:a2];
            }
        }
        
        // Write the final array to memory
        [self writeHighScoreTable:table arrayToWrite:writeArray];
        
    }
}

// Wipes either the 1p or 2p high score tables clean
// (Use TABLE_ONE/TWO_PLAYER_SCORES constants to specify which table to target)
+(void)clearHighScoreTable:(NSString *)table {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    if ([table isEqualToString:TABLE_ONE_PLAYER_SCORES] || [table isEqualToString:TABLE_TWO_PLAYER_SCORES]) {
        [userPrefs setValue:nil forKey:table];
        [userPrefs synchronize];
        NSLog(@"Cleared high score table (%@).", table);
    } else {
        NSLog(@"WARNING: Invalid high score table parameter (sent:%@). Could not clear high scores.", table);
    }

}

// Writes the passed array to the appropriate key of NSUserDefaults and synchronizes the changes
// Don't call this directly unless you have a good reason-- it was written to only be called by other AEHighScoreManager methods. If you do, and arr isn't in the appropriate format (specified in the header), things will break horribly.
+(void)writeHighScoreTable:(NSString *)table arrayToWrite:(NSMutableArray *)arr {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [userPrefs setValue:arr forKey:table];
    [userPrefs synchronize];
    NSLog(@"Wrote new high score array to NSUserDefaults.");
}

@end
