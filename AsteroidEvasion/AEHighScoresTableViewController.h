//
//  AEHighScoresTableViewController.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/8/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEHighScoresTableViewController : UITableViewController

// Segmented Control view embedded in the top navigation bar. User toggles this to swap between 1 player and 2 player scores
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dataSourceSegmentedControl;

// Holds the dictionary containing the loaded high scores from memory
@property (strong, nonatomic) NSArray *highScores;

@end
