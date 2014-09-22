//
//  WebViewController.m
//  youtube
//
//  Created by Jonathan Martin on 14/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "WebViewController.h"
#import "Tools.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    [self updateThemeColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateThemeColor)
                                                 name:kNOTIFICATIONCOLORCHANGED
                                               object:nil];
    webV.delegate = self;
    
    loading = [[CBActivityIndicator alloc]initWithFrame:CGRectMake(webV.frame.size.width/4, webV.frame.size.height/2, webV.frame.size.width/2,webV.frame.size.height/10)];
    loading.center = webV.center;
    [self.view addSubview:loading];
    loading.activityColor = [UIColor whiteColor];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    userDefault = [NSUserDefaults standardUserDefaults];
    lblTitle.text = self.titleV;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.adjustsFontSizeToFitWidth = YES;
    [lblTitle setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)updateThemeColor{
    navigationBar.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
}
#pragma mark User Interactions
-(IBAction)Back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)OpenInSafari:(id)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:webV.request.URL.absoluteString]];
}

#pragma mark UIWebView delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [loading stopAnimating];
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
    if (self.titleV.length==0) {
        lblTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loading startAnimating];
    if (loadingView==nil) {
        loadingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, webV.frame.size.width, webV.frame.size.height)];
        loadingView.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
    }
    if (loadingView.superview==nil) {
        [webV addSubview:loadingView];
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [loading stopAnimating];
    [UIView animateWithDuration:0.7 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
    if (self.titleV.length==0) {
        lblTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }}

@end
