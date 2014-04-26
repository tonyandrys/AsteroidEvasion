//
//  AEGameScene.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEPlayer.h"

/* AEGameScene is the main Sprite Kit Scene for the game engine. */

// This scene should receive collision notifications
@interface AEGameScene : SKScene<SKPhysicsContactDelegate>

// Player objects representing active user profile
@property (strong, nonatomic) AEPlayer *playerOne;
@property (readwrite, assign) int playerScore;

// Reference to scoreLabel to easily change player's score display
@property (strong, nonatomic) SKLabelNode *playerScoreLabel;


- (id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1;

@end
