//
//  AEHighScoresTableViewController.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/8/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEHighScoresTableViewController.h"
#import "AEPreferences.h"
#import "AEHighScoreManager.h"

@interface AEHighScoresTableViewController ()

@end

@implementation AEHighScoresTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userPrefs = [NSUserDefaults standardUserDefaults];
    
    // TEMPORARY: Pull one player high scores from NSUserDefaults
    self.highScores = [self.userPrefs valueForKey:TABLE_ONE_PLAYER_SCORES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.highScores count];
}

// Called to configure each cell to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HighScoreCell" forIndexPath:indexPath];
    
    // Get the high score object for this cell
    NSDictionary *d = [self.highScores objectAtIndex:indexPath.row];
    
    // Extract name/score values from the high score entry and write them to the cell
    cell.textLabel.text = [d valueForKey:KEY_HIGH_SCORE_PLAYER_NAME];
    cell.detailTextLabel.text = [d valueForKey:KEY_HIGH_SCORE_PLAYER_SCORE];
    return cell;
    
}

#pragma mark - UI Button Actions
// Called when the Clear Scores button at the bottom of the is pressed by the player - clears all stored high scores
- (IBAction)clearHighScoresButtonPressed:(id)sender {
    [AEHighScoreManager clearHighScoreTable:TABLE_ONE_PLAYER_SCORES];
    [AEHighScoreManager clearHighScoreTable:TABLE_TWO_PLAYER_SCORES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
