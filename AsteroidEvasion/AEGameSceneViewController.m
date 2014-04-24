//
//  AEVGameSceneiewController.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys. All rights reserved.
//

#import "AEGameSceneViewController.h"
#import "AEGameScene.h"

@implementation AEGameSceneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView* skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    NSLog(@"Configuring SKScene with height: %f width: %f", skView.bounds.size.height, skView.bounds.size.width);
    AEGameScene* scene = [[AEGameScene alloc] initWithSize:skView.bounds.size playerOne:self.loggedInPlayer];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
