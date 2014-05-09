//
//  AESettingsTableViewController.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/6/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AESettingsTableViewController.h"
#import "AEPreferences.h"

@interface AESettingsTableViewController ()

@end

@implementation AESettingsTableViewController {
    NSString *color;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization goes here
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Write the player's name to the top label
    self.playerNameDisplayLabel.text = self.loggedInPlayer.name;
    
    color = self.loggedInPlayer.shipColor;
    NSLog(@"Player's ship color is currently set to %@", color);
    
    // Check if the logged in player has a non-zero high score. If so, enable the clear high scores button
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSInteger currentHighScore = [[userPrefs valueForKey:KEY_PROFILE_HIGH_SCORE] integerValue];
    if (currentHighScore <= 0) {
        NSLog(@"No high score associated with profile. Disabling clear button.");
        [self.clearHighScoreButton setEnabled:NO];
        [self.clearHighScoreButton setAlpha:0.4f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rowCount = 0;
    if (section == 0 || section == 2) {
        rowCount = 1;
    } else if (section == 1) {
        rowCount = 2;
    }
    
    return rowCount;
}

#pragma mark - Button Actions
- (IBAction)clearHighScoreButtonPressed:(id)sender {
    
    // Write a zero to the current player's high score field
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [userPrefs setValue:@"0" forKey:KEY_PROFILE_HIGH_SCORE];
    [userPrefs synchronize];
    
    // Disable clear high score button
    [self.clearHighScoreButton setEnabled:NO];
    [self.clearHighScoreButton setAlpha:0.4f];
    NSLog(@"High score cleared.");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Ship Color segue
    if ([segue.identifier isEqualToString:@"SelectColorSegue"]) {
        
        // Set this VC to act as the color picker view controller's delegate
        AEColorPickerTableViewController *colorPickerTableViewController = segue.destinationViewController;
        colorPickerTableViewController.delegate = self;
        
        // Send the user's current ship color setting to the color picker VC
        if (self.loggedInPlayer.shipColor != nil) {
            colorPickerTableViewController.color = self.loggedInPlayer.shipColor;
        } else {
            NSLog(@"WARNING: Profile has no shipColor associated with it!");
        }
    }
    
    // Difficulty select segue
    if ([segue.identifier isEqualToString:@"SelectDifficultySegue"]) {
        
        // Set this VC to act as the difficulty picker view controller's delegate
        AEDifficultyPickerTableViewController *difficultyPickerTableViewController = segue.destinationViewController;
        difficultyPickerTableViewController.delegate = self;
        
        // Send the user's current ship color setting to the difficulty picker VC
        difficultyPickerTableViewController.difficulty = self.loggedInPlayer.difficulty;
    }
}

#pragma mark - delegate callback methods

// Fired when a color is selected in the Color Picker View by the user
- (void)colorPickerViewController:(AEColorPickerTableViewController *)controller didSelectColor:(NSString *)newColor {
    
    // Load settings associated with the profile currently logged in
    NSUserDefaults* userPrefs = [NSUserDefaults standardUserDefaults];
    NSString *profileName = [userPrefs valueForKey:KEY_PROFILE_NAME];
    NSString *existingShipColor = [userPrefs valueForKey:KEY_PROFILE_SHIP_COLOR];
    NSLog(@"Changed %@'s ship color setting to %@ (was %@)", profileName, newColor, existingShipColor);
    
    // Write the color change to the user's profile and update.
    [userPrefs setValue:newColor forKey:KEY_PROFILE_SHIP_COLOR];
    self.loggedInPlayer.shipColor = newColor;
    
    // Pop Color Picker off the View Controller stack
    [self.navigationController popViewControllerAnimated:YES];
    
}


// Fired when a difficulty is selected in the Difficulty Picker View by the user
- (void)difficultyPickerViewController:(AEDifficultyPickerTableViewController *)controller didSelectDifficulty:(NSInteger)newDifficulty {
    
    // Load settings associated with the profile currently logged in
    NSUserDefaults* userPrefs = [NSUserDefaults standardUserDefaults];
    NSString *profileName = [userPrefs valueForKey:KEY_PROFILE_NAME];
    NSInteger existingDifficulty = [[userPrefs valueForKey:KEY_PROFILE_DIFFICULTY] integerValue];
    
    // Write the color change to the user's profile and update.
    [userPrefs setValue:[NSNumber numberWithInteger:existingDifficulty] forKey:KEY_PROFILE_DIFFICULTY];
    self.loggedInPlayer.difficulty = newDifficulty;
    
    NSLog(@"Changed %@'s difficulty setting to %i (was %i)", profileName, newDifficulty, existingDifficulty);
    
    // Pop Difficulty Picker off the View Controller stack
    [self.navigationController popViewControllerAnimated:YES];
}


@end
