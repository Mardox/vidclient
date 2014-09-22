//
//  SocialViewController.h
//  youtube
//
//  Created by Jonathan Martin on 18/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SocialViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    
    MenuViewController *menu;
    IBOutlet UIView *navigationBar;
    IBOutlet UIButton *sendButton;
    IBOutlet UILabel *theTitle;
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    IBOutlet UIView *view4;
    IBOutlet UIView *view5;
    IBOutlet UIView *view6;
    IBOutlet UIView *view7;
    IBOutlet UIView *view8;
    IBOutlet UIView *view9;
    IBOutlet UIView *view10;
    IBOutlet UIView *view11;
    IBOutlet UIView *view12;
    IBOutlet UIView *view13;
    IBOutlet UIView *view14;
    IBOutlet UIView *view15;
    
    int mode;
    
    BOOL twitter;
    BOOL facebook;
    BOOL linkedin;
    BOOL tumblr;
    BOOL soundcloud;
    BOOL pinterest;
    BOOL flickr;
    BOOL apple;
    BOOL instagram;
    BOOL wordpress;
    BOOL android;
    BOOL deviantart;
    BOOL blogger;
    BOOL subscribers;
    BOOL views;
    BOOL videocount;
    BOOL spreadshirt;
    
    int flag;
    
    NSMutableArray *customs;
    NSMutableDictionary *links;
    
    BOOL shouldRefresh;
    BOOL shouldRefresh2;
}
- (IBAction)menuPressed:(id)sender;
- (IBAction)sendPressed:(id)sender;

@end
