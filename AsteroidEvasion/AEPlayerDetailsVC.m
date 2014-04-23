//
//  AEPlayerDetailsVC.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEPlayerDetailsVC.h"
#import "AEPreferences.h"

@interface AEPlayerDetailsVC ()

@end

@implementation AEPlayerDetailsVC

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
    
    // Load the active user preferences and get the name of the user currently logged in
    self.userPrefs = [NSUserDefaults standardUserDefaults];
    NSString *loggedInName = [self.userPrefs stringForKey:KEY_PROFILE_NAME];
    NSLog(@"Name of logged in profile is: %@", loggedInName);
    
    // Disable the "Log In" button if the profile we are about to view is the profile currently logged in.
    if ([self.displayPlayer.name isEqualToString:loggedInName]) {
        [self.loginMenuButton setEnabled:NO];
    }
    
    // Fill the UI labels with information from the selected player object
    self.nameDisplayLabel.text = self.displayPlayer.name;
    self.highScoreDisplayLabel.text = self.displayPlayer.highScore;
    self.shipColorDisplayLabel.text = [NSString stringWithFormat:@"%i", self.displayPlayer.shipColor];
    self.difficultyDisplayLabel.text = [NSString stringWithFormat:@"%i", self.displayPlayer.difficulty];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method fired when login button is pressed.
- (IBAction)loginButtonPressed:(id)sender {
    
    //  Replace the information about the user currently logged in with the displayUser (the user whos information is currently being displayed)
    [self.userPrefs setValue:self.displayPlayer.name forKey:KEY_PROFILE_NAME];
    [self.userPrefs setValue:self.displayPlayer.highScore forKey:KEY_PROFILE_HIGH_SCORE];
    [self.userPrefs setValue:[NSString stringWithFormat:@"%i", self.displayPlayer.shipColor] forKey:KEY_PROFILE_SHIP_COLOR];
    [self.userPrefs setValue:[NSString stringWithFormat:@"%i", self.displayPlayer.difficulty] forKey:KEY_PROFILE_DIFFICULTY];
    NSLog(@"User %@ is now logged in.", self.displayPlayer.name);
    
    // Go back to the main view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
