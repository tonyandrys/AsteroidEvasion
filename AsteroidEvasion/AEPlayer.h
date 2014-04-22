//
//  AEPlayer.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A Player is a data model for storing and retrieving user profiles (players). 
 
 A Player consists of:
 
 + A player name 
    string
 
 + A high score 
    signed integer
 
 + A ship color (used to color the ship in single player and represent this player in network games)
    signed integer representing one of many(?) ship colors
 
 + A difficulty level 
    signed integer representing one of four difficulty levels
 
 FIXME: Need to add a property to hold a player's profile image
 */

@interface AEPlayer : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *highScore;
@property (readwrite, assign) NSInteger shipColor;
@property (readwrite, assign) NSInteger difficulty;

-(NSDictionary *)toDictionary;

@end
