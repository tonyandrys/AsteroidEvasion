//
//  AEDifficultyPickerTableViewController.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/7/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

/*
 Custom UITableViewController implementation that hooks into the Settings > Difficulty view. Allows the player to change the difficulty settings associated with their profile.
 */

#import <UIKit/UIKit.h>

@class AEDifficultyPickerTableViewController;

// Define a protocol for communication between AESettingsTVC and this class
@protocol AEDifficultyPickerTableViewControllerDelegate <NSObject>

-(void)difficultyPickerViewController:(AEDifficultyPickerTableViewController *)controller didSelectDifficulty:(NSInteger)newDifficulty;
@end

@interface AEDifficultyPickerTableViewController : UITableViewController

// Store a reference to the instance acting as the delegate for this class
@property (nonatomic, weak) id <AEDifficultyPickerTableViewControllerDelegate> delegate;

// Hold the difficulty setting that is currently selected
@property (nonatomic, assign) NSInteger difficulty;

@end
