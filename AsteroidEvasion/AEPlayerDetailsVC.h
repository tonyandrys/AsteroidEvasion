//
//  AEPlayerDetailsVC.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEPlayer.h"

@interface AEPlayerDetailsVC : UITableViewController

// Player object to display in more detail
@property (strong, nonatomic) AEPlayer *displayPlayer;

// Outlet to "Log In" button on Nav Controller top toolbar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginMenuButton;

// Outlets to the UI elements of the details TableView. These are filled with the information from the AEPlayer object passed to this View Controller
@property (weak, nonatomic) IBOutlet UILabel *nameDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipColorDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyDisplayLabel;

// Store loaded NSUserDefaults object to access throughout class
@property (strong, nonatomic) NSUserDefaults *userPrefs;

@end
