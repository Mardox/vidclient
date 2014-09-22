//
//  CBBlurView.h
//  youtube
//
//  Created by Theo Ben Hassen on 1/19/14.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CBBlurView : UIView{
    UIToolbar *tool;
}
- (void)setColorForBlur:(UIColor *)color;
- (void)setAlphaForBlur:(float)alpha;
- (void)initBlur;
@end
