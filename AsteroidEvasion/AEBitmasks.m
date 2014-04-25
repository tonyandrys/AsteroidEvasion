//
//  AEBitmasks.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 4/24/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEBitmasks.h"

@implementation AEBitmasks

const uint32_t BITMASK_SHIP_CATEGORY = 0x1 << 0; // 00000000000000000000000000000001
const uint32_t BITMASK_ASTEROID_CATEGORY = 0x1 << 1; // 00000000000000000000000000000010
const uint32_t BITMASK_POWERUP_CATEGORY = 0x1 << 2; // 00000000000000000000000000000100

@end
