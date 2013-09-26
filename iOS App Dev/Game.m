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
        [self addChild:debugNode];
       
        //Add the player
        NSString *playerPositionString = _Configuration[@"playerPosition"];
        _player = [[Player alloc]  initWithSpace:_space position:CGPointFromString(playerPositionString)];
        [self addChild:_player];
        
        [self scheduleUpdate];
    }
    return self;
}



- (void)setupGraphicsLandscape
{
    
    CCLayerColor *sky = [CCLayerColor layerWithColor:ccc4(0, 0, 150, 255)];
    [self addChild:sky];
    
    //Ground and Ceiling pictures still needs to be modified....
    CCSprite *Ground = [CCSprite spriteWithFile:@"Ground.png"];
    Ground.anchorPoint = ccp(0,0);
    [self addChild:Ground];
    
    CCSprite *Ceiling = [CCSprite spriteWithFile:@"Ceiling.png"];
    Ceiling.anchorPoint = ccp(0,-5.3);
    [self addChild:Ceiling];
    
}

- (void)setupPhysicsLandscape
{
    NSURL *Groundurl = [[NSBundle mainBundle] URLForResource:@"Ground" withExtension:@"png"];
    NSURL *Topurl = [[NSBundle mainBundle] URLForResource:@"Ceiling" withExtension:@"png"];
    ChipmunkImageSampler *Gsampler = [ChipmunkImageSampler samplerWithImageFile:Groundurl isMask:NO];
    ChipmunkImageSampler *Tsampler = [ChipmunkImageSampler samplerWithImageFile:Topurl isMask:NO];
    
    ChipmunkPolylineSet *contour = [Tsampler marchAllWithBorder:NO hard:YES];
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
}

@end
