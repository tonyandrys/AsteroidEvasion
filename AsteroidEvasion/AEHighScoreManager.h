//  AEHighScoreManager.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/10/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 AEHighScoreManager is the class responsible for return the current list of high scores, adding new elements to the table, and removing them.
 
 High Score Table data representation
 
 Structure:
 { "name0" -> "score0", "name1" -> "score1", ... , "name(n-1) -> "score(n-1)" }
 
 High scores are sorted in **descending order** by score. New elements are added such that the high score table remains sorted. This is important, as the view countroller should not be responsible for sorting.
 
 All arrays returned from this class are immutable - changes should be made using addScoreToHighScoreTable and clearHighScoreTable
 
 Do not instantiate this class. It will get you nowhere. All methods you should need are class-based methods.
 */

// Use TABLE_ONE/TWO_PLAYER_SCORES constants to specify which table to target when calling methods with the 'table' argument
@interface AEHighScoreManager : NSObject

extern NSString *const TABLE_ONE_PLAYER_SCORES;
extern NSString *const TABLE_TWO_PLAYER_SCORES;
extern NSString *const KEY_HIGH_SCORE_PLAYER_NAME;
extern NSString *const KEY_HIGH_SCORE_PLAYER_SCORE;

// High score tables are built using a combination of NSArrays and NSDictionaries. The array returned contains one NSDictionary, each representing one high score.

+(NSArray *)getHighScoreTable:(NSString *)table;

+(void)addScoreToHighScoreTable:(NSString *)table playerName:(NSString *)name score:(NSInteger)score;

+(void)clearHighScoreTable:(NSString *)table;

@end
