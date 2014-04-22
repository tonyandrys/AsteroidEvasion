//
//  AENewPlayerVC.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AENewPlayerVC.h"

@interface AENewPlayerVC ()

@end

@implementation AENewPlayerVC

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate AENewPlayerVCDidCancel:self];
}

- (IBAction)done:(id)sender {
    
    // Build a new Player object from the user's input
    AEPlayer *player = [[AEPlayer alloc] init];
    
    //FIXME: Ensure the name field is non-empty
    player.name = self.nameTextField.text;
    player.highScore = @"0";
    
    // FIXME: Assign ship color and difficulty automatically for now
    player.shipColor = 0;
    player.difficulty = 0;
    
    NSLog(@"New Player (%@) created.", player.name);
    
    // Send this new object to the delegate VC to be added to the TableView
    [self.delegate AENewPlayerVCDidSave:self didAddPlayer:player];
}

@end
