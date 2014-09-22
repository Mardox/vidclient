//
//  CBActivityIndicator.m
//  Leaf
//
//  Created by Theo Ben Hassen on 7/10/13.
//  Copyright (c) 2013 ColtBoy. All rights reserved.
//

#import "CBActivityIndicator.h"

@implementation CBActivityIndicator
@synthesize activityColor;
@synthesize isRunning;
#define AnimDurationGrow 0.15
#define AnimDurationExplode 0.15
#pragma mark Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self InitViews];
        self.clipsToBounds=NO;
        self.isRunning=NO;
    }
    return self;
}
-(void)InitViews{
    v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height)];
    v1.backgroundColor = [UIColor clearColor];
    [self addSubview:v1];
    
    v2 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height)];
    v2.backgroundColor = [UIColor clearColor];
    [self addSubview:v2];
    
    v3 = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width/3)*2, 0, self.frame.size.width/3, self.frame.size.height)];
    v3.backgroundColor = [UIColor clearColor];
    [self addSubview:v3];
}

#pragma mark Public Methods
-(void)startAnimating{
    if (!self.isRunning) {
        self.isRunning=YES;
        [self StartAnimation];
    }
    
}
-(void)stopAnimating{
    if (self.isRunning) {
        self.hidden=YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CreateCircleInView:) object:v1];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CreateCircleInView:) object:v2];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CreateCircleInView:) object:v3];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(PopViews) object:nil];
        self.isRunning=NO;
    }
}
#pragma mark Internal Methods
-(void)StartAnimation{
    self.hidden=NO;
    [self CleanViews];
    currentPop=0;
    [self performSelector:@selector(CreateCircleInView:) withObject:v1 afterDelay:0];
    [self performSelector:@selector(CreateCircleInView:) withObject:v2 afterDelay:AnimDurationGrow];
    [self performSelector:@selector(CreateCircleInView:) withObject:v3 afterDelay:AnimDurationGrow*2];
    [self performSelector:@selector(PopViews) withObject:nil afterDelay:AnimDurationGrow*3];
}
-(void)CreateCircleInView:(UIView *)view{
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width/2, view.frame.size.height/2, 0, 1)];
    circleView.backgroundColor=self.activityColor;
    [view addSubview:circleView];
    
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:0]]; // The current value
    [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:(view.frame.size.height-20)/2]];
    [cornerRadiusAnimation setDuration:AnimDurationGrow];
    [cornerRadiusAnimation setBeginTime:CACurrentMediaTime()];
    [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
    [[circleView layer] addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
    [[circleView layer] setCornerRadius:(view.frame.size.height-20)/2];
    
    [UIView animateWithDuration:AnimDurationGrow delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[circleView layer]setFrame:CGRectMake((view.frame.size.width-(view.frame.size.height-20))/2, 10, view.frame.size.height-20, view.frame.size.height-20)];
    } completion:^(BOOL finished) {
    }];
}
-(void)PopViews{
    if ([timerPop isValid]) {
        [timerPop invalidate];
    }
    if (!self.hidden) {
        if (currentPop==0) {
            [self PopCircleinView:v1];
        }
        else if (currentPop==1){
            [self PopCircleinView:v2];
        }
        else if (currentPop==2){
            [self PopCircleinView:v3];
        }
        else{
            [self StartAnimation];
        }
    }
    
    
}
-(void)PopCircleinView:(UIView *)view{
    
    if (view.subviews.count!=0) {
        currentViewPop = (UIView *)[view.subviews lastObject];
        [currentViewPop.layer removeAllAnimations];
        currentViewPop.backgroundColor = [UIColor clearColor];
        currentViewPop.layer.borderColor = self.activityColor.CGColor;
        
        currentViewPop.layer.borderWidth = currentViewPop.frame.size.height/2;
        timerPop = [NSTimer scheduledTimerWithTimeInterval:AnimDurationExplode/currentViewPop.layer.borderWidth target:self selector:@selector(PopAnimation) userInfo:nil repeats:YES];
    }
}
-(void)PopAnimation{
    if (currentViewPop.layer.borderWidth>=1) {
        currentViewPop.layer.borderWidth = currentViewPop.layer.borderWidth -1;
    }
    float h = currentViewPop.frame.size.height+2;
    float x = (currentViewPop.superview.frame.size.width-h)/2;
    float y = (currentViewPop.superview.frame.size.height-h)/2;
    currentViewPop.layer.cornerRadius = h/2;
    currentViewPop.frame = CGRectMake(x, y, h, h);
    currentViewPop.alpha=currentViewPop.alpha-0.07;
    if (currentViewPop.alpha<=0) {
        [timerPop invalidate];
        currentPop=currentPop+1;
        [self PopViews];
    }
}
-(void)CleanViews{
    for (UIView *subview in v1.subviews) {
        [subview removeFromSuperview];
    }
    for (UIView *subview in v2.subviews) {
        [subview removeFromSuperview];
    }
    for (UIView *subview in v3.subviews) {
        [subview removeFromSuperview];
    }

}
@end
