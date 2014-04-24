//
//  AEMainViewController.h
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//
//

#import <UIKit/UIKit.h>

@interface AEMainViewController : UIViewController

// Information about the active user profile is stored in NSUserDefaults
@property (strong, nonatomic) NSUserDefaults *userPrefs;

// References to UI views which must react to profile changes
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileNameButton;    // The only way to add a label to a UIToolbar is to make a disabled button I guess...
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarActionButton; // button on right which responds to user input (either login/logout)
@property (weak, nonatomic) IBOutlet UIButton *onePlayerStartButton; // button that triggers one-player drill down
@property (weak, nonatomic) IBOutlet UIButton *twoPlayerStartButton; // button that triggers two-player drill down

@end
