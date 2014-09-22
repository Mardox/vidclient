//
//  SelectChannelViewController.h
//  youtube_demo
//
//  Created by Jonathan Martin on 28/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "ODRefreshControl.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "CBActivityIndicator.h"
#import "Constants.h"
#import "Tools.h"
#import "Reachability.h"
#import <iAd/iAd.h>

@interface SelectChannelViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,YoutubeApisDelegate,UIWebViewDelegate,UITextFieldDelegate,MenuViewControllerDelegate>{
    APIs *api;
    IBOutlet UIView *navigationBar;
    IBOutlet UITableView *tableView;
    NSArray *youtubeData;
    IBOutlet UILabel *theTitle;
    NSUserDefaults *userDefault;
    MenuViewController *menu;
    UIImageView *loading;
    CBActivityIndicator *activity;
    Reachability *reachability;
    
}
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)menuPressed:(id)sender;

@end
