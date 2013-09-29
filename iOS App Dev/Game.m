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



- (void)setupGraphicsLandscape
{
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    CCSprite *ocean = [CCSprite spriteWithFile:@"ocean.jpg"];
    ocean.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:ocean z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *beach = [CCSprite spriteWithFile:@"beach.png"];
    beach.anchorPoint = ccp(0, 0);
    _beachWidth = beach.contentSize.width;
    [_parallaxNode addChild:beach z:0 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    //Ceiling pictures still needs to be modified....
    
    /*CCSprite *Ceiling = [CCSprite spriteWithFile:@"Ceiling.png"];
    Ceiling.anchorPoint = ccp(0,-5.3);
    [self addChild:Ceiling];
    */
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
}

- (void)touchEndedAtPosition:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    position = [_gameNode convertToNodeSpace:position];
    NSLog(@"touch: %@", NSStringFromCGPoint(position));
    NSLog(@"player: %@", NSStringFromCGPoint(_player.position));
    _followPlayer = YES;
    cpVect normalizedVector = cpvnormalize(cpvsub(position, _player.position));
    [_player fly:delay * 300 vector:normalizedVector];
    
}

@end
