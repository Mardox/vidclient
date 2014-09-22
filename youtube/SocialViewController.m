//
//  SocialViewController.m
//  youtube
//
//  Created by Jonathan Martin on 18/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "SocialViewController.h"
#import "Constants.h"
#import "Tools.h"
#import "WebViewController.h"
#import "Config.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

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
    shouldRefresh=YES;
    shouldRefresh2=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateThemeColor)
                                                 name:kNOTIFICATIONCOLORCHANGED
                                               object:nil];
    sendButton.hidden = YES;
    if ([self validateEmail:config_email]) {
        sendButton.hidden = NO;
    }
    [self updateThemeColor];
    theTitle.text = NSLocalizedString(@"Social",nil);
    theTitle.textColor = [UIColor whiteColor];
    theTitle.adjustsFontSizeToFitWidth = YES;
    [theTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    mode = -1;
    
    twitter = NO;
    facebook = NO;
    linkedin = NO;
    tumblr = NO;
    soundcloud = NO;
    pinterest = NO;
    flickr = NO;
    apple = NO;
    instagram = NO;
    wordpress = NO;
    android = NO;
    deviantart = NO;
    blogger = NO;
    subscribers = NO;
    views = NO;
    videocount = NO;
    spreadshirt = NO;
    
    flag = 0;
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
-(void)refreshSocial{
    int temp = (int)[[[[NSUserDefaults standardUserDefaults]objectForKey:kSOCIAL]objectForKey:kSOCIALLINKS]count];
    if (temp==0) {
        mode = 4;
    }else if (temp>0 && temp<5){
        mode = 5;
    }else if (temp>=5){
        mode = 9;
    }
    twitter =NO;
    facebook = NO;
    linkedin = NO;
    tumblr = NO;
    soundcloud = NO;
    pinterest = NO;
    flickr = NO;
    apple = NO;
    instagram = NO;
    wordpress = NO;
    android = NO;
    deviantart = NO;
    blogger = NO;
    subscribers = NO;
    views = NO;
    videocount = NO;
    spreadshirt = NO;
    
    flag = 0;
    
    for (UIView *v in self.view.subviews) {
        if (v!=navigationBar) {
            [[v subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }

    [self setupMode:mode];
}
-(void)setupMode:(int)theMode{
    NSArray *social = [[[NSUserDefaults standardUserDefaults]objectForKey:kSOCIAL]objectForKey:kSOCIALLINKS];
    customs = [[NSMutableArray alloc]init];
    links =[[NSMutableDictionary alloc]init];
    for (int i = 0; i<[social count]; i++) {
        if ([[[social objectAtIndex:i]objectForKey:@"category"]isEqualToString:@"custom"]) {
            [customs addObject:[social objectAtIndex:i]];
        }else{
            [links setObject:[social objectAtIndex:i] forKey:[[social objectAtIndex:i]objectForKey:@"category"]];
        }
    }
    NSArray *keys = [links allKeys];
    if ([keys containsObject:@"twitter"]) {
        twitter = YES;
    }
    if ([keys containsObject:@"facebook"]) {
        facebook = YES;
    }
    if ([keys containsObject:@"linkedin"]) {
        linkedin = YES;
    }
    if ([keys containsObject:@"tumblr"]) {
        tumblr = YES;
    }
    if ([keys containsObject:@"soundcloud"]) {
        soundcloud = YES;
    }
    if ([keys containsObject:@"pinterest"]) {
        pinterest = YES;
    }
    if ([keys containsObject:@"flickr"]) {
        flickr = YES;
    }
    if ([keys containsObject:@"apple"]) {
        apple = YES;
    }
    if ([keys containsObject:@"instagram"]) {
        instagram = YES;
    }
    if ([keys containsObject:@"wordpress"]) {
        wordpress = YES;
    }
    if ([keys containsObject:@"android"]) {
        android = YES;
    }
    if ([keys containsObject:@"deviantart"]) {
        deviantart = YES;
    }
    if ([keys containsObject:@"blogspot"]) {
        blogger = YES;
    }
    if ([keys containsObject:@"spreadshirt"]) {
        spreadshirt = YES;
    }
    if (theMode == 4) {
        view1.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view2.backgroundColor = [Tools colorWithHexString:color_grey_instagram];
        view3.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
        view4.backgroundColor = [Tools colorWithHexString:color_blue_facebook];
        view5.backgroundColor = [Tools colorWithHexString:color_black_google];
        view6.backgroundColor = [Tools colorWithHexString:color_red_youtube];
        view7.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
        view8.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
        view9.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view10.backgroundColor = [Tools colorWithHexString:color_grey_apple];
        view11.backgroundColor = [Tools colorWithHexString:color_red_youtube];
        view12.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
        view13.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
        view14.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view15.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
    }
    else if (theMode == 5){
        view1.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view2.backgroundColor = [Tools colorWithHexString:color_grey_instagram];
        view3.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
        view4.backgroundColor = [Tools colorWithHexString:color_blue_facebook];
        view5.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
        view6.backgroundColor = [Tools colorWithHexString:color_red_youtube];
        view7.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
        view8.backgroundColor = [Tools colorWithHexString:color_black_google];
        view9.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view10.backgroundColor = [Tools colorWithHexString:color_grey_apple];
        view11.backgroundColor = [Tools colorWithHexString:color_red_youtube];
        view12.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
        view13.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
        view14.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view15.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
    }
    else if (theMode == 9){
        view1.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view2.backgroundColor = [Tools colorWithHexString:color_grey_instagram];
        view3.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
        view4.backgroundColor = [Tools colorWithHexString:color_blue_facebook];
        view5.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
        view6.backgroundColor = [Tools colorWithHexString:color_red_youtube];
        view7.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
        view8.backgroundColor = [Tools colorWithHexString:color_black_google];
        view9.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view10.backgroundColor = [Tools colorWithHexString:color_grey_apple];
        view11.backgroundColor = [Tools colorWithHexString:color_red_youtube];
        view12.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
        view13.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
        view14.backgroundColor = [Tools colorWithHexString:color_green_envato];
        view15.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
    }
    
    if (theMode == 4) {
        
        [self addButtonType:type_google inView:view5];
        [self addDefaultType:type_subscribers InView:view7];
        [self addDefaultType:type_videocount InView:view9];
        [self addDefaultType:type_views InView:view11];
        
    }
    else if (mode == 5){
        
        // Case 4
        if (facebook) {
            [self addButtonType:type_facebook inView:view4];
            facebook = NO;
        }else if (linkedin){
            view4.backgroundColor = [Tools colorWithHexString:color_blue_linkedin];
            [self addButtonType:type_linkedin inView:view4];
            linkedin = NO;
        }else if (tumblr){
            view4.backgroundColor = [Tools colorWithHexString:color_blue_tumblr];
            [self addButtonType:type_tumblr inView:view4];
            tumblr = NO;
        }else if (soundcloud){
            view4.backgroundColor = [Tools colorWithHexString:color_blue_soundcloud];
            [self addButtonType:type_soundcloud inView:view4];
            soundcloud = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view4];
        }else{
            [self addDefaultType:type_subscribers InView:view4];
            subscribers = YES;
        }
        
        //Case 6
        if (pinterest) {
            [self addButtonType:type_pinterest inView:view6];
            pinterest = NO;
        }else if (blogger){
            view3.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
            view6.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
            [self addButtonType:type_blogger inView:view6];
            blogger = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view6];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view6];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view6];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view6];
            views = YES;
        }
        
        //Case 8
        [self addButtonType:type_google inView:view8];
        
        //Case 10
        if (instagram) {
            view10.backgroundColor = [Tools colorWithHexString:color_grey_instagram];
            [self addButtonType:type_instagram inView:view10];
            instagram = NO;
        }else if (wordpress){
            view10.backgroundColor = [Tools colorWithHexString:color_grey_wordpress];
            [self addButtonType:type_wordpress inView:view10];
            wordpress = NO;
        }else if (apple){
            [self addButtonType:type_apple inView:view10];
            apple = NO;
        }else if (deviantart){
            view10.backgroundColor = [Tools colorWithHexString:color_green_deviantart];
            [self addButtonType:type_deviantart inView:view10];
            deviantart = NO;
        }else if (android){
            view10.backgroundColor = [Tools colorWithHexString:color_green_android];
            [self addButtonType:type_android inView:view10];
            android = NO;
        }else if (spreadshirt){
            view10.backgroundColor = [Tools colorWithHexString:color_green_spreadshirt];
            [self addButtonType:type_spreadshirt inView:view10];
            spreadshirt = NO;
        }else if (tumblr && twitter){
            view10.backgroundColor = [Tools colorWithHexString:color_blue_tumblr];
            [self addButtonType:type_tumblr inView:view10];
            tumblr = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view10];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view10];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view10];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view10];
            views = YES;
        }
        
        //Case 12
        if (twitter) {
            [self addButtonType:type_twitter inView:view12];
            twitter = NO;
        }else if (linkedin){
            view12.backgroundColor = [Tools colorWithHexString:color_blue_linkedin];
            [self addButtonType:type_linkedin inView:view12];
            linkedin = NO;
        }else if (tumblr){
            view12.backgroundColor = [Tools colorWithHexString:color_blue_tumblr];
            [self addButtonType:type_tumblr inView:view12];
            tumblr = NO;
        }else if (soundcloud){
            view12.backgroundColor = [Tools colorWithHexString:color_blue_soundcloud];
            [self addButtonType:type_soundcloud inView:view12];
            soundcloud = NO;
        }else if (blogger){
            view12.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
            [self addButtonType:type_blogger inView:view12];
            blogger = NO;
        }else if (wordpress){
            view12.backgroundColor = [Tools colorWithHexString:color_grey_wordpress];
            [self addButtonType:type_wordpress inView:view12];
            wordpress = NO;
        }else if (apple){
            view12.backgroundColor = [Tools colorWithHexString:color_grey_apple];
            [self addButtonType:type_apple inView:view12];
            apple = NO;
        }else if (spreadshirt){
            view12.backgroundColor = [Tools colorWithHexString:color_green_spreadshirt];
            [self addButtonType:type_spreadshirt inView:view12];
            spreadshirt = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view12];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view12];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view12];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view12];
            views = YES;
        }
    }
    else if (mode == 9){
        // Case 4
        if (facebook) {
            [self addButtonType:type_facebook inView:view4];
            facebook = NO;
        }else if (linkedin){
            view4.backgroundColor = [Tools colorWithHexString:color_blue_linkedin];
            [self addButtonType:type_linkedin inView:view4];
            linkedin = NO;
        }else if (tumblr){
            view4.backgroundColor = [Tools colorWithHexString:color_blue_tumblr];
            [self addButtonType:type_tumblr inView:view4];
            tumblr = NO;
        }else if (soundcloud){
            view4.backgroundColor = [Tools colorWithHexString:color_blue_soundcloud];
            [self addButtonType:type_soundcloud inView:view4];
            soundcloud = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view4];
        }else{
            [self addDefaultType:type_subscribers InView:view4];
            subscribers = YES;
        }
        //Case 5
        if (flickr) {
            [self addButtonType:type_flickr inView:view5];
            flickr = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view5];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view5];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view5];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view5];
            views = YES;
        }
        //Case 6
        if (pinterest) {
            [self addButtonType:type_pinterest inView:view6];
            pinterest = NO;
        }else if (apple){
            view6.backgroundColor = [Tools colorWithHexString:color_grey_apple];
            [self addButtonType:type_apple inView:view6];
            apple = NO;
        }else if (tumblr && twitter){
            view6.backgroundColor = [Tools colorWithHexString:color_blue_tumblr];
            [self addButtonType:type_tumblr inView:view6];
            tumblr = NO;
        }else if (soundcloud && twitter){
            view6.backgroundColor = [Tools colorWithHexString:color_blue_soundcloud];
            [self addButtonType:type_soundcloud inView:view6];
            soundcloud = NO;
        }else if (linkedin && twitter){
            view6.backgroundColor = [Tools colorWithHexString:color_blue_linkedin];
            [self addButtonType:type_linkedin inView:view6];
            linkedin = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view6];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view6];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view6];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view6];
            views = YES;
        }
        //Case 7
        if (blogger) {
            [self addButtonType:type_blogger inView:view7];
            blogger = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view7];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view7];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view7];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view7];
            views = YES;
        }
        //Case 8
        [self addButtonType:type_google inView:view8];
        //Case 9
        if (android) {
            view9.backgroundColor = [Tools colorWithHexString:color_green_android];
            [self addButtonType:type_android inView:view9];
            android = NO;
        }else if (deviantart) {
            view9.backgroundColor = [Tools colorWithHexString:color_green_deviantart];
            [self addButtonType:type_deviantart inView:view9];
            deviantart = NO;
        }else if (spreadshirt){
            view9.backgroundColor = [Tools colorWithHexString:color_green_spreadshirt];
            [self addButtonType:type_spreadshirt inView:view9];
            spreadshirt = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view9];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view9];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view9];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view9];
            views = YES;
        }
        //Case 10
        if (instagram) {
            view10.backgroundColor = [Tools colorWithHexString:color_grey_instagram];
            [self addButtonType:type_instagram inView:view10];
            instagram = NO;
        }else if (wordpress){
            view10.backgroundColor = [Tools colorWithHexString:color_grey_wordpress];
            [self addButtonType:type_wordpress inView:view10];
            wordpress = NO;
        }else if (apple){
            [self addButtonType:type_apple inView:view10];
            apple = NO;
        }else if (deviantart){
            view10.backgroundColor = [Tools colorWithHexString:color_green_deviantart];
            [self addButtonType:type_deviantart inView:view10];
            deviantart = NO;
        }else if (spreadshirt){
            view10.backgroundColor = [Tools colorWithHexString:color_green_spreadshirt];
            [self addButtonType:type_spreadshirt inView:view10];
            spreadshirt = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view10];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view10];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view10];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view10];
            views = YES;
        }
        //Case 11
        if ([customs count]>flag){
            [self addCustomLinkInView:view11];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view11];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view11];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view11];
            views = YES;
        }
        //Case 12
        if (twitter) {
            [self addButtonType:type_twitter inView:view12];
            twitter = NO;
        }else if (linkedin){
            view12.backgroundColor = [Tools colorWithHexString:color_blue_linkedin];
            [self addButtonType:type_linkedin inView:view12];
            linkedin = NO;
        }else if (tumblr){
            view12.backgroundColor = [Tools colorWithHexString:color_blue_tumblr];
            [self addButtonType:type_tumblr inView:view12];
            tumblr = NO;
        }else if (soundcloud){
            view12.backgroundColor = [Tools colorWithHexString:color_blue_soundcloud];
            [self addButtonType:type_soundcloud inView:view12];
            soundcloud = NO;
        }else if (blogger){
            view12.backgroundColor = [Tools colorWithHexString:color_yellow_blogger];
            [self addButtonType:type_blogger inView:view12];
            blogger = NO;
        }else if (wordpress){
            view12.backgroundColor = [Tools colorWithHexString:color_grey_wordpress];
            [self addButtonType:type_wordpress inView:view12];
            wordpress = NO;
        }else if (apple){
            view12.backgroundColor = [Tools colorWithHexString:color_grey_apple];
            [self addButtonType:type_apple inView:view12];
            apple = NO;
        }else if ([customs count]>flag){
            [self addCustomLinkInView:view12];
        }else if (!subscribers){
            [self addDefaultType:type_subscribers InView:view12];
            subscribers = YES;
        }else if (!videocount){
            [self addDefaultType:type_videocount InView:view12];
            videocount = YES;
        }else if (!views){
            [self addDefaultType:type_views InView:view12];
            views = YES;
        }
        
    }
}
-(void)loadGoogle:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"https://plus.google.com/%@",[[[NSUserDefaults standardUserDefaults]objectForKey:kSOCIAL]objectForKey:@"googleplusid"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadFacebook:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"facebook"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadLinkedin:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"linkedin"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadTumblr:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"tumblr"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadSoundcloud:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"soundcloud"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadPinterest:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"pinterest"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadInstagram:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"instagram"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadWordpress:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"wordpress"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadApple:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    NSString *url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"apple"]objectForKey:@"link"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
}
-(void)loadTwitter:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"twitter"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadDeviantart:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"deviantart"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadAndroid:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"android"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadBlogger:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"blogspot"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadSpreadshirt:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"%@",[[links objectForKey:@"spreadshirt"]objectForKey:@"link"]];
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)loadCustom:(id)sender{
    shouldRefresh=NO;
    shouldRefresh2=NO;
    UIButton* temp = (UIButton*)sender;
    NSString *url = [[customs objectAtIndex:temp.tag-1]objectForKey:@"link"];
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = url;
    [self.navigationController pushViewController:wv animated:YES];
}
-(void)addButtonType:(NSString*)type inView:(UIView*)view{
    UIButton *standardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([type isEqualToString:type_facebook]) {
        [standardButton addTarget:self
                           action:@selector(loadFacebook:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_google]){
        [standardButton addTarget:self
                           action:@selector(loadGoogle:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"google_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_linkedin]){
        [standardButton addTarget:self
                           action:@selector(loadLinkedin:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"linkedin_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_tumblr]){
        [standardButton addTarget:self
                           action:@selector(loadTumblr:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"tumblr_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_soundcloud]){
        [standardButton addTarget:self
                           action:@selector(loadSoundcloud:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"soundcloud_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_pinterest]){
        [standardButton addTarget:self
                           action:@selector(loadPinterest:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"pinterest_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_instagram]){
        [standardButton addTarget:self
                           action:@selector(loadInstagram:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"instagram_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_wordpress]){
        [standardButton addTarget:self
                           action:@selector(loadWordpress:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"wordpress_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_apple]){
        [standardButton addTarget:self
                           action:@selector(loadApple:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"apple_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_twitter]){
        [standardButton addTarget:self
                           action:@selector(loadTwitter:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"twitter_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_deviantart]){
        [standardButton addTarget:self
                           action:@selector(loadDeviantart:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"deviantart_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_android]){
        [standardButton addTarget:self
                           action:@selector(loadAndroid:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"android_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_blogger]){
        [standardButton addTarget:self
                           action:@selector(loadBlogger:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"blogger_icon.png"] forState:UIControlStateNormal];
    }else if ([type isEqualToString:type_spreadshirt]){
        [standardButton addTarget:self
                           action:@selector(loadSpreadshirt:)
                 forControlEvents:UIControlEventTouchUpInside];
        [standardButton setImage:[UIImage imageNamed:@"spreadshirt_icon.png"] forState:UIControlStateNormal];
    }
    standardButton.frame = [view bounds];
    [view addSubview:standardButton];
}
-(void)addCustomLinkInView:(UIView*)view{
    NSDictionary *dict = [customs objectAtIndex:flag];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, view.frame.size.width-10, view.frame.size.height-10)];
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    lab.numberOfLines = 3;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [dict objectForKey:@"title"];
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton addTarget:self
                     action:@selector(loadCustom:)
           forControlEvents:UIControlEventTouchUpInside];
    customButton.titleLabel.tintColor = [UIColor whiteColor];
    customButton.frame = [view bounds];
    customButton.tag = flag+1;
    flag = flag+1;
    [view addSubview:customButton];
}
-(void)addDefaultType:(NSString*)type InView:(UIView*)view{
    if ([type isEqualToString:type_subscribers]) {
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_subscribers.png"]];
        iv.frame = CGRectMake(view.frame.size.width/3, view.frame.size.height/3, 36, 24);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2+10, view.frame.size.width, 20)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:kSOCIAL]objectForKey:@"subscriberCount"]];
        [label setTextColor:[UIColor whiteColor]] ;
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [view addSubview:iv];
        [view addSubview:label];
    }else if ([type isEqualToString:type_views]){
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_views.png"]];
        iv.frame = CGRectMake(view.frame.size.width/3-1, view.frame.size.height/3, 38, 25);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2+10, view.frame.size.width, 20)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:kSOCIAL]objectForKey:@"totalUploadViews"]];
        [label setTextColor:[UIColor whiteColor]] ;
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [view addSubview:iv];
        [view addSubview:label];
    }else if ([type isEqualToString:type_videocount]){
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_video.png"]];
        iv.frame = CGRectMake(view.frame.size.width/3+3, view.frame.size.height/3-6, 31, 31);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2+10, view.frame.size.width, 20)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:kSOCIAL]objectForKey:@"videocount"]];
        [label setTextColor:[UIColor whiteColor]] ;
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [view addSubview:iv];
        [view addSubview:label];
    }
}
- (IBAction)sendPressed:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        shouldRefresh=NO;
        shouldRefresh2=NO;
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@""];
        [mailViewController setMessageBody:@"" isHTML:NO];
        [mailViewController setToRecipients:@[config_email]];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Warning",nil) message: NSLocalizedString(@"You need a Mail account to continue.",nil) delegate: nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
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
-(void)updateThemeColor{
    navigationBar.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
}
-(void)refreshMenu{
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    menu = deleg.menu;
    [menu.view removeFromSuperview];
    [self.view addSubview:menu.view];
}
-(void)viewWillDisappear:(BOOL)animated{
    if (shouldRefresh) {
        AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
        deleg.menu = menu;
    }
    else
    {
        shouldRefresh=YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    if (shouldRefresh2) {
        [self refreshSocial];
        [self refreshMenu];
        [menu closeMenu];
    }
    else
    {
        shouldRefresh2=YES;
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
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    shouldRefresh=NO;
    shouldRefresh2=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
