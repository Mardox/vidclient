//
//  ODRefreshControl.h
//  ODRefreshControl
//
//  Created by ColtBoys on 8/12/12.
//  Copyright (c) 2012 orange in a day. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ODRefreshControl : UIControl {
    CAShapeLayer *_shapeLayer;
    CAShapeLayer *_arrowLayer;
    CAShapeLayer *_highlightLayer;
    UIActivityIndicatorView *_activity;
    BOOL _refreshing;
    BOOL _canRefresh;
}

@property (nonatomic, readonly) BOOL refreshing;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

- (id)initInScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;

- (void)endRefreshing;

@end
