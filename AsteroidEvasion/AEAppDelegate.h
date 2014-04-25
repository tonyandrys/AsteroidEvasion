//
//  AEAppDelegate.h
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface AEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MCManager *mcManager;

@end
