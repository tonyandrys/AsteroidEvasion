//
//  AEPreferences.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEPreferences.h"

@implementation AEPreferences

// NSUserDefaults - Access data about the player currently logged in
NSString *const ACTIVE_PROFILE_DATA = @"activeProfileData";
NSString *const KEY_PROFILE_NAME = @"profileName";
NSString *const KEY_PROFILE_HIGH_SCORE = @"profileHighScore";
NSString *const KEY_PROFILE_SHIP_COLOR = @"profileShipColor";
NSString *const KEY_PROFILE_DIFFICULTY = @"profileDifficulty";

// Score of last game
NSString *const KEY_LAST_GAME_SCORE = @"lastGameScore";

// High Score Table Storage
NSString *const KEY_HIGH_SCORE_TABLE_1P = @"highScoreTable1P";
NSString *const KEY_HIGH_SCORE_TABLE_2P = @"highScoreTable2P";

@end

