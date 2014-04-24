//
//  AETwoPlayerGameVC.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/22/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AETwoPlayerGameVC.h"
#import "AETwoPlayerJoinVC.h"

@interface AETwoPlayerGameVC ()

@end

@implementation AETwoPlayerGameVC

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
    
    // Write profile name to the bottom toolbar button/label
    self.toolbarProfileLabel.title = self.loggedInPlayer.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"TwoPlayerJoinSegue"]) {
        
        // Pass the logged in player object to the destinationVC
        AETwoPlayerJoinVC *destinationVC = [segue destinationViewController];
        destinationVC.loggedInPlayer = self.loggedInPlayer;
    }
}

@end
