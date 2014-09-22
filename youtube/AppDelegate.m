//
//  AppDelegate.m
//  youtube
//
//  Created by Martin Jonathan on 04/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "FavoriteViewController.h"
#import "SocialViewController.h"
#import "SelectChannelViewController.h"
#import "dataModel.h"

@implementation AppDelegate
@synthesize tab;
@synthesize menu;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Set Queries
    [dataModel setValues];
    //dataModel *model = [dataModel sharedManager];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tab = [[UITabBarController alloc]init];
    NewsViewController *nvc;
    FavoriteViewController *fav;
    SocialViewController *social;
    SelectChannelViewController *scvc;
    if ([[Tools currentIphone]isEqualToString:kIPHONE4]) {
        nvc = [[NewsViewController alloc]initWithNibName:@"NewsViewController" bundle:nil];
        fav = [[FavoriteViewController alloc]initWithNibName:@"FavoriteViewController" bundle:nil];
        social = [[SocialViewController alloc]initWithNibName:@"SocialViewController" bundle:nil];
        scvc = [[SelectChannelViewController alloc]initWithNibName:@"SelectChannelViewController" bundle:nil];
        ncvc = [[NoConnectionViewController alloc]initWithNibName:@"NoConnectionViewController" bundle:nil];
        menu = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    }else if([[Tools currentIphone]isEqualToString:kIPHONE5]){
        nvc = [[NewsViewController alloc]initWithNibName:@"NewsViewControlleri5" bundle:nil];
        fav = [[FavoriteViewController alloc]initWithNibName:@"FavoriteViewControlleri5" bundle:nil];
        social = [[SocialViewController alloc]initWithNibName:@"SocialViewControlleri5" bundle:nil];
        scvc = [[SelectChannelViewController alloc]initWithNibName:@"SelectChannelViewControlleri5" bundle:nil];
        ncvc = [[NoConnectionViewController alloc]initWithNibName:@"NoConnectionViewControlleri5" bundle:nil];
        menu = [[MenuViewController alloc]initWithNibName:@"MenuViewControlleri5" bundle:nil];
    }
    
    UINavigationController *navC=  [[UINavigationController alloc]initWithRootViewController:nvc];
    navC.navigationBarHidden=YES;
    UINavigationController *navC2=  [[UINavigationController alloc]initWithRootViewController:fav];
    navC2.navigationBarHidden=YES;
    UINavigationController *navC3=  [[UINavigationController alloc]initWithRootViewController:social];
    navC3.navigationBarHidden=YES;
    UINavigationController *navC4=  [[UINavigationController alloc]initWithRootViewController:scvc];
    navC4.navigationBarHidden=YES;
    navC.navigationBarHidden=YES;
    menu.view.frame = [menu getFrameInit];
    [tab setViewControllers:@[navC,navC2,navC3,navC4]];
    self.window.rootViewController = tab;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self HideTabBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}
- (void)reachabilityDidChange:(NSNotification *)notification {
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus==NotReachable) {
        [self showNoConnection];
    }else{
        if (tab.selectedIndex==0) {
            UINavigationController *nc = (UINavigationController *)tab.selectedViewController;
            NewsViewController *nvc = nc.viewControllers[0];
            if (![nvc isInitialize]) {
                [nvc initializeBasicInformation];
            }
        }
        [self hideNoConnection];
    }
}
-(void)showNoConnection{
    if ([menu isOpen]) {
        [menu closeMenu];
    }
    [self performSelector:@selector(addNoConnectionSubview) withObject:nil afterDelay:0.5];
}
-(void)hideNoConnection{
    [ncvc.view removeFromSuperview];
}
-(void)addNoConnectionSubview{
    UINavigationController *nc = (UINavigationController *)tab.selectedViewController;
    UIViewController *vc = nc.viewControllers[0];
    [vc.view addSubview:ncvc.view];
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
    if (window && [className isEqualToString:@"MPInlineVideoFullscreenViewController"]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
-(void)HideTabBar{
    for(UIView *view in tab.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 768, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 768)];
            
        }
    }
}
@end
