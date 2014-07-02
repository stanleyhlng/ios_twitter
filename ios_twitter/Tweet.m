//
//  Tweet.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/1/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"createdAt": @"created_at",
             @"favoriteCount": @"favorite_count",
             @"favorited": @"favorited",
             @"id": @"id",
             @"retweetCount": @"retweet_count",
             @"retweeted": @"retweeted",
             @"text": @"text"
             };
}

+ (NSArray *)fromJson:(id)response
{
    NSMutableArray *tweets = [[NSMutableArray alloc] init];

    for (NSDictionary *item in response) {
        Tweet *tweet = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:item error:nil];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

@end
