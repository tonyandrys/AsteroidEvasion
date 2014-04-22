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
    [self.delegate AENewPlayerVCDidSave:self];
}

@end
