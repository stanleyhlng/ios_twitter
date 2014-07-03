//
//  Tweet.h
//  ios_twitter
//
//  Created by Stanley Ng on 7/1/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <Mantle.h>

@class Tweet;
@class User;

@interface Tweet : MTLModel<MTLJSONSerializing>

// Tweet Object Documentation
// https://dev.twitter.com/docs/platform-objects/tweets

@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *favorited;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *retweetCount;
@property (nonatomic, strong) NSNumber *retweeted;
@property (nonatomic, strong) Tweet *retweetedStatus;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;

+ (NSValueTransformer *)retweetedStatusJSONTransformer;
+ (NSValueTransformer *)userJSONTransformer;
+ (NSArray *)fromJson:(id)response;

@end
