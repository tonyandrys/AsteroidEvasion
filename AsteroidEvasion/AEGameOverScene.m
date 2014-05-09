//
//  AEGameOverScene.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/25/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEGameOverScene.h"
#import "AEGameScene.h"
#import "AEPreferences.h"

@implementation AEGameOverScene

-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        // Load user preferences for score calculation and high score management
        self.userPrefs = [NSUserDefaults standardUserDefaults];

        
        // Load and define position of the two text labels
        
        // "Game Over!"
        SKLabelNode *gameOverTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        gameOverTextLabel.fontSize = 36;
        gameOverTextLabel.fontColor = [UIColor whiteColor];
        gameOverTextLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 64.0f);
        gameOverTextLabel.text = @"Game Over!";
        [self addChild:gameOverTextLabel];
        
        // Central label which displays the player's ending score
        SKLabelNode *scoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        scoreTextLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        scoreTextLabel.fontSize = 144.0f;
        scoreTextLabel.fontColor = [UIColor whiteColor];
        
        // Pull the player's score out of NSUserDefaults and write it to the score label
        if (self.userData == nil) {
            NSLog(@"FKDLJFSLDKJFLSDKJFDLSKJFSLDKJF'"); // THIS CANNOT HAPPEN IN INIT.
        }
        self.finalScore = [[self.userData valueForKey:@"score"] integerValue];
        NSLog(@"player's final score is %i", self.finalScore);
        scoreTextLabel.text = [NSString stringWithFormat:@"%i", self.finalScore];
        [self addChild:scoreTextLabel];
        
        // "Touch to play again!"
        SKLabelNode *playAgainTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        playAgainTextLabel.fontColor = [UIColor whiteColor];
        playAgainTextLabel.fontSize = 22;
        playAgainTextLabel.position = CGPointMake(CGRectGetMidX(self.frame), scoreTextLabel.position.y - scoreTextLabel.fontSize - 20.0f);
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

// Checks if the score passed to the method is the current player's best score - updates their profile accordingly if so
-(BOOL)isHighScoreAchieved:(NSInteger)score {
    
    // Get the user's current high score from NSUserDefaults
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSString *existingHighScore = [userPrefs stringForKey:KEY_PROFILE_HIGH_SCORE];
    
    // Check if the score achieved is better than the user's previous high score (if one exists)
    return true;
    
}



@end
