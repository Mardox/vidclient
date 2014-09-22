//
//  FavoriteViewController.h
//  youtube
//
//  Created by Jonathan Martin on 16/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ODRefreshControl.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"

@interface FavoriteViewController : UIViewController<ADBannerViewDelegate,GADBannerViewDelegate,MenuViewControllerDelegate>{
    IBOutlet UIView *navigationBar;
    IBOutlet UITableView *tableView;
    NSArray *youtubeData;
    IBOutlet UILabel *theTitle;
    NSUserDefaults *userDefault;
    UIWebView *currentPlayer;
    IBOutlet UIView *noFavorite;
    IBOutlet UILabel *firstLabel;
    IBOutlet UILabel *secondLabel;
    MenuViewController *menu;
}
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView2;
@property (nonatomic, strong) GADBannerView *admobBannerView;
@property (nonatomic, strong) GADBannerView *admobBannerView2;

- (IBAction)menuPressed:(id)sender;
- (NSArray*)getVideoForID:(int)theID;
- (void)updateFavorite;
@end
