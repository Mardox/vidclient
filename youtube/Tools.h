//
//  Tools.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
@interface Tools : NSObject
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (BOOL)isNetWorkConnectionAvailable;
+ (NSString *)flattenHTML:(NSString *)html;
+ (BOOL)isiPhone5;
+ (NSString *) md5WithString:(NSString *)string;
+ (void)DisplayNetworkAlert;
+(NSString *)FindStrInWebView:(UIWebView *)webView andStartSeparator:(NSString *)start andEndSeparator:(NSString *)end;
+ (NSString *)stringColorFromConfig:(NSString *)key;
+ (NSString *)currentIphone;
@end
