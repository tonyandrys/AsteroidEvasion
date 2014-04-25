//
//  AEAppDelegate.m
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//
//

#import "AEAppDelegate.h"
#import "AEPlayer.h"
#import "AEPlayersVC.h"

@implementation AEAppDelegate {
    // holds Player objects as they are being created before being send to AEPlayersVC
    NSMutableArray *_players;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
      _mcManager = [[MCManager alloc] init];
    // FIXME: We will need to read all data from storage and create Player objects from it.
    _players = [NSMutableArray arrayWithCapacity:20];
    
    // Fill players array with test data
    AEPlayer *player = [[AEPlayer alloc] init];
    player.name = @"Player1";
    player.highScore = @"100";
    player.shipColor = 0;
    player.difficulty = 0;
    [_players addObject:player];
    
    player = [[AEPlayer alloc] init];
    player.name = @"Player2";
    player.highScore = @"50";
    player.shipColor = 1;
    player.difficulty = 1;
    [_players addObject:player];
    
    // Instantiate the Player List View Controller to write the built array of Players to it
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AEPlayersVC *playersVC = (AEPlayersVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"PlayersViewController"];
    
    // Update the array of Players associated with the VC
    playersVC.players = _players;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
