//
//  User.h
//  ios_twitter
//
//  Created by Stanley Ng on 7/2/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <Mantle.h>

@interface User : MTLModel<MTLJSONSerializing>

// User Object Documentation
// https://dev.twitter.com/docs/platform-objects/users

@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *friendsCount;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *profileBackgroundImageUrl;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSNumber *statusesCount;
@property (nonatomic, strong) NSString *tagLine;

+ (NSValueTransformer *)profileBackgroundImageUrlJSONTransformer;
+ (NSValueTransformer *)profileImageUrlJSONTransformer;
+ (User *)parseUser:(id)response;

@end
