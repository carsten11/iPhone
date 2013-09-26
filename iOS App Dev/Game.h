//
//  Game.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
#import "cocos2d.h"
#import <Foundation/Foundation.h>


@class Player;
@interface Game : CCScene
{
    NSDictionary *_Configuration;
    ccTime _accumulator;
    Player *_player;
    ChipmunkSpace *_space;
    CCNode *_gameNode;
    
}

@end
