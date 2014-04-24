//
//  AETwoPlayerGameVC.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEPlayer.h"

@interface AETwoPlayerGameVC : UIViewController

@property (strong, nonatomic) AEPlayer *loggedInPlayer; // Holds the AEPlayer object that represents the logged in player. This should be passed by the rootVC during the segue process

// UI Outlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarProfileLabel; // Button at bottom left (acts as label displaying name of logged in profile)

@end
