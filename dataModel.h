//
//  dataModel.h
//  ColtBoyTube
//
//  Created by Shubhank Gaur on 15/05/14.
//  Copyright (c) 2014 ColtBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject

//Set the values for the dict/array in setValues method in .m
@property (strong,nonatomic) NSMutableDictionary *ytQueries;
@property (strong,nonatomic) NSString *currentQuery;
@property (strong,nonatomic) NSString *currentTitle;
@property (nonatomic) int int_ads_upper_probab;

+ (id) sharedManager;
+ (void) setValues;

@end
