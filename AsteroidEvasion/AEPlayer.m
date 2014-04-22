//
//  AEPlayer.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEPlayer.h"

@implementation AEPlayer : NSObject

// Builds an NSDictionary from the player information stored in this object and returns it. Useful for writing to plists.
-(NSDictionary *)toDictionary {
    
    // FIXME: These constants are already defined in AEPlayersVC. Move these to one location.
    NSString *KEY_PLAYER_NAME = @"name";
    NSString *KEY_HIGH_SCORE = @"highScore";
    NSString *KEY_DIFFICULTY = @"difficulty";
    NSString *KEY_SHIP_COLOR = @"shipColor";
    
    // Add data to dictionary and return it
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    [d setValue:self.name forKey:KEY_PLAYER_NAME];
    [d setValue:self.highScore forKey:KEY_HIGH_SCORE];
    [d setValue:[NSString stringWithFormat:@"%i", self.shipColor] forKey:KEY_SHIP_COLOR];
    [d setValue:[NSString stringWithFormat:@"%i", self.difficulty] forKey:KEY_DIFFICULTY];
    return d;
}

@end
