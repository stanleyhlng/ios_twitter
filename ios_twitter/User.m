//
//  User.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/2/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"followersCount": @"followers_count",
             @"friendsCount": @"friends_count",
             @"id": @"id",
             @"name": @"name",
             @"profileBackgroundImageUrl": @"profile_background_image_url",
             @"profileImageUrl": @"profile_image_url",
             @"screenName": @"screen_name",
             @"statusesCount": @"statuses_count",
             @"tagLine": @"description"
             };
}

+ (NSValueTransformer *)profileBackgroundImageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)profileImageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (User *)fromJson:(id)response
{
    return [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:response error:nil];
}

@end
