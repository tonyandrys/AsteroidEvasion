//
//  AEMyScene.h
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEPlayer.h"

// This scene should receive collision notifications
@interface AEGameScene : SKScene<SKPhysicsContactDelegate>

// Player objects representing active user profile
@property (strong, nonatomic) AEPlayer *playerOne;
@property (readwrite, assign) NSInteger *playerScore;

- (id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1;

@end
