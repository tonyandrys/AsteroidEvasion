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
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;

    // Create and configure the scene.
    NSLog(@"Building SKScene with height: %f width: %f", skView.bounds.size.height, skView.bounds.size.width);
    AEGameScene* scene = [[AEGameScene alloc] initWithSize:skView.bounds.size playerOne:self.loggedInPlayer];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // This game makes the most sense if we break up the scene into a cartesian plane, let (0,0) be the point in the center of the scene, and let (0,0) be the point of origin for adding nodes and sprites. Setting the anchor point to (0.5,0.5) allows this setup.
    scene.anchorPoint = CGPointMake(0.5, 0.5);
    
    // Present the scene.
    [skView presentScene:scene];
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space02"]];
//    bgImageView.frame = self.view.bounds;
//    [skView addSubview:bgImageView];
//    [skView sendSubviewToBack:bgImageView];
    
    
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
