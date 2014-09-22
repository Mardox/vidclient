//
//  SelectChannelViewController.m
//  youtube_demo
//
//  Created by Jonathan Martin on 28/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "SelectChannelViewController.h"
#import "Config.h"
#import "SelectChannelCell.h"
#import "NewsViewController.h"

@interface SelectChannelViewController ()

@end

@implementation SelectChannelViewController

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
    api = [[APIs alloc]init];
    api.delegate = self;
    userDefault = [NSUserDefaults standardUserDefaults];
    youtubeData = [[NSArray alloc]init];
    theTitle.text = NSLocalizedString(@"Select a channel",nil);
    theTitle.textColor = [UIColor whiteColor];
    [theTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    theTitle.adjustsFontSizeToFitWidth = YES;
    [tableView registerNib:[UINib nibWithNibName:@"SelectChannelCell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
    navigationBar.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
    [self loadChannelInformation];
}
-(void)loadChannelInformation{
    NSArray *channels = [config_id componentsSeparatedByString:@","];
    for (NSString *channelID in channels) {
        [api LoadChannelInformationForUseriD:channelID];
    }
}
-(void)startLoadScreen{
    loading = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    loading.backgroundColor = [Tools colorWithHexString:[self getThemeColor]];
    [self.view addSubview:loading];
    activity = [[CBActivityIndicator alloc]initWithFrame:CGRectMake(loading.frame.size.width/4, loading.frame.size.height/2, loading.frame.size.width/2,loading.frame.size.height/10)];
    activity.center = loading.center;
    activity.activityColor = [UIColor whiteColor];
    [activity startAnimating];
    [loading addSubview:activity];
}
-(void)stopLoadScreen{
    [loading removeFromSuperview];
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
    [tableView reloadData];
    [self refreshMenu];
    [menu closeMenu];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
-(NSString*)getThemeColor{
    NSString *result;
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kTHEMECOLOR]){
        result = color_red_youtube;
    }else{
        result = [[NSUserDefaults standardUserDefaults]objectForKey:kTHEMECOLOR];
    }
    return result;
}
#pragma YoutubeApisDelegate
-(void)YoutubeApisDelegateApisDidReturnNetworkError:(NSError *)error forRequest:(NSString *)request{
}
-(void)YoutubeApisDidLoadChannelInformation:(NSDictionary *)results{
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithArray:youtubeData];
    [mArray addObject:[results objectForKey:@"entry"]];
    youtubeData = [[NSArray alloc]initWithArray:mArray];
    [tableView reloadData];
}
#pragma TableView delegate and datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [youtubeData count];
}
-(UITableViewCell*)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectChannelCell *cell = (SelectChannelCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.userInteractionEnabled=YES;
    NSDictionary *item = (NSDictionary *)[youtubeData objectAtIndex:indexPath.row];
    cell.thumbnail.hidden = YES;
    if (![[[[item objectForKey:@"author"]objectForKey:@"name"]objectForKey:@"text"]isEqualToString:cell.textLabel.text]) {
        cell.title.text = [[[item objectForKey:@"author"]objectForKey:@"name"]objectForKey:@"text"];
        cell.title.textColor = [Tools colorWithHexString:color_grey_nofavorite];
        [cell.title setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        cell.thumbnailLink = [[item objectForKey:@"media:thumbnail"]objectForKey:@"url"];
        [cell reloadThumbnail];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = (NSDictionary *)[youtubeData objectAtIndex:indexPath.row];
    NSString *channelID = [[[[item objectForKey:@"id"]objectForKey:@"text"]componentsSeparatedByString:@"/"]lastObject];
    [userDefault setObject:channelID forKey:kUSERID];
    AppDelegate *deleg = [[UIApplication sharedApplication]delegate];
    UINavigationController *temp = (UINavigationController*)[deleg.tab.viewControllers objectAtIndex:0];
    NewsViewController *nvc = temp.viewControllers[0];
    [nvc setContentOffSet];
    [userDefault setObject:nil forKey:kUSERNAME];
    [userDefault setObject:nil forKey:kTHUMBNAIL];
    [userDefault setObject:nil forKey:kSOCIAL];
    [userDefault setObject:nil forKey:kSOCIALLINKS];

    nvc.channelHasChanged = YES;
    menu.isOpen = YES;
    [deleg.tab setSelectedIndex:0];
    
    
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
