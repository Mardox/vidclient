//
//  NewsViewController.h
//  youtube
//
//  Created by Martin Jonathan on 04/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ODRefreshControl.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "CBActivityIndicator.h"
#import "NewsCell.h"
#import "Constants.h"
#import "Tools.h"
#import "Reachability.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"

#import <MediaPlayer/MediaPlayer.h>
#import "ALMoviePlayerController.h"

typedef NS_ENUM(NSUInteger, XCDYouTubeVideoQuality) {
    XCDYouTubeVideoQualitySmall240  = 36,
    XCDYouTubeVideoQualityMedium360 = 18,
    XCDYouTubeVideoQualityHD720     = 22,
    XCDYouTubeVideoQualityHD1080    = 37,
};

@interface NewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,YoutubeApisDelegate,UIWebViewDelegate,UITextFieldDelegate,ADBannerViewDelegate,GADBannerViewDelegate,MenuViewControllerDelegate, ALMoviePlayerControllerDelegate, NewsCellDelegate>{
    APIs *api;
    IBOutlet UIView *navigationBar;
    IBOutlet UITableView *tableView;
    NSArray *youtubeData;
    IBOutlet UILabel *theTitle;
    NSUserDefaults *userDefault;
    int startIndex;
    int searchIndex;
    int maxResults;
    UIWebView *currentPlayer;
    ODRefreshControl *refreshControl;
    BOOL searchMode;
    BOOL searchCanLoad;
    UITextField *txt;
    NSString *query;
    MenuViewController *menu;
    UIImageView *loading;
    CBActivityIndicator *activity;
    Reachability *reachability;
    UIButton *dismissKeyboard;
    
    IBOutlet UIButton *noResultButton;
    IBOutlet UIView *noResult;
    IBOutlet UILabel *firstLabel;
    IBOutlet UILabel *secondLabel;
    
    GADInterstitial *interstitialAd;
    
}
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (assign, nonatomic) BOOL isInitialize;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (nonatomic, strong) GADBannerView *admobBannerView;
@property (assign,nonatomic) BOOL channelHasChanged;

@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;
@property (nonatomic, strong) NSMutableData *connectionData;
@property (nonatomic, strong) NSArray *preferredVideoQualities;
@property (nonatomic, copy) NSString *videoIdentifier;
@property (nonatomic, strong) NSMutableArray *elFields;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic) CGRect defaultFrame;

- (IBAction)menuPressed:(id)sender;
- (IBAction)searchPressed:(id)sender;
- (NSArray*)getVideoForID:(int)theID;
- (void)initializeBasicInformation;
- (IBAction)noResultButtonPressed:(id)sender;
- (void)setContentOffSet;
- (void)reloadVC:(id)sender;
- (void)youtubePlayed:(id)sender;
@end
