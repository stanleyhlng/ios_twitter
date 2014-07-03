//
//  TwitterClient.h
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@class Tweet;
@class User;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

// ==================================================
// TIMELINES

// GET statuses/home_timeline
// https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
- (AFHTTPRequestOperation *)homeTimelineWithParams:(NSDictionary *)params
                                           success:(void(^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                            failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// POST statuses/update
// https://dev.twitter.com/docs/api/1.1/post/statuses/update
- (AFHTTPRequestOperation *)updateWithParams:(NSDictionary *)params
                                           success:(void(^)(AFHTTPRequestOperation *operation, Tweet *tweet))success
                                           failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// ==================================================
// TWEETS


// ==================================================
// FAVORITES

// POST favorites/create
// https://dev.twitter.com/docs/api/1.1/post/favorites/create
- (AFHTTPRequestOperation *)createFavoriteWithParams:(NSDictionary *)params
                                     success:(void(^)(AFHTTPRequestOperation *operation, Tweet *tweet))success
                                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// POST favorites/destroy
// https://dev.twitter.com/docs/api/1.1/post/favorites/destroy
- (AFHTTPRequestOperation *)destroyFavoriteWithParams:(NSDictionary *)params
                                             success:(void(^)(AFHTTPRequestOperation *operation, Tweet *tweet))success
                                             failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// ==================================================
// USERS

// GET account/verify_credentials
// https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials
- (AFHTTPRequestOperation *)verifyCredentialsWithParams:(NSDictionary *)params
                                           success:(void(^)(AFHTTPRequestOperation *operation, User *user))success
                                           failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// ==================================================
// OAUTH

// POST oauth/request_token
// https://dev.twitter.com/docs/api/1/post/oauth/request_token
- (void)requestTokenWithSuccess:(void(^)(BDBOAuthToken *requestToken))success
                        failure:(void(^)(NSError *error))failure;

// POST oauth/access_token
// https://dev.twitter.com/docs/api/1/post/oauth/access_token
- (void)accessTokenWithURL:(NSURL *)url
                   success:(void(^)(BDBOAuthToken *accessToken))success
                   failure:(void(^)(NSError *error))failure;


// ==================================================
// HELPERS

- (void)connectWithSuccess:(void(^)())success
                   failure:(void(^)(NSError *error))failure;

- (void)authorizeWithURL:(NSURL *)url
                 success:(void(^)())success
                 failure:(void(^)(NSError *error))failure;

- (void)removeAccessToken;

- (BOOL)isAuthenticated;

@end
