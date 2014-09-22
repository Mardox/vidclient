//
//  CBActivityIndicator.h
//  Leaf
//
//  Created by Theo Ben Hassen on 7/10/13.
//  Copyright (c) 2013 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CBActivityIndicator : UIView{
    UIView *v1;
    UIView *v2;
    UIView *v3;
    int currentPop;NSTimer *timerPop;UIView *currentViewPop;
}
@property (nonatomic,strong) UIColor *activityColor;
@property (nonatomic,assign) BOOL isRunning;
-(void)startAnimating;
-(void)stopAnimating;
@end
