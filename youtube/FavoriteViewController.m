//
//  FavoriteViewController.m
//  youtube
//
//  Created by Jonathan Martin on 16/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "FavoriteViewController.h"
#import "NewsCell.h"
#import "Constants.h"
#import "Tools.h"
#import "Config.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController
@synthesize admobBannerView;
@synthesize admobBannerView2;

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
    [self.view addSubview:noFavorite];
    noFavorite.center = tableView.center;
    
    if([config_iad isEqualToString:@"YES"] || [config_iad isEqualToString:@"yes"]){
        self.bannerView.delegate = self;
        self.bannerView.hidden = YES;
        self.bannerView2.delegate = self;
        self.bannerView2.hidden = YES;
    }else{
        [self.bannerView removeFromSuperview];
        [self.bannerView2 removeFromSuperview];
        if (![config_admob_adunitid isEqualToString:@""]) {
            [self adAdmobBanners];
        }
    }
    userDefault = [NSUserDefaults standardUserDefaults];
    [self updateThemeColor];
    theTitle.text = NSLocalizedString(@"Favorites",nil);
    theTitle.textColor = [UIColor whiteColor];
    theTitle.adjustsFontSizeToFitWidth = YES;
    [theTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];    [tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
    
    firstLabel.text = NSLocalizedString(@"NO FAVORITE ?",nil);
    firstLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    firstLabel.adjustsFontSizeToFitWidth = YES;
    [firstLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    secondLabel.text = NSLocalizedString(@"To mark an item as favorite just touch the heart icon at the upper right corner of the item box",nil);
    secondLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    secondLabel.adjustsFontSizeToFitWidth = YES;
    [secondLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0]];
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (banner == self.bannerView) {
        if (admobBannerView) {
            admobBannerView.hidden = YES;
        }
        self.bannerView.hidden = NO;
        tableView.tableHeaderView = self.bannerView;
    }
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (banner == self.bannerView) {
        tableView.tableHeaderView = nil;
        self.bannerView.hidden = YES;
        if (![config_admob_adunitid isEqualToString:@""] && !admobBannerView) {
            [self adAdmobBanners];
        }
    }else if(banner == self.bannerView2){
        self.bannerView2.hidden = YES;
    }
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    if (view==admobBannerView) {
        tableView.tableHeaderView = nil;
        self.admobBannerView.hidden = YES;
    }else if(view==admobBannerView2){
        self.admobBannerView2.hidden = YES;
    }
}
-(void)adViewDidReceiveAd:(GADBannerView *)view{
    if (view==admobBannerView) {
        tableView.tableHeaderView = self.admobBannerView;
        self.admobBannerView.hidden = NO;
    }else if(view==admobBannerView2){
        self.admobBannerView2.hidden = NO;
    }
}
-(void)adAdmobBanners{
//    admobBannerView = [[GADBannerView alloc]
//                       initWithFrame:CGRectMake(0,430,
//                                                GAD_SIZE_320x50.width,
//                                                GAD_SIZE_320x50.height)];
//    self.admobBannerView.adUnitID = config_admob_adunitid;
//    self.admobBannerView.rootViewController = self;
//    self.admobBannerView.delegate = self;
//    self.admobBannerView.hidden = YES;
//    [self.admobBannerView loadRequest:[GADRequest request]];
//
//    admobBannerView2 = [[GADBannerView alloc]
//                        initWithFrame:CGRectMake(0,noFavorite.frame.size.height-GAD_SIZE_320x50.height,
//                                                 GAD_SIZE_320x50.width,
//                                                 GAD_SIZE_320x50.height)];
//    self.admobBannerView2.adUnitID = config_admob_adunitid;
//    self.admobBannerView2.rootViewController = self;
//    self.admobBannerView2.delegate = self;
//    self.admobBannerView2.hidden = YES;
//    [noFavorite addSubview:admobBannerView2];
//    [self.admobBannerView2 loadRequest:[GADRequest request]];
    
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

}

-(void)refreshMenu{
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    menu = deleg.menu;
    menu.delegate = self;
    [menu.view removeFromSuperview];
    [self.view addSubview:menu.view];
}
-(void)viewWillDisappear:(BOOL)animated{
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    deleg.menu = menu;
}
-(void)viewWillAppear:(BOOL)animated{
    [self refreshMenu];
    [self updateFavorite];
    [menu closeMenu];
}
- (IBAction)menuPressed:(id)sender {
    if (menu.isOpen) {
        [menu closeMenu];
    }
    else
    {
        [self.view bringSubviewToFront:menu.view];
        [menu openMenu];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Utility
-(void)updateFavorite{
    if([[userDefault objectForKey:kFAVORITE]count]>0){
        noFavorite.hidden=YES;
        NSDictionary *dict = [userDefault objectForKey:kFAVORITE];
        NSArray *keys = [dict allKeys];
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for(NSString *key in keys) {
            [ma addObject:[dict objectForKey:key]];
        }
        youtubeData = [[NSArray alloc]initWithArray:ma];
        [tableView reloadData];
    }else{
        noFavorite.hidden=NO;
    }
}
-(void)updateThemeColor{
    navigationBar.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
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
        cell.time.hidden = YES;
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
    return cell;
}
#pragma MenuViewControllerDelegate
-(void)MenuViewControllerBeginOpening{
    self.menuButton.enabled = NO;
    tableView.userInteractionEnabled = NO;
}
-(void)MenuViewControllerEndClosing{
    self.menuButton.enabled = YES;
    tableView.userInteractionEnabled = YES;
}
@end
