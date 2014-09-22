//
//  NoConnectionViewController.m
//  youtube
//
//  Created by Jonathan Martin on 28/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "NoConnectionViewController.h"

@interface NoConnectionViewController ()

@end

@implementation NoConnectionViewController

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
    firstLabel.text = NSLocalizedString(@"NO INTERNET CONNECTION",nil);
    firstLabel.adjustsFontSizeToFitWidth = YES;
    firstLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    [firstLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    secondLabel.text = NSLocalizedString(@"Please check your internet connection or try again later",nil);
    secondLabel.adjustsFontSizeToFitWidth = YES;
    secondLabel.textColor = [Tools colorWithHexString:color_grey_nofavorite];
    [secondLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
