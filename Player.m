//
//  Player.m
//  iOS App Dev
//
//  Created by Carsten Petersen on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{

    self = [super initWithFile:@"player2.png"];
    if (self) {
        
        _space = space;
        
        if(_space != nil)
        {
            CGSize size = self.textureRect.size;
            cpFloat mass = size.width * size.height;
            cpFloat moment = cpMomentForBox(mass, size.width, size.height);
            
            ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
            
            //Add to space
            [_space addBody:body];
            [_space addShape:shape];
            
            //Add to physics sprite
            self.chipmunkBody = body;
        }
        
    }
    return self;
}


- (void)fly
{
    cpVect impulseVector = cpv(self.chipmunkBody.mass * 1.25, self.chipmunkBody.mass * 20);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

@end
