//
//  AENewPlayerVC.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AENewPlayerVC;

@protocol AENewPlayerVCDelegate <NSObject>

// Customary to include a reference to the object in question as the first parameter when writing delegate methods to avoid confusion.
- (void)AENewPlayerVCDidCancel:(AENewPlayerVC *)controller;
- (void)AENewPlayerVCDidSave:(AENewPlayerVC *)controller;

@end

@interface AENewPlayerVC : UITableViewController

@property (nonatomic, weak) id <AENewPlayerVCDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

