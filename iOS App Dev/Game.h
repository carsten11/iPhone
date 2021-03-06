//
//  Game.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "InputLayer.h"


@class Player;
@class Coin;
@interface Game : CCScene <InputLayerDelegate>
{
    
    NSDictionary *_Configuration;
    ccTime _accumulator;
    Player *_player;
    Coin *_coin;
    ChipmunkSpace *_space;
    CCNode *_gameNode;
    CCNode *_coinsLayer;
    BOOL _followPlayer;
    CCParallaxNode *_parallaxNode;
    CGFloat _nextTunnelObjectXPosition;
    CCParticleSystemQuad *_splashParticles;
    
    CGFloat _nextOcean;
    CGFloat _nextCeiling;
    CGFloat _nextBeach;
    
}

@end
