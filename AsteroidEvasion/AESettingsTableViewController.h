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

// This class must implement the ColorPickerVC's protocol to allow communication between the two
@interface AESettingsTableViewController : UITableViewController <AEColorPickerTableViewControllerDelegate>

@property (strong, nonatomic) AEPlayer *loggedInPlayer;

// Label at top of settings screen which displays the name of the account that is currently logged in
@property (weak, nonatomic) IBOutlet UILabel *playerNameDisplayLabel;

@end
