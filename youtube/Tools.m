//
//  Tools.m
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "Tools.h"
#import "Constants.h"

@implementation Tools
+ (BOOL)isiPhone5;{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (UIColor *) colorWithHexString: (NSString *) hexString{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}
+ (BOOL)validateHexColor:(NSString *)colorStr {
    NSString *colorRegex = @"^#(?:[0-9a-fA-F]{3}){1,2}$";
    NSPredicate *colorTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", colorRegex];
    return [colorTest evaluateWithObject:colorStr];
}
+ (NSString *)stringColorFromConfig:(NSString *)key{
    if ([key isEqualToString:@"color_black_google"]) {
        return color_black_google;
    }else if ([key isEqualToString:@"color_blue_facebook"]) {
        return color_blue_facebook;
    }else if ([key isEqualToString:@"color_blue_twitter"]) {
        return color_blue_twitter;
    }else if ([key isEqualToString:@"color_blue_linkedin"]) {
        return color_blue_linkedin;
    }else if ([key isEqualToString:@"color_blue_tumblr"]) {
        return color_blue_tumblr;
    }else if ([key isEqualToString:@"color_blue_soundcloud"]) {
        return color_blue_soundcloud;
    }else if ([key isEqualToString:@"color_red_youtube"]) {
        return color_red_youtube;
    }else if ([key isEqualToString:@"color_red_pinterest"]) {
        return color_red_pinterest;
    }else if ([key isEqualToString:@"color_purple_flickr"]) {
        return color_purple_flickr;
    }else if ([key isEqualToString:@"color_grey_instagram"]) {
        return color_grey_instagram;
    }else if ([key isEqualToString:@"color_grey_wordpress"]) {
        return color_grey_wordpress;
    }else if ([key isEqualToString:@"color_grey_instagram"]) {
        return color_grey_instagram;
    }else if ([key isEqualToString:@"color_green_android"]) {
        return color_green_android;
    }else if ([key isEqualToString:@"color_grey_apple"]) {
        return color_grey_apple;
    }else if ([key isEqualToString:@"color_green_deviantart"]) {
        return color_green_deviantart;
    }else if ([key isEqualToString:@"color_yellow_blogger"]) {
        return color_yellow_blogger;
    }else if ([self validateHexColor:key]){
        return key;
    }else{
        [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", key];
        return nil;
    }
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
+ (BOOL)isNetWorkConnectionAvailable{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (NSString *)flattenHTML:(NSString *)html {
	
	NSScanner *thescanner;
	
	NSString *text = nil;
	
	thescanner = [NSScanner scannerWithString:html];
	
	while ([thescanner isAtEnd] == NO) {
		
		// find start of tag
		
		[thescanner scanUpToString:@"<" intoString:nil];
		
		// find end of tag
		
		[thescanner scanUpToString:@">" intoString:&text];
		
		// replace the found tag with a space
		
		//(you can filter multi-spaces out later if you wish)
		
		html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
		
	}
	
	html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"];
	html = [html stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
	html = [html stringByReplacingOccurrencesOfString:@"&bull;" withString:@" * "];
	html = [html stringByReplacingOccurrencesOfString:@"&lsaquo;" withString:@"<"];
	html = [html stringByReplacingOccurrencesOfString:@"&rsaquo;" withString:@">"];
	html = [html stringByReplacingOccurrencesOfString:@"&trade;" withString:@"(tm)"];
	html = [html stringByReplacingOccurrencesOfString:@"&frasl;" withString:@"/"];
	html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
	html = [html stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
	html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
	html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
	html = [html stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
	html = [html stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
    html = [html stringByReplacingOccurrencesOfString:@"&#160;" withString:@"  "];
    html = [html stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"’"];
    html = [html stringByReplacingOccurrencesOfString:@"\\U2019" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSString *newStr = @"";
    BOOL firstMarker, secondMarker;
    firstMarker=secondMarker=NO;
    
    for (int i=0; i<html.length; i++) {
        NSString *charS = [html substringWithRange:NSMakeRange(i, 1)];
        if (firstMarker) {
            if ([charS isEqualToString:@"#"]) {
                firstMarker=NO;
                secondMarker=YES;
            }
            else
            {
                firstMarker=NO;
                newStr = [NSString stringWithFormat:@"%@%@%@",newStr,@"&",charS];
            }
        }
        else if (secondMarker){
            if ([charS isEqualToString:@";"]) {
                secondMarker=NO;
            }
        }
        else
        {
            if ([charS isEqualToString:@"&"]) {
                firstMarker=YES;
            }
            else
            {
                newStr = [newStr stringByAppendingString:charS];
            }
        }
    }
    html=newStr;
	return [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
+ (NSString *) md5WithString:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+ (void)DisplayNetworkAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"It appears there is no avalaible network connection. Try to find a WiFi point or look at your device settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
+(NSString *)FindStrInWebView:(UIWebView *)webView andStartSeparator:(NSString *)start andEndSeparator:(NSString *)end{
    NSString *result = @"";
    NSString *HTMLSourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    result = [[[[HTMLSourceCodeString componentsSeparatedByString:start]lastObject]componentsSeparatedByString:end]objectAtIndex:0];
    return result;
}
+(NSString *)currentIphone{
    if ([[UIScreen mainScreen]bounds].size.height>481) {
        return kIPHONE5;
    }
    else{
        return kIPHONE4;
    }
}
@end
