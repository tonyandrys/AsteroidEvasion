//
//  AEGameSceneViewController.h
//  AsteroidEvasion
//

//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "AEPlayer.h"

/* AEGameSceneViewController is the VC that creates and presents the Sprite Kit scene AEGameScene */
@interface AEGameSceneViewController : UIViewController

// Store the profile of the currently logged in user, passed from the root VC during the segue to this scene
@property (strong, nonatomic) AEPlayer *loggedInPlayer;
@end
