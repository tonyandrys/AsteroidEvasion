//
//  AEMyScene.m
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEGameScene.h"

@implementation AEGameScene

-(id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1 {
    if (self = [super initWithSize:size]) {
        
        // Store AEPlayer to property
        self.playerOne = p1;
        
        // Setup the scene
        [self buildScene];
        
        }
    
    return self;
}

#pragma mark - Scene Setup and Object Creation

// Builds all visual elements and sets up the scene
- (void)buildScene {
    
    /* Configure scene background */
    self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    
    /* Build text labels */
    
    // Player score label
    SKLabelNode *playerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    playerScoreLabel.text = [NSString stringWithFormat:@"%@:", self.playerOne.name];
    playerScoreLabel.fontSize = 18;
    playerScoreLabel.fontColor = [UIColor whiteColor];
    playerScoreLabel.position = CGPointMake(self.frame.origin.x + 25, self.frame.origin.y + 10);
    [self addChild:playerScoreLabel];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
