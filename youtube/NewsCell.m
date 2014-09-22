//
//  NewsCell.m
//  youtube
//
//  Created by Martin Jonathan on 05/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "NewsCell.h"
#import "Tools.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import "WebViewController.h"
#import "NewsViewController.h"
#import "FavoriteViewController.h"
#import "Config.h"

static int iCount;

@implementation NewsCell
@synthesize videoID;
@synthesize infos;
@synthesize isInFavorite;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder])
    {
        favoriteMode = NO;
        loader = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        loader.delegate = self;
        loader.allowsInlineMediaPlayback = YES;
        loader.mediaPlaybackRequiresUserAction = NO;
        [self addSubview:loader];
    }
    return self;
}
-(void)playStart:(id)sender{
    [self performSelector:@selector(StopLoadingMode) withObject:nil afterDelay:1];
}
-(void)playFinish:(id)sender{
    [self reloadThumbnail];
    self.btnAction.hidden = NO;
}
-(IBAction)TouchedCell:(id)sender{
    if ([config_youtube_redirection isEqualToString:@"NO"]) {
        if (!notificationSetup) {
            [self.delegate PlayVideo:videoID withNotification:TRUE];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playStart:)
                                                         name:MPMoviePlayerDidEnterFullscreenNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playFinish:)
                                                         name:MPMoviePlayerDidExitFullscreenNotification
                                                       object:nil];
            notificationSetup=YES;
        }
        self.btnAction.hidden=YES;
        
//        NSString *youTubeVideoHTML = [NSString stringWithFormat:@"<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'320', height:'180', videoId:'%@',                                                         events: { 'onReady': onPlayerReady , 'onStateChange': onPlayerStateChange } }); }function onPlayerReady(event) { event.target.playVideo(); window.location = \"videomessage://end\";}   function onPlayerStateChange(event) { if (event.data == YT.PlayerState.ENDED) { window.location = \"videoFinish://end\";}}</script> </body> </html>",videoID];
//        
//        [loader loadHTMLString:youTubeVideoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
        [self StartLoadingMode];
    }else{
//        [self youtubeSelected:self];
        [self unLoadShareController];
        [self.delegate PlayVideo:videoID];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self unLoadShareController];
}
- (IBAction)favoriteSelected:(id)sender {
    if (!favoriteMode) {
        [self loadShareController];
    }else{
        [self unLoadShareController];
    }
}
-(void)facebookSelected:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:NSLocalizedString(@"Take a look at this video : ",nil)];
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoID]]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnail]]];
        [controller addImage:image];
        AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIViewController *cl = (UIViewController *)[deleg.tab selectedViewController];
        [cl presentViewController:controller animated:YES completion:Nil];
        [self unLoadShareController];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Warning",nil) message: NSLocalizedString(@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings.",nil) delegate: nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
}
-(void)favorite:(id)sender{
    if (isInFavorite) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.heart.frame.origin.x+(self.heart.frame.size.width/2)-16, self.heart.frame.origin.y+(self.heart.frame.size.height/2)-14, 33, 28)];
        [self.heart setImage:[UIImage imageNamed:@"heart_empty.png"] forState:UIControlStateNormal];
        [img setImage:[UIImage imageNamed:@"heart.png"]];
        [self.heart.superview addSubview:img];
        UIButton *send = (UIButton *)sender;
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(send.frame.origin.x+(send.frame.size.width/2), send.frame.origin.y+(send.frame.size.height/2), 0, 1)];
        [img2 setImage:[UIImage imageNamed:@"share_heart.png"]];
        [send.superview addSubview:img2];
        
        [UIView animateWithDuration:0.7 animations:^{
            img.frame = CGRectMake(self.heart.frame.origin.x+(self.heart.frame.size.width/2), self.heart.frame.origin.y+(self.heart.frame.size.height/2), 0, 1);
            img2.frame = CGRectMake(send.frame.origin.x+(send.frame.size.width/2)-12, send.frame.origin.y+(send.frame.size.height/2)-10, 24, 21);
        } completion:^(BOOL finished) {
            [send setImage:[UIImage imageNamed:@"share_heart.png"] forState:UIControlStateNormal];
            [img removeFromSuperview];
            [img2 removeFromSuperview];
            [self removeFromFavorite];
            [self unLoadShareController];
        }];
    }else{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.heart.frame.origin.x+(self.heart.frame.size.width/2), self.heart.frame.origin.y+(self.heart.frame.size.height/2), 0, 0)];
        [img setImage:[UIImage imageNamed:@"heart.png"]];
        [self.heart.superview addSubview:img];
        UIButton *send = (UIButton *)sender;
        [send setImage:[UIImage imageNamed:@"share_heart_empty.png"] forState:UIControlStateNormal];
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(send.frame.origin.x+(send.frame.size.width/2)-12, send.frame.origin.y+(send.frame.size.height/2)-10, 24, 21)];
        [img2 setImage:[UIImage imageNamed:@"share_heart.png"]];
        [send.superview addSubview:img2];
        
        [UIView animateWithDuration:0.7 animations:^{
            img.frame = CGRectMake(self.heart.frame.origin.x+(self.heart.frame.size.width/2)-16, self.heart.frame.origin.y+(self.heart.frame.size.height/2)-14, 33, 28);
            img2.frame = CGRectMake(send.frame.origin.x+(send.frame.size.width/2), send.frame.origin.y+(send.frame.size.height/2), 0, 0);
        } completion:^(BOOL finished) {
            [self.heart setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
            [img removeFromSuperview];
            [img2 removeFromSuperview];
            [self addVideoToFavorite];
            [self unLoadShareController];
        }];
    }
}
-(void)twitterSelected:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [controller setInitialText:NSLocalizedString(@"Take a look at this video : ",nil)];
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoID]]];
        AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIViewController *cl = (UIViewController *)[deleg.tab selectedViewController];
        [cl presentViewController:controller animated:YES completion:nil];
        [self unLoadShareController];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Warning",nil) message: NSLocalizedString(@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings.",nil) delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
}
-(void)youtubeSelected:(id)sender{
    WebViewController *wv;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        wv = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        wv = [[WebViewController alloc]initWithNibName:@"WebViewControlleri5" bundle:nil];
    }
    wv.url = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoID];
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *cl = (UINavigationController *)[deleg.tab selectedViewController];
    [self unLoadShareController];
    [cl pushViewController:wv animated:YES];
}
-(void)addVideoToFavorite{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if(![userDefault objectForKey:kFAVORITE]){
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:infos,[infos objectForKey:@"id"], nil];
        [userDefault setObject:dict forKey:kFAVORITE];
    }else{
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc]initWithDictionary:[userDefault objectForKey:kFAVORITE]];
        [mdict setObject:infos forKey:[infos objectForKey:@"id"]];
        NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:mdict];
        [userDefault setObject:dict forKey:kFAVORITE];
    }
    isInFavorite = YES;
}
-(void)removeFromFavorite{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc]initWithDictionary:[userDefault objectForKey:kFAVORITE]];
    [mdict removeObjectForKey:[infos objectForKey:@"id"]];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:mdict];
    [userDefault setObject:dict forKey:kFAVORITE];
    isInFavorite = NO;
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *nav = (UINavigationController *)[deleg.tab selectedViewController];
    if ([nav.viewControllers[0] isKindOfClass:[FavoriteViewController class]]) {
        FavoriteViewController *fvc = (FavoriteViewController *)nav.viewControllers[0];
        [fvc updateFavorite];
    }
}
-(void)loadShareController{
    
    favoriteMode = YES;
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 44)];
    shareView.backgroundColor = [UIColor blackColor];
    
    UIView *facebook = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/4, 44)];
    facebook.backgroundColor = [Tools colorWithHexString:color_blue_facebook];
    UIButton *facebookButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, facebook.frame.size.width, facebook.frame.size.height)];
    [facebookButton setImage:[UIImage imageNamed:@"share_facebook.png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(facebookSelected:) forControlEvents:UIControlEventTouchUpInside];
    [facebook addSubview:facebookButton];
    [shareView addSubview:facebook];

    UIView *favorite = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/4*1, 0, self.frame.size.width/4, 44)];
    favorite.backgroundColor = [Tools colorWithHexString:color_purple_dribbble];
    UIButton *favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, favorite.frame.size.width, favorite.frame.size.height)];
    if (isInFavorite) {
        [favoriteButton setImage:[UIImage imageNamed:@"share_heart_empty.png"] forState:UIControlStateNormal];
    }else{
        [favoriteButton setImage:[UIImage imageNamed:@"share_heart.png"] forState:UIControlStateNormal];
    }
    [favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    [favorite addSubview:favoriteButton];
    [shareView addSubview:favorite];
    
    UIView *twitter = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/4*2, 0, self.frame.size.width/4, 44)];
    twitter.backgroundColor = [Tools colorWithHexString:color_blue_twitter];
    UIButton *twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, twitter.frame.size.width, twitter.frame.size.height)];
    [twitterButton setImage:[UIImage imageNamed:@"share_twitter.png"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(twitterSelected:) forControlEvents:UIControlEventTouchUpInside];
    [twitter addSubview:twitterButton];
    [shareView addSubview:twitter];
    
    UIView *youtube = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/4*3, 0, self.frame.size.width/4, 44)];
    youtube.backgroundColor = [Tools colorWithHexString:color_red_youtube];
    UIButton *youtubeButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, youtube.frame.size.width, youtube.frame.size.height)];
    [youtubeButton setImage:[UIImage imageNamed:@"share_youtube.png"] forState:UIControlStateNormal];
    [youtubeButton addTarget:self action:@selector(youtubeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [youtube addSubview:youtubeButton];
    [shareView addSubview:youtube];
    
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        shareView.frame = CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44);
    } completion:^(BOOL finished) {
    }];
    [self addSubview:shareView];
    
    dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self
                     action:@selector(unLoadShareController)
           forControlEvents:UIControlEventTouchUpInside];
    dismissButton.titleLabel.tintColor = [UIColor clearColor];
    dismissButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-44);
    [self addSubview:dismissButton];

}
-(void)unLoadShareController{
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        shareView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 44);
    } completion:^(BOOL finished) {
        favoriteMode = NO;
        if (dismissButton) {
            [dismissButton removeFromSuperview];
        }
    }];
}
-(void)reloadThumbnail{
    if (self.backgroundView.delegate==nil) {
        self.backgroundView.delegate=self;
    }
    reloadThumbnail = YES;
    [self.backgroundView loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                                         <style type=\"text/css\">\
                                         body {\
                                         background-color: black;\
                                         color: black;\
                                         margin: 0;\
                                         margin-top:-30;\
                                         }\
                                         </style>\
                                         </head><body> \
                                         <img src=\"%@\" width=\"%f\">\
                                         </body></html>",self.thumbnail,self.backgroundView.frame.size.width] baseURL:[[NSBundle mainBundle] resourceURL]];
}
-(void)StartLoadingMode{
    temp = [self GetTableView];
    temp.userInteractionEnabled = NO;
    temp.scrollEnabled = NO;
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *tempo = (UINavigationController*)[deleg.tab selectedViewController];
    if ([tempo.viewControllers[0] isKindOfClass:[NewsViewController class]]) {
        NewsViewController *nvc = (NewsViewController *)tempo.viewControllers[0];
        nvc.menuButton.enabled = NO;
        nvc.searchButton.enabled = NO;
    }else if ([tempo.viewControllers[0] isKindOfClass:[FavoriteViewController class]]){
        FavoriteViewController *fvc = (FavoriteViewController *)tempo.viewControllers[0];
        fvc.menuButton.enabled = NO;
    }

    
    currentView = [[UIView alloc]initWithFrame:CGRectMake(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height)];
    currentView.backgroundColor = [UIColor clearColor];
    
    UIView *second = [[UIView alloc]initWithFrame:CGRectMake(temp.frame.origin.x, 0, temp.frame.size.width, temp.frame.size.height)];
    second.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
    
    activity = [[CBActivityIndicator alloc]initWithFrame:CGRectMake(currentView.frame.size.width/4, currentView.frame.size.height/2, currentView.frame.size.width/2,currentView.frame.size.height/10)];
    activity.center = second.center;
    activity.activityColor = [UIColor whiteColor];
    [activity startAnimating];
    [currentView addSubview:second];
    [currentView addSubview:activity];
    [temp.superview addSubview:currentView];
}
-(void)StopLoadingMode{
    temp.userInteractionEnabled = YES;
    temp.scrollEnabled = YES;
    AppDelegate *deleg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *tempo = (UINavigationController*)[deleg.tab selectedViewController];
    if ([tempo.viewControllers[0] isKindOfClass:[NewsViewController class]]) {
        NewsViewController *nvc = (NewsViewController *)tempo.viewControllers[0];
        nvc.menuButton.enabled = YES;
        nvc.searchButton.enabled = YES;
    }else if ([tempo.viewControllers[0] isKindOfClass:[FavoriteViewController class]]){
        FavoriteViewController *fvc = (FavoriteViewController *)tempo.viewControllers[0];
        fvc.menuButton.enabled = YES;
    }
    [currentView removeFromSuperview];
    
    [self reloadThumbnail];
    self.btnAction.hidden = NO;

}
-(void)hideCell{
    self.backgroundView.alpha=0;
    self.title.alpha = 0;
    self.duration.alpha = 0;
    self.time.alpha = 0;
    self.heart.alpha = 0;
    self.shadowDown.alpha = 0;
    self.shadowUp.alpha = 0;
}
-(void)loadingCell{
    [self hideCell];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.backgroundView.superview.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.contentView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}
-(UITableView*)GetTableView{
    BOOL stop=NO;
    UIView *currentLevel;
    currentLevel=self;
    while (!stop) {
        if ([currentLevel.superview isKindOfClass:[UITableView class]]) {
            stop=YES;
            currentLevel = [currentLevel superview];
        }
        else{
            currentLevel = [currentLevel superview];
        }
    }
    return (UITableView*)currentLevel;
}
-(void)showCell{
    [activityIndicator stopAnimating];
    [UIView animateWithDuration:0.7 animations:^{
        self.backgroundView.alpha=1;
        self.title.alpha = 1;
        self.duration.alpha = 1;
        self.time.alpha = 1;
        self.heart.alpha = 1;
        self.shadowDown.alpha = 1;
        self.shadowUp.alpha = 1;
    } completion:^(BOOL finished) {
    }];
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
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; {
    if (webView == self.backgroundView) {
        [self loadingCell];
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (reloadThumbnail) {
        reloadThumbnail=NO;
    }
    if (webView == self.backgroundView) {
        [self showCell];
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (webView == self.backgroundView) {
        [self showCell];
    }
}
- (void)stopLoading
{

}

@end
