//
//  WebViewController.h
//  youtube
//
//  Created by Jonathan Martin on 14/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBActivityIndicator.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIWebView *webV;
    IBOutlet UIView *navigationBar;
    CBActivityIndicator *loading;
    NSUserDefaults *userDefault;
    UIImageView *loadingView;
}
@property (nonatomic,retain) NSString *titleV;
@property (nonatomic,retain) NSString *url;
-(IBAction)Back:(id)sender;
-(IBAction)OpenInSafari:(id)sender;
@end
