//
//  SelectChannelCell.h
//  youtube_demo
//
//  Created by Jonathan Martin on 29/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectChannelCell : UITableViewCell<UIWebViewDelegate>{
    BOOL reloadThumbnail;
}
@property(nonatomic,weak) IBOutlet UILabel *title;
@property(nonatomic,weak) IBOutlet UIWebView *thumbnail;
@property(nonatomic,weak) NSString *thumbnailLink;

-(void)reloadThumbnail;

@end
