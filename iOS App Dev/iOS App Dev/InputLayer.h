//
//  InputLayer.h
//  iOS App Dev
//
//  Created by Carsten Petersen on 9/27/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol InputLayerDelegate <NSObject>

- (void)touchEndedAtPosition:(CGPoint)point afterDelay:(NSTimeInterval)delay;

@end

@interface InputLayer : CCLayer
{
    NSDate *_touchBeganDate;
}

@property (nonatomic, weak) id<InputLayerDelegate> delegate;

@end
