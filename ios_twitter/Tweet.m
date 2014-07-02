//
//  Tweet.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/1/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

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
             @"text": @"text",
             @"user": @"user"
             };
}

+ (NSValueTransformer *)userJSONTransformer
{
    NSLog(@"[DEBUG] userJSONTransformer");
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSDictionary *data) {
        NSLog(@"[DEBUG] userJSONTransformer: forward block");
        return [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:data error:nil];
    } reverseBlock:^id(User *user) {
        NSLog(@"[DEBUG] userJSONTransformer: reverse block");
        NSDictionary *userDict = [MTLJSONAdapter JSONDictionaryFromModel:user];
        NSLog(@"[DEBUG] %@", userDict);
        NSData *data = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:nil];
        NSLog(@"[DEBUG] %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        return userDict;
    }];
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
