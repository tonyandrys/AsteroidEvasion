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

// Retrieves either the one or two player high scores from memory and returns them as a dictionary.
+(NSDictionary *)getHighScoreTable:(NSString *)table {
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    
    // One or Two player scores makes no difference in the retrieval process
    if ([table isEqualToString:TABLE_ONE_PLAYER_SCORES] || [table isEqualToString:TABLE_TWO_PLAYER_SCORES]) {
        
        NSDictionary *scoreDictionary = [userPrefs valueForKey:table];
        // if a valid table key is passed to this method and nothing is returned, the tables do not exist. Create them and return an empty dictionary.
        if (scoreDictionary == nil) {
            NSLog(@"It looks like the high score table requested for table %@ doesn't exist. Creating them now.", table);
            [userPrefs setObject:[NSDictionary dictionary] forKey:table];
            [userPrefs synchronize];
        } else {
            NSLog(@"Found an existing high score table (%@)! Returning it.", table);
            return scoreDictionary;
        }
        
        return [NSDictionary dictionary];
    }
    
    // Unrecognized table
    else {
        NSLog(@"WARNING: Couldn't find the high score table you requested. Returning an empty dictionary.");
        return [NSDictionary dictionary];
    }

}

// Adds a score to either the one player or two player high score tables
+(void)addScoreToHighScoreTable:(NSString *)table score:(NSInteger)newScore {
    
}

// Wipes either the 1p or 2p high score tables clean
// (Use TABLE_ONE/TWO_PLAYER_SCORES constants to specify which table to target)
+(void)clearHighScoreTable:(NSString *)table {
    
}

@end
