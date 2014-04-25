//
//  AEAsteroid.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/24/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEAsteroid.h"
#import "AEBitmasks.h"
#import "AECategories.h"

@implementation AEAsteroid

- (id)init {
    return [self initWithImageNamed:@"asteroid"];
}

// Creates an asteroid of arbitrary size at a given point
- (id)initWithRadius:(CGSize)size position:(CGPoint)pos {
    self = [super init];
    if (self) {
        self.size = size;
        self.position = pos;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:size.width/2];
        self.physicsBody.friction = 0.1f; // Asteroids should have no friction
        self.physicsBody.restitution = 1.0f; // Restitution = "bounciness", we want elastic collisions with no energy loss
        self.physicsBody.linearDamping = 0.0f; // Linear dampening = air friction - there's none of that shit in space
        self.physicsBody.allowsRotation = YES; // Asteroids should rotate maybe
        self.physicsBody.categoryBitMask = BITMASK_ASTEROID_CATEGORY; // Assign asteroid category bitmask, all asteroids will have the same for now (they will not collide with each other, which we will eventually want to change)
        self.physicsBody.contactTestBitMask = BITMASK_SHIP_CATEGORY; // Notify if the asteroid makes contact with the ship
    }
    return self;
}

@end
