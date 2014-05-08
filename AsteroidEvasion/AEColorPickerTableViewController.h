//
//  AEColorPickerTableViewController.h
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/6/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEColorPickerTableViewController;

// Define a protocol for communication between the table holding the list of colors (this class) and the settings table
@protocol AEColorPickerTableViewControllerDelegate <NSObject>
- (void)colorPickerViewController:(AEColorPickerTableViewController *)controller didSelectColor:(NSString *)newColor;
@end

@interface AEColorPickerTableViewController : UITableViewController

@property (nonatomic, weak) id <AEColorPickerTableViewControllerDelegate> delegate;

// Hold the name of the currently selected color
@property (nonatomic, strong) NSString *color;

@end
