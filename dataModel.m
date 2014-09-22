//
//  dataModel.m
//  ColtBoyTube
//
//  Created by Shubhank Gaur on 15/05/14.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel
@synthesize ytQueries;
@synthesize currentQuery;
@synthesize currentTitle;
@synthesize int_ads_upper_probab;

+ (id)sharedManager {
    static dataModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (void)setValues {
    dataModel *model = [dataModel sharedManager];
    model.ytQueries = [[NSMutableDictionary alloc] init];
    //Key must be category name you want to display
    //Object must be the query to search in youtube
    [model.ytQueries setObject:@"Karate Lessons" forKey:@"Lessons"];
    [model.ytQueries setObject:@"Karate Kihon" forKey:@"Kihon"];
    [model.ytQueries setObject:@"Karate Kata" forKey:@"Kata"];
    [model.ytQueries setObject:@"Karate Championships" forKey:@"Championships"];
    
    NSArray *keys = [model.ytQueries allKeys];
    NSArray *queries = [model.ytQueries allValues];
    model.currentQuery = [queries objectAtIndex:0];
    model.currentTitle = [keys objectAtIndex:0];
    
    model.int_ads_upper_probab = 2;

}

@end
