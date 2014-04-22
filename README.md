Asteroid Evasion
================

## Documentation Guidelines
Since we often do work independently from each other, the best way to avoid confusion is to write documentation guidelines. When contributing to this project, please provide descriptive documentation for anything you add, change, or modify. These rules are *not* set in stone by any means, it's really just the style I wrote the first portion in. If you want to change something, just let me know. 

### Basics
- All classes should use the class prefix AE to avoid any name collisions with any libraries we may end up using.
- I grouped files with similar functionality together. Data models/plain objects in one folder, View Controllers in another, SpriteKit Scenes in another, etc. Feel free to create new groups if you can think of a more efficient way of organizing these files.
- Incomplete methods, members that need to be added, or things that don't work properly should be prefaced with a 
"FIXME: <description of problem/necessary change>". This will keep us from thinking things are broken when they really just haven't been written yet.

### Classes
It's helpful if every new class written contains a brief description of its purpose as well as documentation of its properties/methods and parameters.

```Objective-C
#import <Foundation/Foundation.h>

/*
 A Player is a data model for storing and retrieving user profiles (players). 
 
 A Player consists of:
 
 + A player name 
    string
 
 + A high score 
    unsigned integer
 
 + A ship color (used to color the ship in single player and represent this player in network games)
    unsigned integer representing one of many(?) ship colors
 
 + A difficulty level 
    unsigned integer representing one of four difficulty levels
 
 FIXME: Need to add a property to hold a player's profile image
 FIXME: Another problem would go here... etc
 */

@interface Player : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *highScore;
@property (readonly, assign) NSUInteger shipColor;
@property (readonly, assign) NSUInteger difficulty;

@end
```

