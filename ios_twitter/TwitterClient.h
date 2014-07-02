//
//  TwitterClient.h
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

// GET statuses/home_timeline
// https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void(^)(AFHTTPRequestOperation *operation, id response))success
                                            failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// POST oauth/request_token
// https://dev.twitter.com/docs/api/1/post/oauth/request_token
- (void)requestTokenWithSuccess:(void(^)(BDBOAuthToken *requestToken))success
                        failure:(void(^)(NSError *error))failure;

// POST oauth/access_token
// https://dev.twitter.com/docs/api/1/post/oauth/access_token
- (void)accessTokenWithURL:(NSURL *)url
                   success:(void(^)(BDBOAuthToken *accessToken))success
                   failure:(void(^)(NSError *error))failure;

- (void)connectWithSuccess:(void(^)())success
                   failure:(void(^)(NSError *error))failure;

- (void)authorizeWithURL:(NSURL *)url
                 success:(void(^)())success
                 failure:(void(^)(NSError *error))failure;


- (void)removeAccessToken;

- (BOOL)isAuthenticated;

@end
