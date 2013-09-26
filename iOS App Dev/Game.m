//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"


@implementation Game

- (id)init
{
    self = [super init];
    if (self)
    {
        
        [self setupGraphicsLandscape];
        // Your initilization code goes here
        [self scheduleUpdate];
    }
    return self;
}

- (void) setupGraphicsLandscape
{
    
    CCLayerColor *sky = [CCLayerColor layerWithColor:ccc4(0, 0, 150, 255)];
    [self addChild:sky];
    
    //Ground and Ceiling pictures still needs to be modified....
    CCSprite *Ground = [CCSprite spriteWithFile:@"Ground.png"];
    Ground.anchorPoint = ccp(0,0);
    [self addChild:Ground];
    
    CCSprite *Ceiling = [CCSprite spriteWithFile:@"Ceiling.png"];
    Ceiling.anchorPoint = ccp(0,-5.5);
    [self addChild:Ceiling];
    
    
}

- (void)update:(ccTime)delta
{
    // Update logic goes here
}

@end
