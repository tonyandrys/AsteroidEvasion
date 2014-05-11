//  AEHighScoreManager.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/10/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 AEHighScoreManager is the class responsible for return the current list of high scores, adding new elements to the table, and removing them.
 
 Do *not* instantiate this class-- all methods you should need are class-based methods.
 */

// Use TABLE_ONE/TWO_PLAYER_SCORES constants to specify which table to target when calling methods with the 'table' argument
@interface AEHighScoreManager : NSObject

extern NSString *const TABLE_ONE_PLAYER_SCORES;
extern NSString *const TABLE_TWO_PLAYER_SCORES;

+(NSDictionary *)getHighScoreTable:(NSString *)table score:(NSInteger)newScore;

+(void)addScoreToHighScoreTable:(NSString *)table score:(NSInteger)newScore;
+(void)clearHighScoreTable:(NSString *)table;

@end
