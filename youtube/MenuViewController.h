//
//  MenuViewController.h
//  youtube
//
//  Created by Jonathan Martin on 18/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "CBBlurView.h"
#import "APIs.h"
#import "dataModel.h"

@protocol MenuViewControllerDelegate <NSObject>
@optional
#pragma mark Public APIs
-(void)MenuViewControllerBeginOpening;
-(void)MenuViewControllerEndClosing;
@end

@class AppDelegate;
@interface MenuViewController : UIViewController<UIWebViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet UIView *photoView;
    IBOutlet UIView *selectChannelView;
    IBOutlet UILabel *channelLabel;
    IBOutlet UIButton *videoButton;
    IBOutlet UIButton *favoriteButton;
    IBOutlet UIButton *socialButton;
    IBOutlet UIButton *selectChannelButton;
    IBOutlet UIImageView *photoImageView;
    IBOutlet CBBlurView *blurView;
    UIWebView *web;
    UIButton *dismissButton;
    NSUserDefaults *userDefault;
    IBOutlet UIPickerView *queryPicker;
}
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,strong) id <MenuViewControllerDelegate>delegate;

- (IBAction)videoPressed:(id)sender;
- (IBAction)favoritePressed:(id)sender;
- (IBAction)socialPressed:(id)sender;
- (IBAction)selectChannelPressed:(id)sender;
- (void)openMenu;
- (void)closeMenu;
- (CGRect)getFrameInit;
- (void)loadThumbnail:(NSString*)thumb;
- (void)loadUsername;
@end
