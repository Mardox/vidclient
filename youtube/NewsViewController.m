//
//  NewsViewController.m
//  youtube
//
//  Created by Martin Jonathan on 04/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "NewsViewController.h"
#import "Config.h"
#import "dataModel.h"
#import "iRate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

NSString *const XCDYouTubeVideoErrorDomain = @"XCDYouTubeVideoErrorDomain";
NSString *const XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey = @"XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey";

NSString *const XCDYouTubeVideoPlayerViewControllerDidReceiveMetadataNotification = @"XCDYouTubeVideoPlayerViewControllerDidReceiveMetadataNotification";
NSString *const XCDMetadataKeyTitle = @"Title";
NSString *const XCDMetadataKeySmallThumbnailURL = @"SmallThumbnailURL";
NSString *const XCDMetadataKeyMediumThumbnailURL = @"MediumThumbnailURL";
NSString *const XCDMetadataKeyLargeThumbnailURL = @"LargeThumbnailURL";

static NSDictionary *DictionaryWithQueryString(NSString *string, NSStringEncoding encoding) {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSArray *fields = [string componentsSeparatedByString:@"&"];
    for (NSString *field in fields) {
        NSArray *pair = [field componentsSeparatedByString:@"="];
        if (pair.count == 2) {
            NSString *key = pair[0];
            NSString *value = [pair[1] stringByReplacingPercentEscapesUsingEncoding:encoding];
            value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            dictionary[key] = value;
        }
    }
    return dictionary;
}
static NSString *ApplicationLanguageIdentifier(void) {
    static NSString *applicationLanguageIdentifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationLanguageIdentifier = @"en";
        NSArray *preferredLocalizations = [[NSBundle mainBundle] preferredLocalizations];
        if (preferredLocalizations.count > 0)
            applicationLanguageIdentifier = [NSLocale canonicalLanguageIdentifierFromString:preferredLocalizations[0]] ? : applicationLanguageIdentifier;
    });
    return applicationLanguageIdentifier;
}

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize isInitialize;
@synthesize admobBannerView;
@synthesize channelHasChanged;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([config_iad isEqualToString:@"YES"] || [config_iad isEqualToString:@"yes"]){
        self.bannerView.delegate = self;
        self.bannerView.hidden = YES;
    }else{
        [self.bannerView removeFromSuperview];
        if (![config_admob_adunitid isEqualToString:@""]) {
            [self adAdmobBanners];
        }
    }
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    isInitialize = NO;
    api = [[APIs alloc]init];
    api.delegate = self;
    
    startIndex = 1;
    searchIndex = 1;
    maxResults = 5;
    searchMode = NO;
    searchCanLoad = YES;
    channelHasChanged = NO;
    
    dataModel *model = [dataModel sharedManager];

    userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [[config_id componentsSeparatedByString:@","]objectAtIndex:0];
    [userDefault setObject:userID forKey:kUSERID];
    [userDefault setObject:[Tools stringColorFromConfig:config_color] forKey:kTHEMECOLOR];
    if (internetStatus!=NotReachable) {
        [self initializeBasicInformation];
    }else if(internetStatus==NotReachable){
        AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
        [deleg showNoConnection];
    }
    //refreshControl = [[ODRefreshControl alloc] initInScrollView:tableView];
    //[refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    [self updateThemeColor];
    //theTitle.text = NSLocalizedString(@"Videos",nil);
    theTitle.text = model.currentTitle;
    theTitle.textColor = [UIColor whiteColor];
    [theTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    theTitle.adjustsFontSizeToFitWidth = YES;
    [tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
    
    firstLabel.text = NSLocalizedString(@"NO RESULT ?",nil);
    firstLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    [firstLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    secondLabel.text = NSLocalizedString(@"To make another search just touch the search icon at the upper right corner",nil);
    secondLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    [secondLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0]];
    [self.view insertSubview:noResult aboveSubview:tableView];
    noResult.center = tableView.center;
    noResult.hidden = YES;
    
    //Notif to reload view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVC:)
                                                 name:@"reloadVC" object:nil];
    
    //Auto Rating prompt
    [iRate sharedInstance].daysUntilPrompt = rateDays;
    [iRate sharedInstance].remindPeriod = 7;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youtubePlayed:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    
    

}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (admobBannerView) {
        admobBannerView.hidden = YES;
    }
    self.bannerView.hidden = NO;
    tableView.tableHeaderView = self.bannerView;
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    tableView.tableHeaderView = nil;
    self.bannerView.hidden = YES;
    if (![config_admob_adunitid isEqualToString:@""] && !admobBannerView) {
        [self adAdmobBanners];
    }
}
-(void)adAdmobBanners{
//    admobBannerView = [[GADBannerView alloc]
//                       initWithFrame:CGRectMake(0,self.view.frame.size.height - GAD_SIZE_320x50.height,
//                                                GAD_SIZE_320x50.width,
//                                                GAD_SIZE_320x50.height)];
//    self.admobBannerView.adUnitID = config_admob_adunitid;
//    self.admobBannerView.rootViewController = self;
//    self.admobBannerView.delegate = self;
//    self.admobBannerView.hidden = NO;
//    [self.admobBannerView loadRequest:[GADRequest request]];
//    NSLog(@"%f",self.admobBannerView.frame.origin.y);
    
    //Admob
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    //Set Y-Rect of banner just above tab bar by reducting all controls from frame
    [bannerView setFrame:CGRectMake(0,
                                    self.view.frame.size.height - GAD_SIZE_320x50.height,
                                    bannerView.bounds.size.width,
                                    bannerView.bounds.size.height)];
    // Specify the ad unit ID.
    bannerView.adUnitID = config_admob_adunitid;
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    [bannerView loadRequest:[GADRequest request]];
    //NSLog(@"%f",bannerView.frame.origin.y);
    //NSLog(@"%f",self.view.frame.size.height);
    //NSLog(@"%f",self.view.frame.size.height - GAD_SIZE_320x50.height - 200);
    
    
    //Setup Intertials
    interstitialAd = [[GADInterstitial alloc] init];
    interstitialAd.adUnitID = config_admob_int_adunitid;
    [interstitialAd loadRequest:[GADRequest request]];

}
-(void)adViewDidReceiveAd:(GADBannerView *)view{
    tableView.tableHeaderView = self.admobBannerView;
    self.admobBannerView.hidden = NO;
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    tableView.tableHeaderView = nil;
    self.admobBannerView.hidden = YES;
}
-(void)initializeBasicInformation{
    [self startLoadScreen];
    [api LoadBasicInformation];
    [api LoadYoutubeVideosFromStartIndex:startIndex withMaxResults:maxResults];
    NSLog(@"Init basic info");
}

- (IBAction)noResultButtonPressed:(id)sender {
    [noResult removeFromSuperview];
    startIndex = 1;
    searchIndex = 1;
    maxResults = 5;
    searchMode = NO;
    searchCanLoad = YES;
    [api LoadYoutubeVideosFromStartIndex:startIndex withMaxResults:maxResults];
    NSLog(@"noresult bttn");
}
-(void)startLoadScreen{
    loading = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    loading.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
    [self.view addSubview:loading];
    activity = [[CBActivityIndicator alloc]initWithFrame:CGRectMake(loading.frame.size.width/4, loading.frame.size.height/2, loading.frame.size.width/2,loading.frame.size.height/10)];
    activity.center = loading.center;
    activity.activityColor = [UIColor whiteColor];
    [activity startAnimating];
    [loading addSubview:activity];
}
-(void)stopLoadScreen{
    [loading removeFromSuperview];
}
-(void)refreshMenu{
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    menu = deleg.menu;
    menu.delegate = self;
    [menu.view removeFromSuperview];
    [self.view addSubview:menu.view];
}
-(void)viewWillDisappear:(BOOL)animated{
        [_moviePlayer pause];
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    deleg.menu = menu;
}
-(void)viewWillAppear:(BOOL)animated{
    [tableView reloadData];
    [self refreshMenu];
    [menu closeMenu];
}
-(void)viewDidAppear:(BOOL)animated{
    if (channelHasChanged) {
        [self initializeBasicInformation];
        [api LoadYoutubeVideosFromStartIndex:startIndex withMaxResults:maxResults];
        NSLog(@"view did appear");
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
    if (_moviePlayer) {
        [_moviePlayer stop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuPressed:(id)sender {
    if (menu.isOpen) {
        [menu closeMenu];
    }
    else
    {
        [menu openMenu];
    }
}

- (IBAction)searchPressed:(id)sender {
    if (searchCanLoad) {
        [self loadSearchbar];
    }else{
        [self removeSearchBar:nil];
    }
}
-(void)beginSearch{
    query = txt.text;
    [self removeSearchBar:nil];
    [api SearchYoutubeVideosFromStartIndex:searchIndex withMaxResults:yt_max_vids_show andQuery:query];
}
-(void)loadSearchbar{
    searchIndex = 1;
    tableView.userInteractionEnabled = NO;
    self.searchButton.enabled = NO;
    self.menuButton.enabled = NO;
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        navigationBar.frame = CGRectMake(navigationBar.frame.origin.x, navigationBar.frame.origin.y,navigationBar.frame.size.width, navigationBar.frame.size.height+35);
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y+35,tableView.frame.size.width, tableView.frame.size.height);
         noResult.frame = CGRectMake(noResult.frame.origin.x, noResult.frame.origin.y+35, noResult.frame.size.width, noResult.frame.size.height);
        txt = [[UITextField alloc]initWithFrame:CGRectMake(navigationBar.frame.origin.x+44,navigationBar.frame.origin.y+60,navigationBar.frame.size.width-88, navigationBar.frame.size.height-64)];
        txt.textColor = [UIColor whiteColor];
        txt.returnKeyType = UIReturnKeySearch;
        txt.delegate = self;
        txt.textAlignment = NSTextAlignmentCenter;
        txt.autocorrectionType = UITextAutocorrectionTypeNo;
        [txt addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
        [navigationBar addSubview:txt];
    } completion:^(BOOL finished) {
        [txt becomeFirstResponder];
        self.searchButton.enabled = YES;
        searchMode = YES;
        searchCanLoad = NO;
        if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
            dismissKeyboard = [[UIButton alloc]initWithFrame:CGRectMake(0, navigationBar.frame.size.height, 320, 264-navigationBar.frame.size.height)];
        }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
            dismissKeyboard = [[UIButton alloc]initWithFrame:CGRectMake(0, navigationBar.frame.size.height, 320, 352-navigationBar.frame.size.height)];
        }
        dismissKeyboard.backgroundColor = [UIColor clearColor];
        [dismissKeyboard addTarget:self action:@selector(removeSearchBar:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dismissKeyboard];
    }];
}
-(void)removeSearchBar:(id)sender{
    [dismissKeyboard removeFromSuperview];
    self.searchButton.enabled = NO;
    [txt resignFirstResponder];
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        navigationBar.frame = CGRectMake(navigationBar.frame.origin.x, navigationBar.frame.origin.y,navigationBar.frame.size.width, navigationBar.frame.size.height-35);
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y-35,tableView.frame.size.width, tableView.frame.size.height);
        noResult.frame = CGRectMake(noResult.frame.origin.x, noResult.frame.origin.y-35, noResult.frame.size.width, noResult.frame.size.height);
        txt.alpha = 0;
    } completion:^(BOOL finished) {
        [txt removeFromSuperview];
        self.searchButton.enabled = YES;
        self.menuButton.enabled = YES;
        searchCanLoad = YES;
        tableView.userInteractionEnabled = YES;
        if (sender != dismissKeyboard) {
            tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top);
        }
    }];
}
#pragma Utility
-(void)updateThemeColor{
    navigationBar.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
    //refreshControl.tintColor = [Tools colorWithHexString:[self getThemeColor]];
}
- (void)setContentOffSet{
    tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top);
}
-(NSString *)getStrForDate:(NSString *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDateFormatter *dateFormatter_test = [[NSDateFormatter alloc] init];
    [dateFormatter_test setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:date];
    int diff = [[NSDate date] timeIntervalSinceDate:startDate];
    
    NSInteger days = diff/(60*60*24);
    NSInteger hours = diff/(60*60);
    NSInteger minutes = diff/(60);
    NSString *result = NSLocalizedString(@"minutes",nil);
    if (minutes==1) {
        result = NSLocalizedString(@"minute",nil);
    }
    NSInteger nb=minutes;
    if (minutes>60) {
        nb = hours;
        result = NSLocalizedString(@"hours",nil);
        if (hours==1) {
            result = NSLocalizedString(@"hour",nil);
        }
        
    }
    if (hours>24) {
        nb = days;
        result=NSLocalizedString(@"days",nil);
        if (days==1) {
            result = NSLocalizedString(@"day",nil);
        }
        
    }
    
    NSInteger months = days/(30);
    NSInteger years = days/365.25;
    NSInteger daysLeft = days%30;
    
    if (daysLeft == 1 && months==0) {
        nb = daysLeft;
        result=NSLocalizedString(@"day",nil);
    }else if (daysLeft>1 && months==0){
        nb = daysLeft;
        result=NSLocalizedString(@"days",nil);
    }else if(months == 1 && years == 0){
        nb = months;
        result=NSLocalizedString(@"month",nil);
    }else if(months > 1 && years == 0){
        nb = months;
        result=NSLocalizedString(@"months",nil);
    }else if(years == 1){
        nb = years;
        result=NSLocalizedString(@"year",nil);
    }else if(years > 1){
        nb = years;
        result=NSLocalizedString(@"years",nil);
    }
    return [NSString stringWithFormat:NSLocalizedString(@"%ld %@ ago",nil),(long)nb,result];

}

-(NSString*)formatDuration:(int)elapsedSeconds{
    NSUInteger h = elapsedSeconds / 3600;
    NSUInteger m = (elapsedSeconds / 60) % 60;
    NSUInteger s = elapsedSeconds % 60;
    NSString *minutes = [NSString stringWithFormat:@"%lu",(unsigned long)m];
    if(m == 0){
        minutes = @"00";
    }else if (m>0 && m<10 && h!=0){
        minutes = [NSString stringWithFormat:@"0%lu",(unsigned long)m];
    }
    else if (m>0 && m<10 && h==0){
        minutes = [NSString stringWithFormat:@"%lu",(unsigned long)m];
    }
    NSString *seconds = [NSString stringWithFormat:@"%lu",(unsigned long)s];
    if(s == 0){
        seconds = @"00";
    }else if (s>0 && s<10){
        seconds = [NSString stringWithFormat:@"0%lu",(unsigned long)s];
    }
    if (h!=0) {
        return [NSString stringWithFormat:@"%lu:%@:%@",(unsigned long)h,minutes,seconds];
    }else if (m!=0){
        return [NSString stringWithFormat:@"%@:%@",minutes,seconds];
    }else{
        return [NSString stringWithFormat:@"0:%@",seconds];
    }
}
-(NSString*)getThemeColor{
    NSString *result;
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kTHEMECOLOR]){
        result = color_red_youtube;
    }else{
        result = [[NSUserDefaults standardUserDefaults]objectForKey:kTHEMECOLOR];
    }
    return result;
}
- (NSArray*)getVideoForID:(int)theID{
    return [youtubeData objectAtIndex:theID];
}
-(void)dropViewDidBeginRefreshing{
    if (searchMode) {
        searchMode = NO;
    }
   // [refreshControl beginRefreshing];
    startIndex = 1;
    [api LoadYoutubeVideosFromStartIndex:startIndex withMaxResults:maxResults];
    NSLog(@"drop view");
}
-(void)loadSocialInformation:(NSString *)str{
    NSString *url = str;
    NSData *pageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    [self performSelectorOnMainThread:@selector(socialInformationDidLoad:) withObject:[[NSString alloc] initWithData:pageData encoding:NSUTF8StringEncoding] waitUntilDone:NO];
}
-(void)socialInformationDidLoad:(NSString*)htmlString{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSArray *notCustom = @[@"twitter",@"facebook",@"linkedin",@"tumblr",@"soundcloud",@"pinterest",@"flickr",@"apple",@"instagram",@"wordpress",@"android",@"deviantart",@"spreadshirt",@"blogspot"];
    //Top Links
    NSString *html = [[[[htmlString componentsSeparatedByString:@"<div id=\"header-links\">"]lastObject]componentsSeparatedByString:@"</ul>"]objectAtIndex:0];
    NSMutableArray *links = [[NSMutableArray alloc]initWithArray:[html componentsSeparatedByString:@"<li class=\"channel-links-item\">"]];
    if (links.count!=0) {
        [links removeObjectAtIndex:0];
    }
    for (int i=0; i<links.count; i++) {
        NSString *link = [[[[[[[links objectAtIndex:i]componentsSeparatedByString:@"<a href=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"  " withString:@""];
        NSString *category = [[[[[links objectAtIndex:i]componentsSeparatedByString:@"domain="]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
        if ([category componentsSeparatedByString:@"."].count<=2) {
            category = [[category componentsSeparatedByString:@"."]objectAtIndex:0];
        }
        else
        {
            category = [[category componentsSeparatedByString:@"."]objectAtIndex:([category componentsSeparatedByString:@"."].count-2)];
        }
        if (![category isEqualToString:@"google"]) {
            if (![notCustom containsObject:category]) {
                category=@"custom";
            }
            [result addObject:@{@"link":link,@"category":category}];
        }
    }
    
    
    //Custom Links
    NSString *html2 = [[[[htmlString componentsSeparatedByString:@"<ul class=\"about-custom-links\">"]lastObject]componentsSeparatedByString:@"</ul>"]objectAtIndex:0];
    NSMutableArray *links2 = [[NSMutableArray alloc]initWithArray:[html2 componentsSeparatedByString:@"<li class=\"channel-links-item\">"]];
    if (links2.count!=0) {
        [links2 removeObjectAtIndex:0];
    }
    for (int i=0; i<links2.count; i++) {
        NSString *link = [[[[[links2 objectAtIndex:i]componentsSeparatedByString:@"<a href=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
        NSString *category = @"custom";
        NSString *title =[[[[[[[[links2 objectAtIndex:i]componentsSeparatedByString:@"<span class=\"about-channel-link-text\">"]lastObject]componentsSeparatedByString:@"</span>"]objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\n        " withString:@""]stringByReplacingOccurrencesOfString:@"        " withString:@""]stringByReplacingOccurrencesOfString:@"      " withString:@""];
        
        if (![self isElementInDictionnaryWithKey:@"link" andValue:link andArray:[[NSArray alloc]initWithArray:result]]) {
            [result addObject:@{@"link":link,@"category":category,@"title":title}];
        }
        
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ma = [[NSMutableDictionary alloc]initWithDictionary:[defaults objectForKey:kSOCIAL]];
    [ma setObject:result forKey:kSOCIALLINKS];
    [defaults setObject:[[NSDictionary alloc]initWithDictionary:ma] forKey:kSOCIAL];
    [self stopLoadScreen];
    if (channelHasChanged) {
        channelHasChanged = NO;
        startIndex = 1;
        [api LoadYoutubeVideosFromStartIndex:startIndex withMaxResults:maxResults];
        NSLog(@"social info channel changed");
    }
    isInitialize = YES;

}
-(BOOL)isElementInDictionnaryWithKey:(NSString *)key andValue:(NSString *)value andArray:(NSArray *)array{
    BOOL result = NO;
    int i=0;
    while (!result && i <array.count) {
        if ([[[array objectAtIndex:i]objectForKey:key]isEqualToString:value]) {
            result=YES;
        }
        else{
            i=i+1;
        }
    }
    return  result;
}

#pragma YoutubeApisDelegate
-(void)YoutubeApisDelegateApisDidReturnNetworkError:(NSError *)error forRequest:(NSString *)request{
}
-(void)YoutubeApisDidLoadYoutubeVideos:(NSDictionary *)results{
   // [refreshControl endRefreshing];
    if([[results objectForKey:@"data"]objectForKey:@"items"]==NULL && startIndex==1){
        youtubeData = [[NSArray alloc]initWithObjects:nil, nil];
        searchIndex = -1;
    }else if ([[[results objectForKey:@"data"]objectForKey:@"startIndex"]integerValue]==1) {
        youtubeData = [[NSArray alloc]initWithArray:[self filterMobileEmbedAutoPlayDevices:[(NSDictionary*)[results objectForKey:@"data"]objectForKey:@"items"]]];
        startIndex = startIndex + maxResults;
        tableView.alpha=0;
        [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tableView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }else if([[[results objectForKey:@"data"]objectForKey:@"totalItems"]integerValue]<=([[[results objectForKey:@"data"]objectForKey:@"startIndex"]integerValue]+[[[results objectForKey:@"data"]objectForKey:@"itemsPerPage"]integerValue])){
        NSMutableArray *mutableYoutubeData = [[NSMutableArray alloc]initWithArray:youtubeData];
        [mutableYoutubeData addObjectsFromArray:[self filterMobileEmbedAutoPlayDevices:[(NSDictionary*)[results objectForKey:@"data"]objectForKey:@"items"]]];
        youtubeData = [[NSArray alloc]initWithArray:mutableYoutubeData];
        startIndex = -1;
    }else if (startIndex != -1){
        NSMutableArray *mutableYoutubeData = [[NSMutableArray alloc]initWithArray:youtubeData];
        [mutableYoutubeData addObjectsFromArray:[self filterMobileEmbedAutoPlayDevices:[(NSDictionary*)[results objectForKey:@"data"]objectForKey:@"items"]]];
        youtubeData = [[NSArray alloc]initWithArray:mutableYoutubeData];
        startIndex = startIndex + maxResults;
    }
    [tableView reloadData];
    if ([youtubeData count]>0) {
        noResult.hidden = YES;
    }else{
        noResult.hidden = NO;
    }
}
-(NSArray*)filterMobileEmbedAutoPlayDevices:(NSArray*)itemsArray{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in itemsArray) {
        if ([[[dict objectForKey:@"accessControl"]objectForKey:@"autoPlay"]isEqualToString:@"allowed"]&&[[[dict objectForKey:@"accessControl"]objectForKey:@"embed"]isEqualToString:@"allowed"]&&[[[dict objectForKey:@"accessControl"]objectForKey:@"syndicate"]isEqualToString:@"allowed"]) {
            [mArray addObject:dict];
        }
    }
    return (NSArray*)mArray;
}
-(void)YoutubeApisDidSearchYoutubeVideos:(NSDictionary *)results{
    if([[results objectForKey:@"data"]objectForKey:@"items"]==NULL && searchIndex==1){
        youtubeData = [[NSArray alloc]initWithObjects:nil, nil];
        searchIndex = -1;
    }else if([[[results objectForKey:@"data"]objectForKey:@"startIndex"]integerValue]==1) {
        youtubeData = [[NSArray alloc]initWithArray:[self filterMobileEmbedAutoPlayDevices:[(NSDictionary*)[results objectForKey:@"data"]objectForKey:@"items"]]];
        searchIndex= searchIndex + maxResults;
        tableView.alpha=0;
        [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tableView.alpha=1;
        } completion:^(BOOL finished) {
        }];
    }else if([[[results objectForKey:@"data"]objectForKey:@"totalItems"]integerValue]<=([[[results objectForKey:@"data"]objectForKey:@"startIndex"]integerValue]+[[[results objectForKey:@"data"]objectForKey:@"itemsPerPage"]integerValue])){
        NSMutableArray *mutableYoutubeData = [[NSMutableArray alloc]initWithArray:youtubeData];
        [mutableYoutubeData addObjectsFromArray:[self filterMobileEmbedAutoPlayDevices:[(NSDictionary*)[results objectForKey:@"data"]objectForKey:@"items"]]];
        youtubeData = [[NSArray alloc]initWithArray:mutableYoutubeData];
        searchIndex = -1;
    }else if (searchIndex != -1){
        NSMutableArray *mutableYoutubeData = [[NSMutableArray alloc]initWithArray:youtubeData];
        [mutableYoutubeData addObjectsFromArray:[self filterMobileEmbedAutoPlayDevices:[(NSDictionary*)[results objectForKey:@"data"]objectForKey:@"items"]]];
        youtubeData = [[NSArray alloc]initWithArray:mutableYoutubeData];
        searchIndex = searchIndex + maxResults;
    }
    [tableView reloadData];
    
    if ([youtubeData count]>0) {
        noResult.hidden = YES;
    }else{
        noResult.hidden = NO;
    }

}
-(void)YoutubeApisDidLoadBasicInformation:(NSDictionary *)results{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:results forKey:kSOCIAL];
    [defaults setObject:[results objectForKey:@"thumbnail"] forKey:kTHUMBNAIL];
    [defaults setObject:[results objectForKey:@"name"] forKey:kUSERNAME];
    [defaults setObject:[results objectForKey:@"pseudo"] forKey:kPSEUDO];
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    [deleg.menu performSelectorInBackground:@selector(loadThumbnail:) withObject:[results objectForKey:@"thumbnail"]];
    [deleg.menu loadUsername];
    [self performSelectorInBackground:@selector(loadSocialInformation:) withObject:[NSString stringWithFormat:@"http://www.youtube.com/user/%@/about",[[NSUserDefaults standardUserDefaults]objectForKey:kUSERNAME]]];
}
#pragma TableView delegate and datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [youtubeData count];
}
-(UITableViewCell*)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds=YES;
    cell.contentView.userInteractionEnabled=YES;
    
    NSDictionary *currentItem = [youtubeData objectAtIndex:indexPath.row];
    cell.infos = currentItem;
    cell.btnAction.tag = indexPath.row+1;
    
    if (![[currentItem objectForKey:@"id"]isEqualToString:cell.videoID]) {
        cell.title.text = [currentItem objectForKey:@"title"];
        cell.duration.text = [self formatDuration:[[currentItem objectForKey:@"duration"]intValue]];
        NSString *date = [self getStrForDate:[NSString stringWithFormat:@"%@",[currentItem objectForKey:@"uploaded"]]];
        cell.time.text = date;
        NSString *thumbnail = [(NSDictionary*)[currentItem objectForKey:@"thumbnail"]objectForKey:@"hqDefault"];
        
        cell.backgroundView.mediaPlaybackRequiresUserAction = NO;
        cell.backgroundView.scrollView.scrollEnabled = NO;
        cell.thumbnail=thumbnail;
        [cell reloadThumbnail];
        cell.videoID = [currentItem objectForKey:@"id"];
        
    }
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] objectForKey:kFAVORITE]allKeys];
    cell.isInFavorite = NO;
    if(keys != nil){
        if ([keys containsObject:[currentItem objectForKey:@"id"]]) {
            cell.isInFavorite = YES;
        }
    }
    if (cell.isInFavorite) {
        [cell.heart setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }else{
        [cell.heart setImage:[UIImage imageNamed:@"heart_empty.png"] forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

-(void) doVideo:(NSString*)str
{
    _moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:self.view.frame];
    _moviePlayer.view.alpha = 0.f;
    _moviePlayer.delegate = self;
    _moviePlayer.backgroundView.backgroundColor = [UIColor blackColor];
    _moviePlayer.fullscreen = TRUE;
    //create the controls
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:_moviePlayer style:ALMoviePlayerControlsStyleFullscreen];
    
    [movieControls setBarColor:[UIColor colorWithRed:0.301961 green:0.301961 blue:0.301961 alpha:0.5]];
    [movieControls setTimeRemainingDecrements:YES];
    
    //assign controls
    [_moviePlayer setControls:movieControls];

    [_moviePlayer.view setFrame:self.view.bounds];

    [self.view addSubview:_moviePlayer.view];
    [self.view bringSubviewToFront:_moviePlayer.view];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        _preferredVideoQualities = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:XCDYouTubeVideoQualityHD720], [NSNumber numberWithInt:XCDYouTubeVideoQualityMedium360], [NSNumber numberWithInt:XCDYouTubeVideoQualitySmall240],  nil];
    
    else
        _preferredVideoQualities = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:XCDYouTubeVideoQualityHD1080], [NSNumber numberWithInt:XCDYouTubeVideoQualityHD720], [NSNumber numberWithInt:XCDYouTubeVideoQualityMedium360], [NSNumber numberWithInt:XCDYouTubeVideoQualitySmall240], nil];
    
    self.videoIdentifier = str;
}
-(void)PlayVideo:(NSString*) index
{
    [self doVideo:index];
}
-(void)PlayVideo:(NSString*) index withNotification:(BOOL)b
{
    [self doVideo:index];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!searchMode && indexPath.row == [youtubeData count] - 2 && [youtubeData count]>4) {
       // [api LoadYoutubeVideosFromStartIndex:startIndex withMaxResults:maxResults];
        NSLog(@"willdisplaycell searchmode");
    }else if (searchMode && indexPath.row == [youtubeData count] - 2 && [youtubeData count]>4){
      //  [api SearchYoutubeVideosFromStartIndex:searchIndex withMaxResults:maxResults andQuery:query];
    }
}
#pragma MenuViewControllerDelegate
-(void)MenuViewControllerBeginOpening{
    self.menuButton.enabled = NO;
    self.searchButton.enabled = NO;
    tableView.userInteractionEnabled = NO;
}
-(void)MenuViewControllerEndClosing{
    self.menuButton.enabled = YES;
    self.searchButton.enabled = YES;
    tableView.userInteractionEnabled = YES;
}

-(void) reloadVC:(id)sender {
    if([config_iad isEqualToString:@"YES"] || [config_iad isEqualToString:@"yes"]){
        self.bannerView.delegate = self;
        self.bannerView.hidden = YES;
    }else{
        [self.bannerView removeFromSuperview];
        if (![config_admob_adunitid isEqualToString:@""]) {
           // [self adAdmobBanners];
        }
    }
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    isInitialize = NO;
    api = [[APIs alloc]init];
    api.delegate = self;
    
    startIndex = 1;
    searchIndex = 1;
    maxResults = 5;
    searchMode = NO;
    searchCanLoad = YES;
    channelHasChanged = NO;
    
    dataModel *model = [dataModel sharedManager];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [[config_id componentsSeparatedByString:@","]objectAtIndex:0];
    [userDefault setObject:userID forKey:kUSERID];
    [userDefault setObject:[Tools stringColorFromConfig:config_color] forKey:kTHEMECOLOR];
    if (internetStatus!=NotReachable) {
        [self initializeBasicInformation];
    }else if(internetStatus==NotReachable){
        AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
        [deleg showNoConnection];
    }
   // refreshControl = [[ODRefreshControl alloc] initInScrollView:tableView];
    //[refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    [self updateThemeColor];
    //theTitle.text = NSLocalizedString(@"Videos",nil);
    theTitle.text = model.currentTitle;
    theTitle.textColor = [UIColor whiteColor];
    [theTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    theTitle.adjustsFontSizeToFitWidth = YES;
    [tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
    
    firstLabel.text = NSLocalizedString(@"NO RESULT ?",nil);
    firstLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    [firstLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    secondLabel.text = NSLocalizedString(@"To make another search just touch the search icon at the upper right corner",nil);
    secondLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    [secondLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0]];
    [self.view insertSubview:noResult aboveSubview:tableView];
    noResult.center = tableView.center;
    noResult.hidden = YES;
    
    //Reset Srol position
    [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
}


-(void) youtubePlayed:(id)sender {
    [_moviePlayer stop];
    _moviePlayer = nil;
    
    dataModel *model = [dataModel sharedManager];
    NSUInteger r = arc4random_uniform(model.int_ads_upper_probab) + 1;
    
    if(r==1) {
    [interstitialAd presentFromRootViewController:self];
    }
    
//    NSLog(@"Int Ad probability %d",r);
    NSLog(@"Yes video closed");
}


#pragma mark - NSURLConnectionDataDelegate / NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSUInteger capacity = response.expectedContentLength == NSURLResponseUnknownLength ? 0 : (NSUInteger)response.expectedContentLength;
    self.connectionData = [[NSMutableData alloc] initWithCapacity:capacity];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    NSURL *videoURL = [self videoURLWithData:self.connectionData error:&error];
    if (videoURL)
        self.moviePlayer.contentURL = videoURL;
    else if (self.elFields.count > 0)
        [self startVideoInfoRequest];
    else
        [self finishWithError:error];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self finishWithError:error];
}

- (void)startVideoInfoRequest {
    NSString *elField = [self.elFields objectAtIndex:0];
    [self.elFields removeObjectAtIndex:0];
    if (elField.length > 0)
        elField = [@"&el=" stringByAppendingString : elField];
    
    NSURL *videoInfoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/get_video_info?video_id=%@%@&ps=default&eurl=&gl=US&hl=%@", self.videoIdentifier ? :@"", elField, ApplicationLanguageIdentifier()]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:videoInfoURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setValue:ApplicationLanguageIdentifier() forHTTPHeaderField:@"Accept-Language"];
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)setPreferredVideoQualities:(NSArray *)preferredVideoQualities {
    if (preferredVideoQualities) {
        _preferredVideoQualities = [preferredVideoQualities copy];
    }
    else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            _preferredVideoQualities = @[@(XCDYouTubeVideoQualityHD720), @(XCDYouTubeVideoQualityMedium360), @(XCDYouTubeVideoQualitySmall240)];
        else
            _preferredVideoQualities = @[@(XCDYouTubeVideoQualityHD1080), @(XCDYouTubeVideoQualityHD720), @(XCDYouTubeVideoQualityMedium360), @(XCDYouTubeVideoQualitySmall240)];
    }
}

- (void)finishWithError:(NSError *)error {
    NSDictionary *userInfo = @{ MPMoviePlayerPlaybackDidFinishReasonUserInfoKey : @(MPMovieFinishReasonPlaybackError),
                                XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey: error };
    [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer userInfo:userInfo];
    
    [self.presentingViewController dismissMoviePlayerViewControllerAnimated];
}

#pragma mark - URL Parsing

- (NSURL *)videoURLWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSString *videoQuery = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSStringEncoding queryEncoding = NSUTF8StringEncoding;
    NSDictionary *video = DictionaryWithQueryString(videoQuery, queryEncoding);
    NSMutableArray *streamQueries = [[video[@"url_encoded_fmt_stream_map"] componentsSeparatedByString:@","] mutableCopy];
    [streamQueries addObjectsFromArray:[video[@"adaptive_fmts"] componentsSeparatedByString:@","]];
    
    NSMutableDictionary *streamURLs = [NSMutableDictionary new];
    for (NSString *streamQuery in streamQueries) {
        NSDictionary *stream = DictionaryWithQueryString(streamQuery, queryEncoding);
        NSString *type = stream[@"type"];
        NSString *urlString = stream[@"url"];
        if (urlString && [AVURLAsset isPlayableExtendedMIMEType:type]) {
            NSURL *streamURL = [NSURL URLWithString:urlString];
            NSString *signature = stream[@"sig"];
            if (signature)
                streamURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&signature=%@", urlString, signature]];
            
            if ([[DictionaryWithQueryString(streamURL.query, queryEncoding) allKeys] containsObject:@"signature"])
                streamURLs[@([stream[@"itag"] integerValue])] = streamURL;
        }
    }
    
    for (NSNumber *videoQuality in self.preferredVideoQualities) {
        NSURL *streamURL = streamURLs[videoQuality];
        if (streamURL) {
            NSString *title = video[@"title"];
            NSString *thumbnailSmall = video[@"thumbnail_url"];
            NSString *thumbnailMedium = video[@"iurlsd"];
            NSString *thumbnailLarge = video[@"iurlmaxres"];
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            if (title)
                userInfo[XCDMetadataKeyTitle] = title;
            if (thumbnailSmall)
                userInfo[XCDMetadataKeySmallThumbnailURL] = [NSURL URLWithString:thumbnailSmall];
            if (thumbnailMedium)
                userInfo[XCDMetadataKeyMediumThumbnailURL] = [NSURL URLWithString:thumbnailMedium];
            if (thumbnailLarge)
                userInfo[XCDMetadataKeyLargeThumbnailURL] = [NSURL URLWithString:thumbnailLarge];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XCDYouTubeVideoPlayerViewControllerDidReceiveMetadataNotification object:self userInfo:userInfo];
            return streamURL;
        }
    }
    
    if (error) {
        NSMutableDictionary *userInfo = [@{ NSURLErrorKey: self.connection.originalRequest.URL } mutableCopy];
        NSString *reason = video[@"reason"];
        if (reason) {
            reason = [reason stringByReplacingOccurrencesOfString:@"<br\\s*/?>" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, reason.length)];
            NSRange range;
            while ((range = [reason rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                reason = [reason stringByReplacingCharactersInRange:range withString:@""];
            
            userInfo[NSLocalizedDescriptionKey] = reason;
        }
        
        NSInteger code = [video[@"errorcode"] integerValue];
        *error = [NSError errorWithDomain:XCDYouTubeVideoErrorDomain code:code userInfo:userInfo];
    }
    
    return nil;
}

- (void)setVideoIdentifier:(NSString *)videoIdentifier {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:_cmd withObject:videoIdentifier waitUntilDone:NO];
        return;
    }
    
    if ([videoIdentifier isEqual:self.videoIdentifier])
        return;
    
    _videoIdentifier = [videoIdentifier copy];
    
    self.elFields = [[NSMutableArray alloc] initWithArray:@[@"embedded", @"detailpage", @"vevo", @""]];
    
    [self startVideoInfoRequest];
}

@end
