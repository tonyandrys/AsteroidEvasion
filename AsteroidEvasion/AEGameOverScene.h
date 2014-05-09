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

// The final score the player had before the end of the game
@property (nonatomic) NSInteger finalScore;

-(id)initWithSize:(CGSize)size playerScore:(NSInteger)score;

@end
