//
//  AEGameScene.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEPlayer.h"
#import "AEAppDelegate.h"

/* AEGameScene is the main Sprite Kit Scene for the game engine. */

// This scene should receive collision notifications
@interface AEGameScene : SKScene<SKPhysicsContactDelegate>

// AEPlayer object representing the current logged in profile
@property (strong, nonatomic) AEPlayer *playerOne;
@property (nonatomic, strong) AEAppDelegate *appDelegate;
// Current score of the player is stored here
@property (readwrite, assign) int playerScore;

// Reference to scoreLabel to easily change player's score display
@property (strong, nonatomic) SKLabelNode *playerScoreLabel;

@property (strong, nonatomic) SKLabelNode *player2Score;

- (id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1;

@end
