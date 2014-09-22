//
//  CBBlurView.m
//  youtube
//
//  Created by Theo Ben Hassen on 1/19/14.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "CBBlurView.h"

@implementation CBBlurView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initBlur];
    }
    return self;
}


- (void)initBlur {
    [self setClipsToBounds:YES];
    self.backgroundColor = [UIColor clearColor];
    if (tool==nil) {
        tool = [[UIToolbar alloc] initWithFrame:[self bounds]];
        [self.layer insertSublayer:[tool layer] atIndex:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [tool setFrame:[self bounds]];
}

- (void)setColorForBlur:(UIColor *)color{
    [self setBackgroundColor:color];
}

- (void)setAlphaForBlur:(float)alpha{
    int nb_components = (int)CGColorGetNumberOfComponents([self.backgroundColor CGColor]);
    if (nb_components == 4){
        const CGFloat *components = CGColorGetComponents([self.backgroundColor CGColor]);
        CGFloat red = components[0];CGFloat green = components[1];CGFloat blue = components[2];
        [self setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
    }else{
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]];
    }
}


@end
