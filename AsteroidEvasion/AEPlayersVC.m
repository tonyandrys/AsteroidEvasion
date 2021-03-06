//
//  AEPlayersTableVC.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEPlayersVC.h"
#import "AEPlayer.h"
#import "AEPlayerDetailsVC.h"

@interface AEPlayersVC ()

@end

@implementation AEPlayersVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


# pragma mark - State handling
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Read player data from storage
    self.players = [self getPlayerData];
    
    // Disabled by Tony - doesn't do anything right now
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space02"]];
    //[self.tableView setBackgroundView:imageView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    // Write existing player data plus any new created players to storage
    [self writePlayerData];
    
    //Dispose of any resources that can be recreated
}

#pragma mark - Table view data source

// Number of sections in this TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// There exists one row for every Player object stored in self.players
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.players count];
}

// Configure the cells and fill with data for display
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     // Dequeue a cell
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
     AEPlayer *player = (self.players)[indexPath.row];
     
     // For each cell, set the title to the name of this player and the subtitle to their latest high score.
     cell.textLabel.text = player.name;
     cell.detailTextLabel.text = [NSString stringWithFormat:@"High Score: %@", player.highScore];

     return cell;
 }

#pragma mark AENewPlayerVCDelegate Implementation

// Called if the user presses the Done button on the modal Add Player screen
- (void)AENewPlayerVCDidSave:(AENewPlayerVC *)controller didAddPlayer:(AEPlayer *)newPlayer {
    
    // Add the new Player to the players array and update the TableView
    [self.players addObject:newPlayer];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.players count] -1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"Added new player (%@) at row %u", newPlayer.name, ([self.players count] - 1));
    
    // Dismiss the modal view
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Called if the user presses the Cancel button on the modal Add Player screen
- (void)AENewPlayerVCDidCancel:(AENewPlayerVC *)controller {
    
    // Close the modal view and return focus to the parentVC
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Data Operations

// Reads player data from storage and returns an array of AEPlayer objects
- (NSMutableArray *)getPlayerData {
    
    //FIXME: Move these dictionary key constants to a central file or maybe in the header? I'm not sure what the best practice is here. Better ask StackOverflow.
    NSString *KEY_PLAYER_NAME = @"name";
    NSString *KEY_HIGH_SCORE = @"highScore";
    NSString *KEY_DIFFICULTY = @"difficulty";
    NSString *KEY_SHIP_COLOR = @"shipColor";
    
    // Instantiate players array
    NSMutableArray *createdPlayers = [NSMutableArray arrayWithCapacity:20]; //FIXME: Magic Number
    
    // Load player information from Players.plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PlayerData" ofType:@"plist"];
    NSDictionary *playerDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    // Get array of accounts from plist dictionary
    NSArray *playerArray = playerDictionary[@"players"];
    NSLog(@"Loaded %u player(s) from plist.", [playerArray count]);
    
    // For each entry in the account array, build a AEPlayer object from it and add it to self.players
    for (int i=0; i<[playerArray count]; i++) {
        
        // Get the next dictionary in the array
        NSDictionary *d = [playerArray objectAtIndex:i];
        
        // Build an AEPlayer object from the information in d
        AEPlayer *newPlayer = [[AEPlayer alloc] init];
        newPlayer.name = [d valueForKey:KEY_PLAYER_NAME];
        newPlayer.highScore = [d valueForKey:KEY_HIGH_SCORE];
        newPlayer.shipColor = [d valueForKey:KEY_SHIP_COLOR];
        newPlayer.difficulty = [[d valueForKey:KEY_DIFFICULTY] intValue];
        NSLog(@"Built Player (Name: %@ | High Score: %@ | Ship Color: %@ | Difficulty: %i)", newPlayer.name, newPlayer.highScore, newPlayer.shipColor, newPlayer.difficulty);
        
        // Add it to the array
        [createdPlayers addObject:newPlayer];
    }

    return createdPlayers;
}

// Writes the contents of an array to PlayerData.plist
- (void)writePlayerData {
    
    // Convert all AEPlayers in self.players to dictionarys and add them to an array
    NSMutableArray *playerDictionaries = [[NSMutableArray alloc] initWithCapacity:[self.players count]];
    NSLog(@"Beginning to write player data to plist...");
    for (int i=0; i<[self.players count]; i++) {
        
        // Get the next player
        AEPlayer *player = [self.players objectAtIndex:i];
        
        // Convert it to a dictionary representation
        NSDictionary *dict = [player toDictionary];
        
        // Add it to the array
        [playerDictionaries addObject:dict];
        NSLog(@"%i] added player (%@) to write dictionary", i, player.name);
    }
    
    // Package the array into another dictionary to match plist format
    NSMutableDictionary *writeDictionary = [[NSMutableDictionary alloc]init];
    [writeDictionary setObject:playerDictionaries forKey:@"players"];
    
    // Write it to the plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PlayerData" ofType:@"plist"];
    [writeDictionary writeToFile:plistPath atomically:YES];
    NSLog(@"Wrote %i Players to storage.", [self.players count]);
}

#pragma mark - Navigation

// Prepare for navigation to child views before a segue takes place
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Add Player segue configuration
    if ([segue.identifier isEqualToString:@"AddPlayer"]) {
        
        // Get a hook to the ViewController we're about to move to
        UINavigationController *navigationController = segue.destinationViewController;
        AENewPlayerVC *newPlayerViewController = [navigationController viewControllers][0];
        
        // Let the destination ViewController be the delegate of this class for communication between the two
        newPlayerViewController.delegate = self;
    }
    
    // Player Details segue configuration
    else if ([segue.identifier isEqualToString:@"PlayerDetails"]) {
        
        // Get the index of the clicked cell
        NSInteger clickedIndex = [self.tableView indexPathForCell:sender].row;
        
        // Get the Player object associated with that index in the array
        AEPlayer *selectedPlayer = [self.players objectAtIndex:clickedIndex];
        NSLog(@"User has selected the player name %@", selectedPlayer.name);
        
        //UINavigationController *navigationController = segue.destinationViewController;
        AEPlayerDetailsVC *playerDetailsVC = segue.destinationViewController;
        
        // Pass the player object to the next VC
        playerDetailsVC.displayPlayer = selectedPlayer;
        NSLog(@"Transitioning to Player Details View...");
    }
    
}

@end
