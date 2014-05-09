//
//  AEPreferences.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NSUserDefaults preference file names and their keys are defined here. These can be accessed in any class by importing this file.
 */
@interface AEPreferences : NSObject

// ** NSUserDefaults filename for accessing the current logged in user's profile.
extern NSString* const ACTIVE_PROFILE_DATA;
// Associated keys:
extern NSString *const KEY_PROFILE_NAME;        // Player's name
extern NSString *const KEY_PROFILE_HIGH_SCORE;  // Player's high score
extern NSString *const KEY_PROFILE_SHIP_COLOR;  // Player's ship color
extern NSString *const KEY_PROFILE_DIFFICULTY;  // Player's current difficulty setting

// ** The score of the last played game can be accessed anywhere using the KEY_LAST_GAME_SCORE
extern NSString *const KEY_LAST_GAME_SCORE;

// ** The high score tables are also stored in NSUserDefaults under the following keys

extern NSString *const KEY_HIGH_SCORE_TABLE_1P; // all high scores achieved in single player games
extern NSString *const KEY_HIGH_SCORE_TABLE_2P; // all high scores achieved in multiplayer (network) games

@end
