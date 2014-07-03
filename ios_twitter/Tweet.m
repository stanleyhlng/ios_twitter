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
             @"retweetedStatus": @"retweeted_status",
             @"text": @"text",
             @"user": @"user"
             };
}

+ (NSValueTransformer *)retweetedStatusJSONTransformer;
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSDictionary *data) {
        return [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:data error:nil];
    } reverseBlock:^id(Tweet *tweet) {
        return [MTLJSONAdapter JSONDictionaryFromModel:tweet];
    }];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSDictionary *data) {
        return [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:data error:nil];
    } reverseBlock:^id(User *user) {
        return [MTLJSONAdapter JSONDictionaryFromModel:user];
    }];
}

+ (Tweet *)parseTweet:(id)response
{
    return [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:response error:nil];
}

+ (NSArray *)parseTweets:(id)response
{
    NSMutableArray *tweets = [[NSMutableArray alloc] init];

    for (NSDictionary *item in response) {
        Tweet *tweet = [Tweet parseTweet:item];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

@end
