//
//  AEGameOverScene.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/25/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEGameOverScene.h"
#import "AEGameScene.h"

@implementation AEGameOverScene

-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        // Load and define position of the two text labels
        
        // "Game Over!"
        SKLabelNode *gameOverTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        gameOverTextLabel.fontSize = 36;
        gameOverTextLabel.fontColor = [UIColor whiteColor];
        gameOverTextLabel.position = CGPointMake(self.frame.origin.x, self.frame.origin.y);
        
        // Write the appropriate message to the label depending on the context and add it to the  scene
        gameOverTextLabel.text = @"Game Over!";
        [self addChild:gameOverTextLabel];
        
        // "Touch to play again!"
        SKLabelNode *playAgainTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        playAgainTextLabel.fontColor = [UIColor whiteColor];
        playAgainTextLabel.fontSize = 22;
        playAgainTextLabel.position = CGPointMake(CGRectGetMidX(self.frame), gameOverTextLabel.position.y - gameOverTextLabel.fontSize - 20.0f);
        playAgainTextLabel.text = @"Touch to play again.";
        [self addChild:gameOverTextLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // When the user touches the screen, the jumps back into the breakout game
    AEGameScene *gameScene = [[AEGameScene alloc] initWithSize:self.size];
    [self.view presentScene:gameScene];
}

@end
