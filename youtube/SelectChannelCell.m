//
//  SelectChannelCell.m
//  youtube_demo
//
//  Created by Jonathan Martin on 29/01/2014.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "SelectChannelCell.h"

@implementation SelectChannelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)reloadThumbnail{
    if (self.thumbnail.delegate==nil) {
        self.thumbnail.delegate=self;
    }
    reloadThumbnail = YES;
    [self.thumbnail loadHTMLString:[NSString stringWithFormat:@" <html><head>\
                                         <style type=\"text/css\">\
                                         body {\
                                         background-color: black;\
                                         color: black;\
                                         margin: 0;\
                                         margin-top:;\
                                         }\
                                         </style>\
                                         </head><body> \
                                         <img src=\"%@\" width=\"%f\">\
                                         </body></html>",self.thumbnailLink,self.thumbnail.frame.size.width] baseURL:[[NSBundle mainBundle] resourceURL]];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.thumbnail.hidden = NO;
}
@end
