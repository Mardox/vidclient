//
//  MenuViewController.m
//  youtube
//
//  Created by Jonathan Martin on 18/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "MenuViewController.h"
#import "Tools.h"
#import "Constants.h"
#import "APIs.h"
#import "NewsViewController.h"
#define animationDuration 0.5
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize isOpen;
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
    userDefault = [NSUserDefaults standardUserDefaults];
    self.isOpen=NO;
    [self loadUsername];
    [videoButton setTitle:NSLocalizedString(@"Videos",nil) forState:UIControlStateNormal];
    [videoButton setTitleColor:[Tools colorWithHexString:color_black_google] forState:UIControlStateNormal] ;
    [videoButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    [favoriteButton setTitle:NSLocalizedString(@"Favorites",nil) forState:UIControlStateNormal];
    [favoriteButton setTitleColor:[Tools colorWithHexString:color_black_google] forState:UIControlStateNormal] ;
    [favoriteButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    [socialButton setTitle:NSLocalizedString(@"Social",nil) forState:UIControlStateNormal];
    [socialButton setTitleColor:[Tools colorWithHexString:color_black_google] forState:UIControlStateNormal] ;
    [socialButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    [selectChannelButton setTitle:NSLocalizedString(@"Select a channel",nil) forState:UIControlStateNormal];
    [selectChannelButton setTitleColor:[Tools colorWithHexString:color_black_google] forState:UIControlStateNormal] ;
    [selectChannelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    photoView.layer.cornerRadius = photoView.frame.size.width/2;
    photoView.clipsToBounds=YES;
    photoView.layer.masksToBounds=YES;
    
    [blurView initBlur];
    [blurView setColorForBlur:[UIColor clearColor]];
    [blurView setAlphaForBlur:0];
    
    dismissButton = [[UIButton alloc]initWithFrame:CGRectMake(blurView.frame.size.width, 0, 320-blurView.frame.size.width, self.view.frame.size.height)];
    [dismissButton addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    NSString *path = [userDefault objectForKey:kIMAGEPATH];
    if (path) {
      //  UIImage *customImage = [UIImage imageWithContentsOfFile:path];
        //photoImageView.image = customImage;
    }
    channelLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([[config_id componentsSeparatedByString:@","]count]<=1) {
        selectChannelButton.hidden = YES;
        selectChannelView.hidden = YES;
    };
    
    //QueryPicker
    queryPicker.delegate = self;

}
-(void)viewWillAppear:(BOOL)animated{
    [self loadThumbnail:[[NSUserDefaults standardUserDefaults] objectForKey:kTHUMBNAIL]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)ChangeTab:(int)index{
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    if ([deleg.tab selectedIndex]==index) {
        [self closeMenu];
    }else{
        [deleg.tab setSelectedIndex:index];
    }
}
- (IBAction)videoPressed:(id)sender {
    [self ChangeTab:0];
}

- (IBAction)favoritePressed:(id)sender {
    [self ChangeTab:1];
}

- (IBAction)socialPressed:(id)sender {
    [self ChangeTab:2];
}
- (IBAction)selectChannelPressed:(id)sender{
    [self ChangeTab:3];

}
- (void)openMenu{
    if (!self.isOpen) {
        self.isOpen=YES;
        [self.delegate MenuViewControllerBeginOpening];
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)closeMenu{
    if (self.isOpen) {
        self.isOpen=NO;
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.frame = CGRectMake(-320, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            [self.delegate MenuViewControllerEndClosing];
        }];
    }
}
- (CGRect)getFrameInit{
    return CGRectMake(-320, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)loadThumbnail:(NSString*)thumb{
  //  NSURL *url = [NSURL URLWithString:thumb];
  //  NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    [userDefault setObject:imagePath forKey:kIMAGEPATH];
   // UIImage *img = [[UIImage alloc]initWithData:data];
    //photoImageView.image = img;
}
-(void)loadUsername{
    //channelLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:kPSEUDO];
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
    channelLabel.text = prodName;
    channelLabel.textColor = [Tools colorWithHexString:color_black_google];
    [channelLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    dataModel *model = [dataModel sharedManager];
    return [model.ytQueries count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   dataModel *model = [dataModel sharedManager];
    NSArray *queries = [model.ytQueries allValues];
    NSArray *keys = [model.ytQueries allKeys];
    
    model.currentQuery = [queries objectAtIndex:row];
    model.currentTitle = [keys objectAtIndex:row];
    NSLog(@"%@",[queries objectAtIndex:row]);
    [self ChangeTab:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadVC" object:nil];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    dataModel *model = [dataModel sharedManager];
    NSArray *queries = [model.ytQueries allKeys];
    return [queries objectAtIndex:row];
}

@end
