//
//  Player.h
//  iOS App Dev
//
//  Created by Carsten Petersen on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
#import "cocos2d.h"
#import "CCPhysicsSprite.h"


@interface Player : CCPhysicsSprite
{
    ChipmunkSpace *_space;
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
- (void)fly;


@end
