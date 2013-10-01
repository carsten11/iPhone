//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"
#import "ChipmunkAutoGeometry.h"
#import "Player.h"
#import "InputLayer.h"

@implementation Game

- (id)init
{
    self = [super init];
    if (self)
    {
        //Load Configuration file
        _Configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        //Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_Configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, -gravity);
        
        // Setup world
        // nextTunnelObjXPos tells us at what X position the next tunnel object should be created.
        _nextTunnelObjectXPosition = 0.0f;
        _nextOcean = 0.0f;
        _nextCeiling = 0.0f;
        _nextBeach = 0.0f;
        [self setupGraphicsLandscape];
        [self setupPhysicsLandscape];
        
        
        //Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = YES;
        [_gameNode addChild:debugNode];
       
        //Add the player
        NSString *playerPositionString = _Configuration[@"playerPosition"];
        _player = [[Player alloc]  initWithSpace:_space position:CGPointFromString(playerPositionString)];
        [_gameNode addChild:_player];
        
        //Create an input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)assemblyBelt
{
    // Remove sprite when it disapears from the screen and then
    // add it on the right of the currently viewable sprite.
    for (CCSprite *currentTunnelObject in _parallaxNode.children)
    {
        NSInteger keepZOrder = currentTunnelObject.zOrder;
        if (currentTunnelObject.zOrder == 1 || currentTunnelObject.zOrder == 2 || currentTunnelObject.zOrder == 0)
        {
            // Just for debug logging. TODO: Cleanup.
            CGPoint parallaxPosition = ccp(_parallaxNode.position.x, 0.0f);
            NSLog (@"Parallax position: %@", NSStringFromCGPoint(parallaxPosition));
            
            // We only need to create a new tunnel object if the current tunnel object exits the viewpoint
            //CGFloat tunnelObjectOffset = _nextTunnelObjectXPosition;
            //if (parallaxPosition.x < -tunnelObjectOffset)
 
                NSLog(@"zOrder: %i", currentTunnelObject.zOrder);
                // Keep the current Y position so the new tunnel object aligns with the current tunnel object.
                CGFloat tunnelObjectYPosition = currentTunnelObject.position.y;
                NSLog (@"Tunnel object position before: %f", currentTunnelObject.position.x);

                CCSprite *newTunnelObject;
            CGFloat currentParallaxRatio;
                if (currentTunnelObject.zOrder == 1 && parallaxPosition.x < -_nextBeach) // 1 == beach
                {
                    newTunnelObject = [CCSprite spriteWithFile:@"beach.png"];
                    _nextBeach = _nextBeach + newTunnelObject.contentSize.width;
                    _nextTunnelObjectXPosition = _nextBeach;
                    currentParallaxRatio = 1.0f;
                }
                else if (currentTunnelObject.zOrder == 2 && parallaxPosition.x < -_nextCeiling) // 2 == ceiling
                {
                    newTunnelObject = [CCSprite spriteWithFile:@"ceiling.png"];
                    _nextCeiling = _nextCeiling + newTunnelObject.contentSize.width;
                    _nextTunnelObjectXPosition = _nextCeiling;
                    currentParallaxRatio = 1.0f;
                }
                else if (currentTunnelObject.zOrder == 0 && parallaxPosition.x < -_nextOcean) // 3 == background
                {
                    newTunnelObject = [CCSprite spriteWithFile:@"ocean.jpg"];
                    _nextOcean = _nextOcean + newTunnelObject.contentSize.width;
                    _nextTunnelObjectXPosition = _nextOcean;
                    currentParallaxRatio = 0.5f;
                }
            
            if (newTunnelObject != nil)
            {
                //newTunnelObject.anchorPoint = currentTunnelObject.anchorPoint;
                newTunnelObject.anchorPoint = currentTunnelObject.anchorPoint;
                
                //NSLog(@"Removing tunnel object.");
                [_parallaxNode removeChild:currentTunnelObject];
                //newTunnelObject.anchorPoint = ccp(0, 0);
                
                //NSLog(@"Adding tunnel object at X position: %f", _nextTunnelObjectXPosition);
                [_parallaxNode addChild:newTunnelObject z:keepZOrder parallaxRatio:ccp(currentParallaxRatio, 1.0f) positionOffset:ccp(_nextTunnelObjectXPosition,tunnelObjectYPosition)];
            }
        }
    }
}


- (void)setupGraphicsLandscape
{
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    CCSprite *ocean = [CCSprite spriteWithFile:@"ocean.jpg"];
    ocean.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:ocean z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *beach1 = [CCSprite spriteWithFile:@"beach.png"];
    beach1.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:beach1 z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *beach2 = [CCSprite spriteWithFile:@"beach.png"];
    beach2.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:beach2 z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointMake(beach1.contentSize.width, 0)];
    
    CCSprite *ceiling1 = [CCSprite spriteWithFile:@"ceiling.png"];
    ceiling1.anchorPoint = ccp(0,-2.2);
    [_parallaxNode addChild:ceiling1 z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *ceiling2 = [CCSprite spriteWithFile:@"ceiling.png"];
    ceiling2.anchorPoint = ccp(0,-2.2);
    [_parallaxNode addChild:ceiling2 z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointMake(ceiling1.contentSize.width, 0)];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _nextTunnelObjectXPosition = beach1.contentSize.width;
    
}

- (void)setupPhysicsLandscape
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"beach" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
    
    
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"ceiling" withExtension:@"png"];
    ChipmunkImageSampler *sampler2 = [ChipmunkImageSampler samplerWithImageFile:url2 isMask:NO];
    
    ChipmunkPolylineSet *contour2 = [sampler2 marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line2 = [contour2 lineAtIndex:0];
    ChipmunkPolyline *simpleLine2 = [line2 simplifyCurves:1];
    
    ChipmunkBody *terrainBody2 = [ChipmunkBody staticBody];
    NSArray *terrainShapes2 = [simpleLine2 asChipmunkSegmentsWithBody:terrainBody2 radius:0 offset:cpvzero];
    for (ChipmunkShape *shape2 in terrainShapes2)
    {
        [_space addShape:shape2];
    }
}

- (void)update:(ccTime)delta
{
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep)
    {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
    CGFloat moveViewportBy = [_Configuration[@"movement"] floatValue];
    CGFloat _newX = _parallaxNode.position.x - moveViewportBy;
    _parallaxNode.position = ccp(_newX, 0);
    
    // If needed - move beach
    [self assemblyBelt];
}

- (void)touchEndedAtPosition:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    position = [_gameNode convertToNodeSpace:position];
    NSLog(@"touch: %@", NSStringFromCGPoint(position));
    NSLog(@"player: %@", NSStringFromCGPoint(_player.position));
    _followPlayer = YES;
    [_player fly];
    
}

@end
