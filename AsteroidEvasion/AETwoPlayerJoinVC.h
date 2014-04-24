//
//  AETwoPlayerJoinVC.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEPlayer.h"

@interface AETwoPlayerJoinVC : UIViewController

// Holds the AEPlayer object that represents the logged in player. This should be passed by the rootVC during the segue process
@property (strong, nonatomic) AEPlayer *loggedInPlayer;

// Button at bottom left (acts as label displaying name of logged in profile)
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarProfileLabel;


@end
