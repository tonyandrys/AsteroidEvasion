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
#import "AEHighScoreManager.h"

// Node name constants
NSString *const SCORE_NODE_NAME = @"scoreNodeName";

@implementation AEGameOverScene

// IMPORTANT: Must pass player's score when initializing this scene
-(id)initWithSize:(CGSize)size playerScore:(NSInteger)s{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        // Store the player's final score as a property
        self.finalScore = s;
        
        // Build and configure the scene
        [self buildScene];

    }
    
    return self;
}

// Builds and configures the nodes for this scene.
-(void)buildScene {
    
    // "Game Over!"
    SKLabelNode *gameOverTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    gameOverTextLabel.fontSize = 36;
    gameOverTextLabel.fontColor = [UIColor whiteColor];
    gameOverTextLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 84.0f);
    gameOverTextLabel.text = @"Game Over!";
    [self addChild:gameOverTextLabel];
    
    // Back button
    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"backButton"];
    backButton.position = CGPointMake(0.0f + backButton.frame.size.width, 0.0f + backButton.frame.size.height);
    backButton.name = @"backButtonNode";
    [self addChild:backButton];
    
    
    // Central label which displays the player's ending score
    SKLabelNode *scoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    scoreTextLabel.name = @"statute";
    scoreTextLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    scoreTextLabel.fontSize = 144.0f;
    scoreTextLabel.fontColor = [UIColor whiteColor];
    scoreTextLabel.text = [NSString stringWithFormat:@"%i", self.finalScore];
    
    // "You ended up with a score of..."
    SKLabelNode *scoreTextFooterLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    scoreTextFooterLabel.position = CGPointMake(scoreTextLabel.position.x, scoreTextLabel.position.y + scoreTextLabel.fontSize);
    scoreTextFooterLabel.fontSize = 22.0f;
    scoreTextFooterLabel.fontColor = [UIColor whiteColor];
    scoreTextFooterLabel.text = @"Your final score:";
    [self addChild:scoreTextFooterLabel];
    
    // "Touch to play again!"
    SKLabelNode *playAgainTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    playAgainTextLabel.fontColor = [UIColor whiteColor];
    playAgainTextLabel.fontSize = 22;
    playAgainTextLabel.position = CGPointMake(CGRectGetMidX(self.frame), scoreTextLabel.position.y - scoreTextLabel.fontSize - 5.0f);
    playAgainTextLabel.text = @"Touch to play again.";
    [self addChild:playAgainTextLabel];
    
    // Check if this round is a new personal best
    BOOL isNewHighScore = [self isHighScoreAchieved:self.finalScore];
    
    // If a new personal high score was achieved, update the view accordingly
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    if (isNewHighScore) {
        
        // Record the new high score in NSUserDefaults
        [userPrefs setValue:[NSString stringWithFormat:@"%i", self.finalScore] forKey:KEY_PROFILE_HIGH_SCORE];
        [userPrefs synchronize];
        NSLog(@"New high score written to profile (%i)", self.finalScore);
        
        // Add a label to the scene notifying the player
        SKLabelNode *newHighScoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        newHighScoreTextLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - scoreTextLabel.fontSize + 65.0f);
        newHighScoreTextLabel.fontSize = 25.0f;
        newHighScoreTextLabel.fontColor = [UIColor greenColor];
        newHighScoreTextLabel.text = @"New personal high score!";
        [self addChild:newHighScoreTextLabel];
        
        // color the score label green
        scoreTextLabel.fontColor = [UIColor greenColor];

    }
    
    // Attempt to add this score to the master high score list
    NSString *playerName = [userPrefs valueForKey:KEY_PROFILE_NAME];
    [AEHighScoreManager addScoreToHighScoreTable:TABLE_ONE_PLAYER_SCORES playerName:playerName score:self.finalScore];
    
    [self addChild:scoreTextLabel];
    
    // Play burning sound effect
    [self runAction:[SKAction playSoundFileNamed:@"burn.wav" waitForCompletion:NO]];

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if exit button is pressed, go back to the main menu
    if ([node.name isEqualToString:@"backButtonNode"]) {
        NSLog(@"Transitioning to root VC...");
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

    }
    
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
    NSInteger existingHighScore = [[userPrefs stringForKey:KEY_PROFILE_HIGH_SCORE] integerValue];
    NSLog(@"Player's final score was %i (current high score is %i)", score, existingHighScore);
    
    // Check if the score achieved is better than the user's previous high score (if one exists)
    if (score > existingHighScore) {
        NSLog(@"New high score achieved!");
        return true;
    } else {
        NSLog(@"Existing high score is larger than this score, no update necessary.");
        return false;
    }
}



@end
