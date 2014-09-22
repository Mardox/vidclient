//
//  NewsCell.h
//  youtube
//
//  Created by Martin Jonathan on 05/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBActivityIndicator.h"

@protocol NewsCellDelegate <NSObject>
@optional
#pragma mark Public APIs
-(void)PlayVideo:(NSString*) index;
-(void)PlayVideo:(NSString*) index withNotification:(BOOL)b;

@end

@interface NewsCell : UITableViewCell <UIWebViewDelegate,UIAlertViewDelegate>{
    BOOL notificationSetup;
    CBActivityIndicator *activity;
    UIView *currentView;
    UITableView *temp;
    UIActivityIndicatorView *activityIndicator;
    BOOL reloadThumbnail;
    BOOL favoriteMode;
    BOOL isInFavorite;
    UIView *shareView;
    UIWebView *loader;
    UIButton *dismissButton;
    
}

@property (nonatomic,strong) id <NewsCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *heart;
@property (strong, nonatomic) IBOutlet UIWebView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *shadowDown;
@property (strong, nonatomic) IBOutlet UIImageView *shadowUp;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;
@property (strong,nonatomic) NSString *videoID;
@property (strong,nonatomic) NSString *thumbnail;
@property (strong,nonatomic) NSDictionary *infos;
@property (assign,nonatomic) BOOL isInFavorite;

-(IBAction)TouchedCell:(id)sender;
- (IBAction)favoriteSelected:(id)sender;
-(void)StartLoadingMode;
-(void)StopLoadingMode;
-(void)reloadThumbnail;
-(void)loadingCell;
@end
