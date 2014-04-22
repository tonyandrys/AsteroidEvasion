//
//  AEPlayersTableVC.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEPlayersTableVC;

@protocol AEPlayersTableVCDelegate <NSObject>
-(void)AEPlayersTableVCDidSave:(AEPlayersTableVC *)controller;
-(void)AEPlayersTableVCDidCancel:(AEPlayersTableVC *)controller;
@end

@interface AEPlayersTableVC : UITableViewController

@property (nonatomic, weak) id <AEPlayersTableVCDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
