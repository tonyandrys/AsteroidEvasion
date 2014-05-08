//
//  AESettingsTableViewController.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/6/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEPlayer.h"
#import "AEColorPickerTableViewController.h"
#import "AEDifficultyPickerTableViewController.h"

// This class must implement both the ColorPickerVC and the DifficultyPickerVC's protocols to allow communication between the three classes
@interface AESettingsTableViewController : UITableViewController <AEColorPickerTableViewControllerDelegate, AEDifficultyPickerTableViewControllerDelegate>

@property (strong, nonatomic) AEPlayer *loggedInPlayer;

// Label at top of settings screen which displays the name of the account that is currently logged in
@property (weak, nonatomic) IBOutlet UILabel *playerNameDisplayLabel;

@end
