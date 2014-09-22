//
//  AppDelegate.h
//  youtube
//
//  Created by Martin Jonathan on 04/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "Reachability.h"
#import "NoConnectionViewController.h"
#import "Config.h"

@class MenuViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UITabBarController *tab;
    Reachability *reachability;
    NoConnectionViewController *ncvc;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tab;
@property (strong, nonatomic) MenuViewController *menu;

-(void)showNoConnection;

@end
