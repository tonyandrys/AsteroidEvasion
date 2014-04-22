//
//  AEPlayersTableVC.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AENewPlayerVC.h"

// PlayersVC must implement NewPlayerVCDelegate to allow communication between the "Add Players" view and this view which contains the list of players.
@interface AEPlayersVC : UITableViewController <AENewPlayerVCDelegate>

// Array of Player objects to display in the table
@property (nonatomic, strong) NSMutableArray *players;

@end
