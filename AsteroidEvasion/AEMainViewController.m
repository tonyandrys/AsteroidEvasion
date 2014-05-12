//
//  AEMainViewController.m
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//
//

#import "AEMainViewController.h"
#import "AEPreferences.h"
#import "AEPlayer.h"
#import "AETwoPlayerGameVC.h"
#import "AEGameSceneViewController.h"
#import "AESettingsTableViewController.h"
#import "AEHighScoreManager.h"
#import "AEAppDelegate.h"

@interface AEMainViewController ()

@end

@implementation AEMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space02"]];
//    
////      bgImageView.frame = self.view.bounds;
////      [self.view addSubview:bgImageView];
////      [self.view sendSubviewToBack:bgImageView];
    
//    UIImage *logo = [[UIImage alloc] initWithCIImage:[UIImage imageNamed:@"space02"]];
 //   logo.size
    _appDelegate = (AEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Load user preferences to get the profile currently logged in
    self.userPrefs = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Update the toolbar window and button appropriately
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI handling/actions
// Updates all UI elements that must respond to user profile context
- (void)updateUI {
    
    // Define strings to be used in bottom toolbar
    NSString *noProfileText = @"No Profile";
    NSString *logInButtonText = @"Log In";
    NSString *logOutButtonText = @"Log Out";
    
    // Get the name of the currently logged in profile
    NSString *activeProfileName = [self.userPrefs valueForKey:KEY_PROFILE_NAME];    
    
    // if there is no profile logged in (or a logout just occurred), reset the toolbar's left label text to "No Profile" and the right button's text to "Log In"
    if ([activeProfileName length] == 0) {
        NSLog(@"No active profile found. Updating bottom toolbar and disabling game & settings buttons.");
        [self.onePlayerStartButton setEnabled:NO];
        [self.twoPlayerStartButton setEnabled:NO];
        [self.settingsButton setEnabled:NO];
        self.profileNameButton.title = noProfileText;
        self.toolbarActionButton.title = logInButtonText;
    }
    
    // If a profile is logged in, update the left label to the name of the logged in profile, and and the right button's text to "Log Out"
    else {
        NSLog(@"Found an active profile (%@). Updating bottom toolbar and enabling game buttons.", activeProfileName);
        [self.onePlayerStartButton setEnabled:YES];
        [self.twoPlayerStartButton setEnabled:YES];
        [self.settingsButton setEnabled:YES];
        self.profileNameButton.title = activeProfileName;
        self.toolbarActionButton.title = logOutButtonText;
    }
}

#pragma mark - Navigation

// Override to support conditional segue with respect to bottom toolbar's action button
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    // Check if the segue about to be fired is the login segue
    if ([identifier isEqualToString:@"loginSegue"]) {
        // Check if a profile is logged in
        if ([[self.userPrefs valueForKey:KEY_PROFILE_NAME] length] > 0) {
            
            // A logged in profile exists. Log this profile out.
            [self.userPrefs setValue:nil forKey:KEY_PROFILE_NAME];
            [self.userPrefs setValue:nil forKey:KEY_PROFILE_HIGH_SCORE];
            [self.userPrefs setValue:nil forKey:KEY_PROFILE_SHIP_COLOR];
            [self.userPrefs setValue:nil forKey:KEY_PROFILE_DIFFICULTY];
            NSLog(@"Logged in profile is now logged out.");
            
            // update the UI and do not perform the segue.
            [self updateUI];
            return NO;
        }
    }
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Build an AEPlayer from the logged in information available in userPrefs to the child view
    AEPlayer *p = [[AEPlayer alloc] init];
    p.name = [self.userPrefs valueForKey:KEY_PROFILE_NAME];
    p.highScore = [self.userPrefs valueForKey:KEY_PROFILE_HIGH_SCORE];
    p.shipColor = [self.userPrefs valueForKey:KEY_PROFILE_SHIP_COLOR];
    p.difficulty = [[self.userPrefs valueForKey:KEY_PROFILE_DIFFICULTY] intValue];
    
    NSLog(@"Created AEPlayer object from logged in profile.");
    NSLog(@"Name: %@", p.name);
    NSLog(@"High Score: %@", p.highScore);
    NSLog(@"Ship Color: %@", p.shipColor);
    NSLog(@"Difficulty: %i", p.difficulty);
    
    // Segue from this screen to the Host Game/Join Game menu screen
    if ([[segue identifier] isEqualToString:@"TwoPlayerMenuSegue"]) {
        
        // Get reference to destination VC
        AETwoPlayerGameVC *destinationVC = [segue destinationViewController];
        
        // Write the AEPlayer object we just made to the destinationVC's loggedInPlayer property
        destinationVC.loggedInPlayer = p;
        NSLog(@"Sending AEPlayer object to Two Player Menu...");

    }
    
    // Segue from this view to the SKScene kicking off the actual game
    else if ([[segue identifier] isEqualToString:@"StartOnePlayerGameSegue"]) {
        
        // Get reference to destination VC
        AEGameSceneViewController *destinationVC = [segue destinationViewController];
        [_appDelegate.mcManager.session disconnect];
        // Write the AEPlayer object we just made to the destinationVC's loggedInPlayer property
        destinationVC.loggedInPlayer = p;
        NSLog(@"Sending AEPlayer object to One Player Game...");
    }
    
    // Segue from this view to the player settings screen
    if ([[segue identifier] isEqualToString:@"SettingsSegue"]) {
        
        // Get reference to destination VC
        AESettingsTableViewController *destinationVC = [segue destinationViewController];
        
        // Write AEPlayer object
        destinationVC.loggedInPlayer = p;
        NSLog(@"Sending AEPlayer object to Settings menu...");
    }
}

@end
