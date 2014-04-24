//
//  AEMyScene.h
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEPlayer.h"

@interface AEGameScene : SKScene

// Player objects representing active user profile
@property (strong, nonatomic) AEPlayer *playerOne;

- (id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1;

@end
