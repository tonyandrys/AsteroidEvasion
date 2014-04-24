//
//  AEMyScene.m
//  AsteroidEvasion
//
//  Created by Tony on 4/21/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEGameScene.h"

// Game object identification constants
static NSString *shipCategoryName = @"ship";

// Bitmasks
static const uint32_t SHIP_CATEGORY = 0x1 << 0; // 00000000000000000000000000000001
static const uint32_t ASTEROID_CATEGORY = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t POWERUP_CATEGORY = 0x1 << 2; // 00000000000000000000000000000100

// Radius of the circle used as the ship's path
float circleRadius;

@implementation AEGameScene

-(id)initWithSize:(CGSize)size playerOne:(AEPlayer *)p1 {
    if (self = [super initWithSize:size]) {
        
        // Store AEPlayer to property
        self.playerOne = p1;
        
        // Set player's score to zero
        self.playerScore = 0;
        
        // Setup the scene
        [self buildScene];
        
        }
    
    return self;
}

#pragma mark - Scene Setup and Object Creation

// Builds all visual elements and sets up the scene
- (void)buildScene {
    
    // Reference points to make positioning easier, as frame's origin is in the center of the screen
    // x values vary from (-width/2, 0) U (0,width/2)
    // y values vary from (-height/2, 0) U (0,height/2)
    
    CGPoint bottomLeftPoint = CGPointMake(-self.frame.size.width/2, -self.frame.size.height/2); // Quadrant III
    CGPoint bottomRightPoint = CGPointMake(self.frame.size.width/2, -self.frame.size.height/2); // Quadrant IV
    CGPoint topLeftPoint = CGPointMake(-self.frame.size.width/2, self.frame.size.height/2); // Quadrant II
    CGPoint topRightPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2); // Quadrant I
    
    // plotting test circles
    CGRect bLCircle = CGRectMake(bottomLeftPoint.x, bottomLeftPoint.y, 25.0, 25.0);
    CGRect bRCircle = CGRectMake(bottomRightPoint.x-25.0, bottomRightPoint.y, 25.0, 25.0);
    CGRect tLCircle = CGRectMake(topLeftPoint.x, topLeftPoint.y-25.0, 25.0, 25.0);
    CGRect tRCircle = CGRectMake(topRightPoint.x-25.0, topRightPoint.y-25.0, 25.0, 25.0);
    
    SKShapeNode *bLCircleShapeNode = [[SKShapeNode alloc] init];
    SKShapeNode *bRCircleShapeNode = [[SKShapeNode alloc] init];
    SKShapeNode *tLCircleShapeNode = [[SKShapeNode alloc] init];
    SKShapeNode *tRCircleShapeNode = [[SKShapeNode alloc] init];
    
    bLCircleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:bLCircle].CGPath;
    bRCircleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:bRCircle].CGPath;
    tLCircleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:tLCircle].CGPath;
    tRCircleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:tRCircle].CGPath;
    
    bLCircleShapeNode.strokeColor = [UIColor redColor];
    [self addChild:bLCircleShapeNode];
    
    bRCircleShapeNode.strokeColor = [UIColor yellowColor];
    [self addChild:bRCircleShapeNode];
    
    tLCircleShapeNode.strokeColor = [UIColor greenColor];
    [self addChild:tLCircleShapeNode];
    
    tRCircleShapeNode.strokeColor = [UIColor blueColor];
    [self addChild:tRCircleShapeNode];
    
    
    /* Configure scene background */
    self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    
    /* Build text labels */
    // Player name label
    SKLabelNode *playerNameLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    playerNameLabel.text = [NSString stringWithFormat:@"%@:", self.playerOne.name];
    playerNameLabel.fontSize = 18;
    playerNameLabel.fontColor = [UIColor whiteColor];
    playerNameLabel.position = CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y + 5.0);
    playerNameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    playerNameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:playerNameLabel];
    
    // Player score label
    SKLabelNode *playerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    playerScoreLabel.text = @"0"; // start at a score of zero
    playerScoreLabel.fontSize = 18;
    playerScoreLabel.fontColor = [UIColor whiteColor];
    playerScoreLabel.position = CGPointMake(bottomLeftPoint.x + 50.0, bottomLeftPoint.y + 5.0);
    playerScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    playerScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:playerScoreLabel];
    
    // Draw circle (path for ship)
    // x origin position, y origin position, width, height
    //FIXME change to oval!!
    //CGRect circle = CGRectMake(bottomLeftPoint.x + 12.5, bottomRightPoint.y + 85.0, self.frame.size.width - 25.0, self.frame.size.height - 100.0);
    CGRect circle = CGRectMake(bottomLeftPoint.x + 12.5, self.frame.origin.y-150.0, 300, 300);
    
    SKShapeNode *circleShapeNode = [[SKShapeNode alloc] init];
    circleShapeNode.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    circleShapeNode.strokeColor = [UIColor whiteColor];
    circleShapeNode.fillColor = nil;
    
    // Store the radius of the circle for conversion purposes
    circleRadius = circleShapeNode.frame.size.width/2;
    
    [self addChild: circleShapeNode];
    
     // Draw ship (place at 0rad on circle)
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"ship2.png"];
    ship.name = shipCategoryName;
    
    // Define physics body of ship
    ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ship.frame.size.width/2];
    ship.physicsBody.restitution = 0.1f;
    ship.physicsBody.friction = 0.4f;
    ship.physicsBody.categoryBitMask = SHIP_CATEGORY;
    
    // The ship's physics body should be dynamic, or not react to forces or impulses from other objects (be thrown off path by a moving asteroid for example)
    ship.physicsBody.dynamic = NO;
    
    // Place at right edge of circle's border
    ship.position = CGPointMake(self.frame.origin.x + circleShapeNode.frame.size.width/2, self.frame.origin.y);
    [self addChild:ship];
    
    

}



# pragma mark - Touch handling

// Called when a touch begins
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get an instance of the touch and store the location of the touch event
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
}

// Fired when the finger moves within a view
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // We want the user to be able to pan from anywhere on the screen, so recognize a touch on any node or area in the scene
    UITouch *touch = [touches anyObject];
        
    // Get the touch location and the previous touch location
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    
    // Check if the user is panning to the right (positive x difference) or to the left (negative x difference)
    NSInteger difference = touchLocation.x - previousLocation.x;
    NSLog(@"Touch x difference is %i", difference);
    
    // Get a reference to the ship node by its name to change its position
    SKSpriteNode* ship = (SKSpriteNode *)[self childNodeWithName:shipCategoryName];
    
    // Calculate the ship's new position by getting its polar position, taking the sum of theta and the touch x difference, and updating the ship's position
    CGPoint currentShipPosition = CGPointMake(ship.position.x, ship.position.y);
    double rad = circleRadius; //[self getRadiusFromPoint:currentShipPosition];
    double theta = [self getThetaFromPoint:currentShipPosition];
    
    // Convert theta to degrees and add the touch x difference
    double thetaInDegrees = [self radToDeg:theta];
    double sum = thetaInDegrees + difference;
    
    // Convert back to radians and convert r and theta back to their cartesian equivalent to set the position of the node
    double thetaInRadians = [self degToRad:sum];
    CGPoint newShipPosition = [self polarToCartesian:rad theta:thetaInRadians];
    
    // Update ship position
    ship.position = newShipPosition;
    NSLog(@"Ship is now positioned at (%f, %f)", ship.position.x, ship.position.y);
}

#pragma mark - Math

// Converts a set of polar coordinates (r, theta) to their cartesian equivalent (x,y)
- (CGPoint)polarToCartesian:(double)r theta:(double)q {
    double x = r * cos(q);
    double y = r * sin(q);
    NSLog(@"Converting] polar (%f %f) to cartesian is (%f, %f)", r, q, x, y);
    return CGPointMake(x,y);
}

// Returns the polar radius given a pair of cartesian (x,y) coordinates
- (double)getRadiusFromPoint:(CGPoint)pair {
    double rad = sqrt(((pair.x * pair.x) + (pair.y * pair.y)));
    return rad;
}

// Returns the polar angle (theta) given a pair of cartesian (x,y) coordinates
- (double)getThetaFromPoint:(CGPoint)pair {
    return atan2(pair.x, pair.y);
}

// Converts degrees to radians
- (double)degToRad:(double)degrees {
	return degrees / 180.0f * M_PI;
}

// Converts radians to degrees
- (double)radToDeg:(double)radians {
    return radians * (180.0 / M_PI);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
