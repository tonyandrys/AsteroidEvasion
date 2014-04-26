//
//  AEGameOverScene.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/25/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEPlayer.h"

@interface AEGameOverScene : SKScene

// Player objects representing active user profile
@property (strong, nonatomic) AEPlayer *playerOne;
@property (readwrite, assign) NSInteger *playerScore;

@end
