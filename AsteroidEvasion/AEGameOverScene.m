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
        gameOverTextLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        // Write the appropriate message to the label depending on the context and add it to the  scene
        gameOverTextLabel.text = @"Game Over!";
        [self addChild:gameOverTextLabel];
        
        // "Touch to play again!"
        SKLabelNode *playAgainTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        playAgainTextLabel.fontColor = [UIColor whiteColor];
        playAgainTextLabel.fontSize = 22;
        playAgainTextLabel.position = CGPointMake(CGRectGetMidX(self.frame), gameOverTextLabel.position.y - gameOverTextLabel.fontSize - 20.0f);
        playAgainTextLabel.text = @"Touch to play again.";
        [self addChild:playAgainTextLabel];
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // When the user touches the screen, rebuild and reconfigure the game scene
    AEGameScene *gameScene = [[AEGameScene alloc] initWithSize:self.size playerOne:self.playerOne];
    gameScene.scaleMode = SKSceneScaleModeAspectFit;
    gameScene.anchorPoint = CGPointMake(0.5, 0.5);
    
    // Present the scene to restart the game
    [self.view presentScene:gameScene];
}



@end
