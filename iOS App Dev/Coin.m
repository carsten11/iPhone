//
//  Coin.m
//  iOS App Dev
//
//  Created by Carsten Petersen on 10/1/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Coin.h"
#import "ObjectiveChipmunk.h"

@implementation Coin

-(id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"coinGold.png"];
    if (self) {
        
        _space = space;
        
        if(_space != nil)
        {
            CGSize size = self.textureRect.size;
            
            ChipmunkBody *body = [ChipmunkBody staticBody];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width/2 height:size.height/2];
            shape.sensor = YES;
            
            //Add to world
            [_space addShape:shape];
            
            //Add to physics sprite
            body.data = self;
            self.chipmunkBody = body;
        }
        
    }
    return self;

}


@end
