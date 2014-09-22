//
//  APIs.h
//  Pay4Later_API
//
//  Created by Martin Jonathan on 29/10/2013.
//  Copyright (c) 2013 ColtBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tools.h"
#import "ASIFormDataRequest.h"
#import "XMLReader.h"

@protocol YoutubeApisDelegate <NSObject,ASIHTTPRequestDelegate>
@required
#pragma mark Apis Errors
-(void)YoutubeApisDelegateApisDidReturnNetworkError:(NSError *)error forRequest:(NSString *)request;

@optional
#pragma mark Public APIs v.Edge
-(void)YoutubeApisDidLoadYoutubeVideos:(NSDictionary *)results;
-(void)YoutubeApisDidSearchYoutubeVideos:(NSDictionary *)results;
-(void)YoutubeApisDidLoadBasicInformation:(NSDictionary *)results;
-(void)YoutubeApisDidLoadChannelInformation:(NSDictionary *)results;
@end

@interface APIs : NSObject{
    ASIFormDataRequest *request;
}
@property (nonatomic,strong) id <YoutubeApisDelegate>delegate;

#pragma mark Public APIs v.Edge

-(void)LoadYoutubeVideosFromStartIndex:(int)startIndex withMaxResults:(int)maxResults;
-(void)SearchYoutubeVideosFromStartIndex:(int)startIndex withMaxResults:(int)maxResults andQuery:(NSString*)query;
-(void)LoadBasicInformation;
-(void)LoadChannelInformationForUseriD:(NSString*)userId;
@end
