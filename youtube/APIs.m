//
//  APIs.m
//  Pay4Later_API
//
//  Created by Martin Jonathan on 29/10/2013.
//  Copyright (c) 2013 ColtBoy. All rights reserved.
//

#import "APIs.h"
#import "Constants.h"
#import "dataModel.h"
#import "Config.h"

#define kLoadVideosRequest 0
#define kSearchVideosRequest 1
#define kLoadBasicInfoRequest 2
#define kLoadChannelInfoRequest 3

@implementation APIs

@synthesize delegate;

#pragma mark Public APIs v.Edge

-(void)LoadYoutubeVideosFromStartIndex:(int)startIndex withMaxResults:(int)maxResults{
//    NSString *userChannel = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERID];
//    NSString *mainURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/users/%@/uploads?v=2&orderby=published&start-index=%i&max-results=%i&alt=jsonc",userChannel,startIndex,maxResults];
//    NSURL *url = [NSURL URLWithString:mainURL];
//    request = [ASIFormDataRequest requestWithURL:url];
//    [request  setRequestMethod:@"GET"];
//    request.allowCompressedResponse = NO;
//    request.useCookiePersistence = NO;
//    request.shouldCompressRequestBody = NO;
//    [request setDelegate:self];
//    [request setTag:kLoadVideosRequest];
//    
//    if ([Tools isNetWorkConnectionAvailable]){
//        [request startAsynchronous];
//    }else{
//        [self.delegate YoutubeApisDelegateApisDidReturnNetworkError:[[NSError alloc]init] forRequest:[request description]];
//    }
    
    dataModel *model = [dataModel sharedManager];
    //NSArray *queries = [model.ytQueries allValues];
    
    NSLog(@"yt vid load method");
    [self SearchYoutubeVideosFromStartIndex:1 withMaxResults:yt_max_vids_show andQuery:model.currentQuery];

}
-(void)SearchYoutubeVideosFromStartIndex:(int)startIndex withMaxResults:(int)maxResults andQuery:(NSString*)query{
    query = [self RemoveSpaceInUrl:query];
   // NSString *userChannel = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERID];
    NSString *mainURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&v=2&start-index=%i&max-results=%i&alt=jsonc",query,startIndex,maxResults];
    NSURL *url = [NSURL URLWithString:mainURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request  setRequestMethod:@"GET"];
    request.allowCompressedResponse = NO;
    request.useCookiePersistence = NO;
    request.shouldCompressRequestBody = NO;
    [request setDelegate:self];
    [request setTag:kSearchVideosRequest];
    if ([Tools isNetWorkConnectionAvailable]){
        [request startAsynchronous];
    }else{
        [self.delegate YoutubeApisDelegateApisDidReturnNetworkError:[[NSError alloc]init] forRequest:[request description]];
    }

}
-(void)LoadBasicInformation{
    NSString *userChannel = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERID];
    NSString *mainURL = [NSString stringWithFormat:@"https://gdata.youtube.com/feeds/api/users/%@",userChannel];
    NSURL *url = [NSURL URLWithString:mainURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request  setRequestMethod:@"GET"];
    request.allowCompressedResponse = NO;
    request.useCookiePersistence = NO;
    request.shouldCompressRequestBody = NO;
    [request setDelegate:self];
    [request setTag:kLoadBasicInfoRequest];
    
    if ([Tools isNetWorkConnectionAvailable]){
        [request startAsynchronous];
    }else{
        [self.delegate YoutubeApisDelegateApisDidReturnNetworkError:[[NSError alloc]init] forRequest:[request description]];
    }
}
-(void)LoadChannelInformationForUseriD:(NSString*)userId{
    NSString *mainURL = [NSString stringWithFormat:@"https://gdata.youtube.com/feeds/api/users/%@",userId];
    NSURL *url = [NSURL URLWithString:mainURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request  setRequestMethod:@"GET"];
    request.allowCompressedResponse = NO;
    request.useCookiePersistence = NO;
    request.shouldCompressRequestBody = NO;
    [request setDelegate:self];
    [request setTag:kLoadChannelInfoRequest];
    
    if ([Tools isNetWorkConnectionAvailable]){
        [request startAsynchronous];
    }else{
        [self.delegate YoutubeApisDelegateApisDidReturnNetworkError:[[NSError alloc]init] forRequest:[request description]];
    }
}
- (void)requestFinished:(ASIHTTPRequest *)requestR {
    if([requestR tag] == kLoadVideosRequest){
        [self.delegate performSelector:@selector(YoutubeApisDidLoadYoutubeVideos:) withObject:[self parseJSONResponse:[[NSString alloc] initWithData:[requestR responseData] encoding:NSUTF8StringEncoding]]];
    }else if ([requestR tag] == kSearchVideosRequest){
    [self.delegate performSelector:@selector(YoutubeApisDidSearchYoutubeVideos:) withObject:[self parseJSONResponse:[[NSString alloc] initWithData:[requestR responseData] encoding:NSUTF8StringEncoding]]];
    }else if ([requestR tag] == kLoadChannelInfoRequest){
        [self.delegate performSelector:@selector(YoutubeApisDidLoadChannelInformation:) withObject:[XMLReader dictionaryForXMLString:[requestR responseString] error:nil]];
    }else if ([requestR tag] == kLoadBasicInfoRequest){
        NSDictionary *dict=[[NSDictionary alloc]initWithDictionary:[XMLReader dictionaryForXMLString:[requestR responseString] error:nil]];
        NSDictionary *entryDict=[dict objectForKey:@"entry"];
        NSMutableDictionary *ma = [[NSMutableDictionary alloc]init];
        if ([[entryDict objectForKey:@"content"]objectForKey:@"text"]) {
            [ma setObject:[[entryDict objectForKey:@"content"]objectForKey:@"text"] forKey:@"about"];
        }else{
            [ma setObject:@"" forKey:@"about"];
        }
        if ([[entryDict objectForKey:@"author"]objectForKey:@"name"]) {
            [ma setObject:[[[entryDict objectForKey:@"author"]objectForKey:@"name"] objectForKey:@"text"] forKey:@"pseudo"];
        }else{
            [ma setObject:@"" forKey:@"pseudo"];
        }
        if ([[entryDict objectForKey:@"yt:username"]objectForKey:@"text"]) {
            [ma setObject:[[entryDict objectForKey:@"yt:username"]objectForKey:@"text"] forKey:@"name"];
        }else{
            [ma setObject:@"" forKey:@"name"];
        }
        if ([[entryDict objectForKey:@"yt:statistics"]objectForKey:@"subscriberCount"]) {
            int integer = [[[entryDict objectForKey:@"yt:statistics"]objectForKey:@"subscriberCount"]intValue];
            NSNumber *subscriberCount = [NSNumber numberWithInt:integer];
            NSString *numberStr = [NSNumberFormatter localizedStringFromNumber:subscriberCount numberStyle:NSNumberFormatterDecimalStyle];
            [ma setObject:numberStr forKey:@"subscriberCount"];
        }else{
            [ma setObject:@"" forKey:@"subscriberCount"];
        }
        
        if ([[entryDict objectForKey:@"yt:statistics"]objectForKey:@"totalUploadViews"]) {
            int integer = [[[entryDict objectForKey:@"yt:statistics"]objectForKey:@"totalUploadViews"]intValue];
            NSNumber *totalUploadViews = [NSNumber numberWithInt:integer];
            NSString *numberStr = [NSNumberFormatter localizedStringFromNumber:totalUploadViews numberStyle:NSNumberFormatterDecimalStyle];
            [ma setObject:numberStr forKey:@"totalUploadViews"];
        }else{
            [ma setObject:@"" forKey:@"totalUploadViews"];
        }
        
        if ([[entryDict objectForKey:@"yt:googlePlusUserId"]objectForKey:@"text"]) {
            [ma setObject:[[entryDict objectForKey:@"yt:googlePlusUserId"]objectForKey:@"text"] forKey:@"googleplusid"];
        }else{
            [ma setObject:@"" forKey:@"text"];
        }
        
        if ([[[entryDict objectForKey:@"gd:feedLink"]objectAtIndex:4]objectForKey:@"countHint"]) {
            int integer = [[[[entryDict objectForKey:@"gd:feedLink"]objectAtIndex:4]objectForKey:@"countHint"]intValue];
            NSNumber *countHint = [NSNumber numberWithInt:integer];
            NSString *numberStr = [NSNumberFormatter localizedStringFromNumber:countHint numberStyle:NSNumberFormatterDecimalStyle];
            [ma setObject:numberStr forKey:@"videocount"];
        }else{
            [ma setObject:@"" forKey:@"countHint"];
        }
        
        NSString *thumb =[[entryDict objectForKey:@"media:thumbnail"]objectForKey:@"url"];
        thumb = [thumb stringByReplacingOccurrencesOfString:@"/s88-c-k-no/" withString:@"/s240-c-k-no/"];
        [ma setObject:thumb forKey:@"thumbnail"];
        [self.delegate performSelector:@selector(YoutubeApisDidLoadBasicInformation:) withObject:[[NSDictionary alloc]initWithDictionary:ma]];
    }
}
-(NSDictionary *)parseJSONResponse:(NSString *)response{
    if ([response rangeOfString:@"Array"].location!=NSNotFound) {
        NSArray *str = [response componentsSeparatedByString:@")"];
        response=@"";
        for (int i=1; i<str.count; i++) {
            response = [response stringByAppendingString:[str objectAtIndex:i]];
        }
    }
    
    return [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}
-(NSString *)RemoveSpaceInUrl:(NSString *)url{
    return [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

@end
