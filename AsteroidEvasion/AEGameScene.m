//
//  AEGameScene.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEGameScene.h"
#import "AECategories.h"
#import "AEBitmasks.h"
#import "AEAsteroid.h"
#import "AEGameOverScene.h"
#import "FirstViewController.h"
#import "AEAppDelegate.h"
#import "AEPreferences.h"

// Radius of the circle used as the ship's path
float circleRadius;

// Asteroid launching information is stored here. Each key contains a launching point and the force vector that should be applied. Eventually I'd like to get rid of this and just generate this all randomly (and derive a general function for calculating the force vector for an arbitrary point (x,y)), but for the alpha I think this is fine.
NSMutableDictionary *asteroidLaunchPoints;

// Asteroid Timer - When fired, spawn a new asteroid and increment player's score
NSTimeInterval fireInterval = 3;
NSTimer *asteroidTimer;

// Score increment timer - When fired, increments player's score and updates corresponding SKLabel
NSTimeInterval scoreIncrementInterval = 1;
NSTimer *scoreIncrementTimer;

// Asteroid launch points key string constants
NSString *const KEY_ASTEROID_POSITION = @"keyAsteroidPosition";
NSString *const KEY_ASTEROID_VECTOR_DX = @"keyAsteroidVectorDx";
NSString *const KEY_ASTEROID_VECTOR_DY = @"keyAsteroidVectorDy";
CGRect circle;

// Circle diameter constraints
float const CIRCLE_DIAMETER_MAX = 300;
float const CIRCLE_DIAMETER_MIN = 30;

// Reference points to make positioning easier, as frame's origin is in the center of the screen
// x values vary from (-width/2, 0) U (0,width/2)
// y values vary from (-height/2, 0) U (0,height/2)
CGPoint bottomLeftPoint;
CGPoint bottomRightPoint;
CGPoint topLeftPoint;
CGPoint topRightPoint;

@implementation AEGameScene

-(id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1 {
    if (self = [super initWithSize:size]) {
        self.asteroidChanger = 0;
        // Store AEPlayer to property
        self.playerOne = p1;
        
        // Set player's score to zero
        self.playerScore = 0;
    
        // Fill the asteroid launch point dictionary
        asteroidLaunchPoints = [self buildAsteroidLaunchDictionary];
        
        // Determine asteroid launch interval by checking the difficulty setting of the user
        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        NSInteger difficulty = [[userPrefs valueForKey:KEY_PROFILE_DIFFICULTY] integerValue];
        if (difficulty == 3) {
            fireInterval = 1.0f;
        } else if (difficulty == 2) {
            fireInterval = 2.0f;
        } else if (difficulty == 1) {
            fireInterval = 3.0f;
        } else if (difficulty == 0) {
            fireInterval = 4.0f;
        }
        NSLog(@"Fire interval set: %f", fireInterval);
        
        // Setup the scene
        [self buildScene];
        
       
//        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"space05"];
//        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
//        [self addChild:bgImage];
        _appDelegate = (AEAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        }
    
    return self;
}

#pragma mark - Scene Setup and Object Creation

// Builds and returns the asteroid launch dictionary from hardcoded points
- (NSMutableDictionary *)buildAsteroidLaunchDictionary {
    
    // Reference points to make positioning easier, as frame's origin is in the center of the screen
    // x values vary from (-width/2, 0) U (0,width/2)
    // y values vary from (-height/2, 0) U (0,height/2)
    bottomLeftPoint = CGPointMake(-self.frame.size.width/2, -self.frame.size.height/2); // Quadrant III
    bottomRightPoint = CGPointMake(self.frame.size.width/2, -self.frame.size.height/2); // Quadrant IV
    topLeftPoint = CGPointMake(-self.frame.size.width/2, self.frame.size.height/2); // Quadrant II
    topRightPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2); // Quadrant I
    
    // Define array of launch points (launch point number == index number-1)
    // -----------------------------
    // (6)   (7)   (8)   (9)   (10) |
    //                              |
    //                              |
    //                              |
    //        origin - (0,0)        |
    //                              |
    //                              |
    //                              |
    // (1)   (2)   (3)   (4)   (5)  |
    // -----------------------------
    
    // Hardcode launch points in (for now)
    NSArray *launchPoints = [NSArray arrayWithObjects:
                             [NSValue valueWithCGPoint:CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width * (0.33f), bottomLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, bottomLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width * (0.66f), bottomLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width, bottomLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(topLeftPoint.x, topLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width * (0.33f), topLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, topLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width * (0.66f), topLeftPoint.y)],
                             [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width, topLeftPoint.y)],
                             nil];
    
    // Apparently I can't wrap a CGVector in an NSValue, so here comes a C array
    // Index of each vector corresponds to launchPoint
    CGVector launchVectors[] = {CGVectorMake(15.0f, 15.0f), CGVectorMake(10.0f, 15.0f), CGVectorMake(0.0f, 15.0f), CGVectorMake(-10.0f, 15.0f), CGVectorMake(-15.0f, 15.0f), CGVectorMake(15.0f, -15.0f), CGVectorMake(10.0f, -15.0f), CGVectorMake(0.0f, -15.0f), CGVectorMake(-10.0f, -15.0f), CGVectorMake(-15.0f, -15.0f)};

    // Initialize a new dictionary to add points/vectors to
    NSMutableDictionary *pointDictionary = [[NSMutableDictionary alloc] init];
    
    // For every launch point, create a dictionary that contains the location and the force vector to be applied to an asteroid spawned at that location. Store it as key="i" to be referenced by the pseudorandom number generator.
    for (int i=0; i<[launchPoints count]; i++) {
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        
        [d setValue:[launchPoints objectAtIndex:i] forKey:KEY_ASTEROID_POSITION];
        
        // Force vector unfortunately has to be stored as two separate floats
        [d setValue:[NSNumber numberWithFloat:launchVectors[i].dx] forKey:KEY_ASTEROID_VECTOR_DX];
        [d setValue:[NSNumber numberWithFloat:launchVectors[i].dy] forKey:KEY_ASTEROID_VECTOR_DY];
        
        // Add the newly created dictionary to the master dictionary as key @"i"
        [pointDictionary setValue:d forKey:[NSString stringWithFormat:@"%i", i]];
        
        // Ridiculous logging statements
        NSLog(@"Key %i: ", i);
               NSLog(@"Added launch point (%f, %f) with force vector (%f, %f)", [[d valueForKey:KEY_ASTEROID_POSITION] CGPointValue].x, [[d valueForKey:KEY_ASTEROID_POSITION] CGPointValue].y, [[d valueForKey:KEY_ASTEROID_VECTOR_DX] floatValue], [[d valueForKey:KEY_ASTEROID_VECTOR_DY] floatValue]);
    }
    
    // Return the master dictionary
    return pointDictionary;
}

// Builds all visual elements and sets up the scene
- (void)buildScene {

    /* Configure scene background */
    self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"space02"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
    // Configure SKSCene physics
    self.physicsWorld.contactDelegate = self;
    
    // No gravity should be used in this game, asteroids should be able to be pushed in any direction
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    /* Build text labels */
    
    // Tony, I commented out the following and added functionality to update score method to keep long name from overlapping with score
    // if that wasn't okay, go ahead and change it. - Pat
    
    /* Player name label
    SKLabelNode *playerNameLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    playerNameLabel.text = [NSString stringWithFormat:@"%@:", self.playerOne.name];
    playerNameLabel.fontSize = 18;
    playerNameLabel.fontColor = [self.playerOne getShipColorAsUIColor];
    playerNameLabel.position = CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y + 5.0);
    playerNameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    playerNameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:playerNameLabel];*/
    
    // Player score label
    self.playerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    self.playerScoreLabel.text = @"0"; // start at a score of zero
    self.playerScoreLabel.fontSize = 18;
    self.playerScoreLabel.fontColor = [self.playerOne getShipColorAsUIColor];
    self.playerScoreLabel.position = CGPointMake(bottomLeftPoint.x + 0.0, bottomLeftPoint.y + 5.0);
    self.playerScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    self.playerScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:self.playerScoreLabel];
    
    self.player2Score = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    //self.player2Score.text = @"0"; // start at a score of zero
    self.player2Score.fontSize = 18;
    self.player2Score.fontColor = [UIColor redColor];
    self.player2Score.position = CGPointMake(bottomLeftPoint.x + 0.0, bottomLeftPoint.y + 25.0);
    self.player2Score.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    self.player2Score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:self.player2Score];
    
    // Draw circle (path for ship)
    // x origin position, y origin position, width, height
    //CGRect circle = CGRectMake(bottomLeftPoint.x + 12.5, bottomRightPoint.y + 85.0, self.frame.size.width - 25.0, self.frame.size.height - 100.0);
    circle = CGRectMake(bottomLeftPoint.x + 12.5, self.frame.origin.y-150.0, 300, 300);
    SKShapeNode *circleShapeNode = [[SKShapeNode alloc] init];
    circleShapeNode.name = NAME_CATEGORY_CIRCLE;
    circleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    circleShapeNode.strokeColor = [UIColor whiteColor];
    circleShapeNode.fillColor = nil;
    
    // Store the radius of the circle for conversion purposes
    circleRadius = circleShapeNode.frame.size.width/2;
    
    [self addChild: circleShapeNode];
    
     // Build player's ship node
    SKSpriteNode *ship = [self buildShipNodeByColorString:self.playerOne.shipColor];
    ship.name = NAME_CATEGORY_SHIP;
    
    // Define physics body of ship
    ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ship.frame.size.width/2];
    ship.physicsBody.restitution = 0.1f;
    ship.physicsBody.friction = 0.4f;
    ship.physicsBody.categoryBitMask = BITMASK_SHIP_CATEGORY;
    
    // The ship's physics body should be dynamic, or not react to forces or impulses from other objects (be thrown off path by a moving asteroid for example)
    ship.physicsBody.dynamic = NO;
    
    // Place at right edge of circle's border
    ship.position = CGPointMake(self.frame.origin.x + circleShapeNode.frame.size.width/2, self.frame.origin.y);
  
    [self addChild:ship];
    
    // Build and start the asteroid and score increment timer
    asteroidTimer = [NSTimer scheduledTimerWithTimeInterval:fireInterval target:self selector:@selector(generateNewAsteroid) userInfo:nil repeats:YES];
    
    // Start score increment timer
    scoreIncrementTimer = [NSTimer scheduledTimerWithTimeInterval:scoreIncrementInterval target:self selector:@selector(incrementPlayerScoreByOne) userInfo:nil repeats:YES];
}

// Returns the appropriate ship image based on the shipColor property of a user
-(SKSpriteNode *)buildShipNodeByColorString:(NSString *)colorString {
    
    // Initialize an SKSpriteNode using the default ship image in the event we're passed the default color string (White) OR the color string does not match a ship image.
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"spaceshipsOutlined.png"];
    
    if ([colorString isEqualToString:@"Red"]) {
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"resizedSpaceshipsOutlinedR"];
    } else if ([colorString isEqualToString:@"Green"]) {
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"resizedSpaceshipsOutlinedG"];
    } else if ([colorString isEqualToString:@"Orange"]) {
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"resizedSpaceshipsOutlinedO"];
    } else if ([colorString isEqualToString:@"Yellow"]) {
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"resiszedSpaceshipsOutlinedY"];
    } else if ([colorString isEqualToString:@"Purple"]) {
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"resizedSpaceshipsOutlinedP"];
    }
    return ship;
}

#pragma mark - Asteroid generation & control methods
// Generates an asteroid using the stored locations and vectors when given an index to pull data from
-(void)generateNewAsteroid {
    
    // Get a random index value inside the size of asteroidLaunchPoints
    int i = [self generateRandomNumberBetween:0 maxNumber:([asteroidLaunchPoints count]-1)];
    
    // Convert the number into a string to use as a key for the asteroid launch points dictionary
    NSString *k = [NSString stringWithFormat:@"%i", i];
    
    // Get the dictionary located at key @"k" and extract launch parameters
    NSDictionary* launchParameters = [asteroidLaunchPoints objectForKey:k];
    
    CGPoint launchPosition = [[launchParameters valueForKey:KEY_ASTEROID_POSITION] CGPointValue];
    CGVector launchVector = CGVectorMake([[launchParameters valueForKey:KEY_ASTEROID_VECTOR_DX] floatValue], [[launchParameters valueForKey:KEY_ASTEROID_VECTOR_DY] floatValue]);
    CGSize asteroidSize = CGSizeMake(75.0f, 75.0f); // Hardcoding size for now

    // Fire a new asteroid at the stored position using the stored force vector
    [self generateAsteroidAt:launchPosition withSize:asteroidSize withForce:launchVector];
    
    
}

// Generates an asteroid with arbitrary position, size, and force (linear impulse only)
-(void)generateAsteroidAt:(CGPoint)pos withSize:(CGSize)size withForce:(CGVector)force {
    
    // Configure node
    //sets it so every three asteroids is the brown one else the gray
    if(self.asteroidChanger % 3 == 0)
    {
        SKSpriteNode* asteroid = [[SKSpriteNode alloc] initWithImageNamed:@"meteor1"];
        self.asteroidChanger++;
        asteroid.name = NAME_CATEGORY_ASTEROID;
        asteroid.position = pos;
        asteroid.size = size;
        
        // Configure physics body
        asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:size.width/2];
        asteroid.physicsBody.friction = 0.1f; // Asteroids should have no friction
        asteroid.physicsBody.restitution = 1.0f; // Restitution- we want elastic collisions with no energy loss
        asteroid.physicsBody.linearDamping = 0.0f; // Linear dampening = air friction - there's none of that shit in space
        asteroid.physicsBody.allowsRotation = YES; // Asteroids should rotate maybe
        asteroid.physicsBody.categoryBitMask = BITMASK_ASTEROID_CATEGORY; // Assign asteroid category bitmask, all asteroids will have the same for now (they will not collide with each other, which we will eventually want to change)
        asteroid.physicsBody.contactTestBitMask = BITMASK_SHIP_CATEGORY; // Notify if the asteroid makes contact with the ship
        
        // Add to SKScene
        NSLog(@"Generated asteroid at (%f. %f) with force dx=%f, dy=%f)", pos.x, pos.y, force.dx, force.dy);
        [self addChild:asteroid];
        // After asteroid is added, apply linear impulse
        [asteroid.physicsBody applyImpulse:force];
    }
    else
    {
        
        SKSpriteNode* asteroid = [[SKSpriteNode alloc] initWithImageNamed:@"meteor2"];
        self.asteroidChanger++;
        asteroid.name = NAME_CATEGORY_ASTEROID;
        asteroid.position = pos;
        asteroid.size = size;
        
        // Configure physics body
        asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:size.width/2];
        asteroid.physicsBody.friction = 0.1f; // Asteroids should have no friction
        asteroid.physicsBody.restitution = 1.0f; // Restitution- we want elastic collisions with no energy loss
        asteroid.physicsBody.linearDamping = 0.0f; // Linear dampening = air friction - there's none of that shit in space
        asteroid.physicsBody.allowsRotation = YES; // Asteroids should rotate maybe
        asteroid.physicsBody.categoryBitMask = BITMASK_ASTEROID_CATEGORY; // Assign asteroid category bitmask, all asteroids will have the same for now (they will not collide with each other, which we will eventually want to change)
        asteroid.physicsBody.contactTestBitMask = BITMASK_SHIP_CATEGORY; // Notify if the asteroid makes contact with the ship
        
        // Add to SKScene
        NSLog(@"Generated asteroid at (%f. %f) with force dx=%f, dy=%f)", pos.x, pos.y, force.dx, force.dy);
        [self addChild:asteroid];
        // After asteroid is added, apply linear impulse
        [asteroid.physicsBody applyImpulse:force];
    }
    
}

#pragma mark - Scoring Methods

// Increments the players score by one and updates the on screen UI
-(void) incrementPlayerScoreByOne {
    
    // Update score in model
    self.playerScore += 1;
    
    // Update on screen score label to the player's current score
    self.playerScoreLabel.text = [NSString stringWithFormat:@"%@:%i", self.playerOne.name, self.playerScore];
   
    if(_appDelegate.mcManager.session.connectedPeers != nil){ // if two player game and connected with another
        NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:self.playerScore]]; // will send current player score
        NSError *error; // needed for sendData function
        self.playerScoreLabel.fontColor = [UIColor blueColor];
        self.playerScoreLabel.position = CGPointMake(bottomLeftPoint.x + 0.0, bottomLeftPoint.y + 5.0);
        self.playerScoreLabel.text = [NSString stringWithFormat:@"%@:%i", [_appDelegate.mcManager.self.peerID displayName], self.playerScore];
        
        if (!self.isDead) {
        [_appDelegate.mcManager.session sendData:dataToSend
                                         toPeers:_appDelegate.mcManager.session.connectedPeers
                                        withMode:MCSessionSendDataReliable
                                           error:&error]; // crucial for sending
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveDataWithNotification:)
                                                     name:@"MCDidReceiveDataNotification"
                                                   object:nil]; // receiver
     
        self.player2Score.text = [NSString stringWithFormat:@"%@:%i", [[_appDelegate.mcManager.session.connectedPeers lastObject] displayName], self.player2S];
    }
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
   // MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
   // NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    //NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSNumber *numberReceived = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];

    self.player2S = [numberReceived intValue]; // sets value for player 2 score
}

# pragma mark - Touch handling

// Called when a touch begins
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

// Moves the player's ship deltaX units around the circle
-(void) moveShipX:(NSInteger)deltaX {
    
    // Get a reference to the ship node by its name to change its position
    SKSpriteNode* playerShip = (SKSpriteNode *)[self childNodeWithName:NAME_CATEGORY_SHIP];
    
    // Calculate difference in radians
    double dTheta =  deltaX * (M_PI/180);
    
    // Calculate the ship's new position by getting its polar position, taking the sum of theta and the touch x difference, and updating the ship's position
    CGPoint currentShipPosition = CGPointMake(playerShip.position.x, playerShip.position.y);
    //NSLog(@"Ship's current position is (%f, %f)", ship.position.x, ship.position.y);
    //NSLog(@)
    
    double rad = [self getRadiusFromPoint:currentShipPosition];
    double theta = [self getThetaFromPoint:currentShipPosition];
    //NSLog(@"Ship's current polar position is (%f, %f)", rad, theta);
    
    // Add the change in theta to the original theta
    double thetaPrime = theta + dTheta;
    
    // Convert r and theta back to their cartesian equivalent to set the position of the node
    CGPoint newShipPosition = [self polarToCartesian:rad theta:thetaPrime];
    
    // Set rotation of the ship based on its movement
    //checks to make sure it is moving in ONLY the x direction
    if(self.movingX)
    {
        if(dTheta >= 0) {
            playerShip.zRotation = theta;
        } else {
            playerShip.zRotation = theta - 160.3;
        }
    }
    
    // Update ship position
    playerShip.position = newShipPosition;
    //NSLog(@"Ship is now positioned at (%f, %f)", ship.position.x, ship.position.y);
}

// Moves the player's ship deltaY units to/from the center of the screen and redraws the on-screen circle accordingly
-(void) moveShipY:(NSInteger)deltaY {
    
    // Get a reference to the ship and circle nodes to modify their properties
    SKSpriteNode *playerShip = (SKSpriteNode *)[self childNodeWithName:NAME_CATEGORY_SHIP];
    SKShapeNode *circleShapeNode = (SKShapeNode *)[self childNodeWithName:NAME_CATEGORY_CIRCLE];
    
    // Calculate the ship's new position by getting its radius from its polar position and setting its new radius as the sum of the previous radius + deltaY
    CGPoint currentShipPosition = CGPointMake(playerShip.position.x, playerShip.position.y);
    double newRadius = [self getRadiusFromPoint:currentShipPosition] - deltaY; // Add deltaY
    double theta = [self getThetaFromPoint:currentShipPosition]; // Get Q, but do not change Q (ship's polar rotation)
    
    // Check if the diameter of the circle is within the MIN/MAX constraints to prevent the ship from moving too close to the middle or off of the screen
    if ((newRadius*2 > CIRCLE_DIAMETER_MAX) || (newRadius*2 < CIRCLE_DIAMETER_MIN)){
        NSLog(@"Circle bounds have been reached!");
        return;
    }
    
    // If we are within the MIN/MAX constraints, perform the movement of the ship and resize the circle
    else {
    
        // Convert r and theta back to their cartesian equivalent to set the position of the node
        CGPoint newShipPosition = [self polarToCartesian:newRadius theta:theta];
        
        // Add/subtract the height/width of the circle model by deltaY
        float circleHeight = circleShapeNode.frame.size.height;
        float circleWidth = circleShapeNode.frame.size.width;
        
        // Update the circle model so we can use this change as a reference point for future changes
        circle = CGRectMake(circle.origin.x += deltaY, circle.origin.y += deltaY, circleHeight - (deltaY*2), circleWidth - (deltaY*2));
        
        // Change the rotation of the ship to correctly animate moving toward the screen or away from it
    
        if (deltaY > 0) {
            
        //checks to make sure it is moving inward or outward (so it doesnt flicker from rotation)
            if(self.movingY)
            {
            // If we are moving up, rotate the ship towards the center of the circle
                playerShip.zRotation = theta+58.05;
            }
            
            // Set the moving up flag for the ship so rotation doesn't happen again until direction changes
        //    playerShip.zRotation = theta + 80;
         //   self.isShipMovingUp = YES;
         //   self.isShipMovingDown = NO;
            
        } else if (deltaY < 0) {
            
            //checks to make sure it is moving inward or outward (so it doesnt flicker from rotation)
                if(self.movingY)
                {
            // If we are moving down, rotate the ship away from the center of the circle
                    playerShip.zRotation= theta + 55;
                }
            
            
            // Set the moving flags for the ship so rotation doesn't happen again until direction changes
        //    self.isShipMovingDown = YES;
        //    self.isShipMovingUp = NO;
        }
        
        // Apply the circle height changes to the circleNode
        circleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
        
        // Update ship position
        playerShip.position = newShipPosition;
    }
    

}

// Refactor into moveShipX and moveShipY ***
// Fired when the finger moves within a view
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // We want the user to be able to pan from anywhere on the screen, so recognize a touch on any node or area in the scene
    UITouch *touch = [touches anyObject];
        
    // Get the touch location and the previous touch location
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    
    // Check if the user is panning to the right (positive x difference), to the left (negative x difference), to the top (positive y difference), or to the bottom (negative y difference)
    NSInteger deltaX = touchLocation.x - previousLocation.x;
    NSInteger deltaY = touchLocation.y - previousLocation.y;
    
    // If there is a change in position of the touch, trigger ship movement
    if (previousLocation.x != touchLocation.x || previousLocation.y != touchLocation.y) {
        
        // If a change in X is detected, move around the circle X degrees
        
        //sets a threshold so the ship doesnt rotate and move if you swipe slightly up
        //      down along with your X direction swipe
        if (deltaX >= 3 || deltaX <= -3) {
            
            // Move the ship deltaX units around the circle
            [self moveShipX:deltaX];
            self.movingX=YES;
            self.movingY = NO;
        }
        
        // If a change in Y is detected, move the ship towards or away from the center of the screen
        
        //sets a threshold so the ship doesnt rotate and move if you swipe slightly sideways
        //       along with your Y direction swipe
        else if (deltaY >= 3 || deltaY <= -3) {
            
            // Move the ship deltaY units around the circle
            [self moveShipY:deltaY];
            self.movingX = NO;
            self.movingY = YES;
        }
    }

}

#pragma mark - Collision Handling

/* Method called when contact is made between two nodes with different collision bitmasks. */
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    // If a collision happens between the ship and an asteroid, the game is over. Build the endgame scene and pass the player's final score
    AEGameOverScene* gameOverScene = [[AEGameOverScene alloc] initWithSize:self.frame.size playerScore:self.playerScore];
    
    // Pass player model to game over scene
    gameOverScene.playerOne = self.playerOne;
    
    // Kill the asteroid launch timer
    [asteroidTimer invalidate];
    
    self.isDead = true;
        
    // Present the game over screen
    [self.view presentScene:gameOverScene];
    
}



#pragma mark - Math

// Converts a set of polar coordinates (r, theta) to their cartesian equivalent (x,y)
- (CGPoint)polarToCartesian:(double)r theta:(double)q {
    double x = r * cos(q);
    double y = r * sin(q);
    //NSLog(@"Converting] polar (%f %f) to cartesian is (%f, %f)", r, q, x, y);
    return CGPointMake(x,y);
}

// Returns the polar radius given a pair of cartesian (x,y) coordinates
- (double)getRadiusFromPoint:(CGPoint)pair {
    double rad = sqrt(((pair.x * pair.x) + (pair.y * pair.y)));
    return rad;
}

// Returns the polar angle (theta) given a pair of cartesian (x,y) coordinates
- (double)getThetaFromPoint:(CGPoint)pair {
    return atan2(pair.y, pair.x);
}

// Converts degrees to radians
- (double)degToRad:(double)degrees {
	return degrees / 180.0f * M_PI;
}

// Converts radians to degrees
- (double)radToDeg:(double)radians {
    return radians * (180.0 / M_PI);
}

// Generates and returns a pseudorandom number on the interval [min, max]
- (NSInteger)generateRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random() % (max - min + 1);
}

# pragma mark - Frame Update Handler

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
}

@end
