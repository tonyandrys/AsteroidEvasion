//
//  AEMainViewController.m
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//
//

#import "AEMainViewController.h"
#import "AEPreferences.h"

@interface AEMainViewController ()

@end

@implementation AEMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load user preferences to get the profile currently logged in
    self.userPrefs = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog (@"wiewWillAppear is called");
    
    // Update the toolbar window and button appropriately
    [self updateToolbarUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI handling/actions
// Updates the button actions and left label of the bottom UIToolbar based on the currently logged in profile
- (void)updateToolbarUI {
    
    // Define strings to be used in bottom toolbar
    NSString *noProfileText = @"No Profile";
    NSString *logInButtonText = @"Log In";
    NSString *logOutButtonText = @"Log Out";
    
    // Get the name of the currently logged in profile
    NSString *activeProfileName = [self.userPrefs valueForKey:KEY_PROFILE_NAME];
    
    // if there is no profile logged in (or a logout just occurred), reset the toolbar's left label text to "No Profile" and the right button's text to "Log In"
    if ([activeProfileName length] == 0) {
        NSLog(@"No active profile found. Updating bottom toolbar.");
        self.profileNameButton.style = d
        self.profileNameButton.title = noProfileText;
        self.toolbarActionButton.title = logInButtonText;
    }
    
    // If a profile is logged in, update the left label to the name of the logged in profile, and and the right button's text to "Log Out"
    else {
        NSLog(@"Found an active profile (%@). Updating bottom toolbar.", activeProfileName);
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
            
            // update the UI and do not perform the segue.
            [self updateToolbarUI];
            return NO;
        }
    }
    return YES;
}

/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
