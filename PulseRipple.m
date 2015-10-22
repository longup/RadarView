//
//  PulseRipple.m
//
//  Created by Mr. zhang on 15/9/7.
//  Copyright © 2015年 Mr. zhang. All rights reserved.
//

#import "PulseRipple.h"

#define ARC4RANDOM_MAX      0x100000000

@interface PulseRipple()
{
    CGSize itemSize;
    CALayer *animationLayer;
}

@end

@implementation PulseRipple

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)activeAction
{
    if(animationLayer)
    {   //将图层从他的父图层中删除
        [animationLayer removeFromSuperlayer];
        //手动重画这个View
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor colorWithRed:0 green:167.0/255.0 blue:248.0/255.0 alpha:1.0] setFill];
    UIRectFill(rect);
    
    NSInteger pulsingCount = 6;
    double animationDuration = 10.0;
    
    CALayer *myAnimationLayer = [[CALayer alloc] init];
    for(int i = 0; i < pulsingCount; i++)
    {
        CALayer *pulsingLayer = [[CALayer alloc] init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor;
        pulsingLayer.borderWidth = 2;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + i * animationDuration / pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @0.0;
        scaleAnimation.toValue = @1.5;
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1.0,@0.7,@0.0];
        opacityAnimation.keyTimes = @[@0.0,@0.5,@1.0];
        
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [myAnimationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:myAnimationLayer];
    animationLayer = myAnimationLayer;
}


@end
