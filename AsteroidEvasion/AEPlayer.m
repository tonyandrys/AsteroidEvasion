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
    [d setValue:self.shipColor forKey:KEY_SHIP_COLOR];
    [d setValue:[NSString stringWithFormat:@"%i", self.difficulty] forKey:KEY_DIFFICULTY];
    return d;
}

// Checks the ship color setting of this player and returns the UIColor associated with the setting of the string
-(UIColor *)getShipColorAsUIColor {
    
    UIColor *uiColor = nil;
    
    // This is ugly but making a dictionary of NSStrings -> UIColors that would be the same for each user like this seems like a waste of memory.
    if ([self.shipColor isEqualToString:@"White"]) {
        uiColor = [UIColor whiteColor];
    } else if ([self.shipColor isEqualToString:@"Red"]) {
        uiColor = [UIColor redColor];
    } else if ([self.shipColor isEqualToString:@"Orange"]) {
        uiColor = [UIColor orangeColor];
    } else if ([self.shipColor isEqualToString:@"Yellow"]) {
        uiColor = [UIColor yellowColor];
    } else if ([self.shipColor isEqualToString:@"Green"]) {
        uiColor = [UIColor greenColor];
    } else if ([self.shipColor isEqualToString:@"Blue"]) {
        uiColor = [UIColor blueColor];
    } else if ([self.shipColor isEqualToString:@"Purple"]) {
        uiColor = [UIColor purpleColor];
    }
    
    if (uiColor == nil) {
        NSLog(@"** WARNING: shipColor value is nil! Check AEPlayer object for %@!", self.name);
    }
    return uiColor;
}

@end
