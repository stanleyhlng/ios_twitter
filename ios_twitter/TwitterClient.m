//
//  TwitterClient.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TwitterClient.h"
#import "NSURL+DictionaryFromQueryString.h"
#import "Tweet.h"
#import "User.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                                                  consumerKey:@"L82BdXwfdKHIQL036NO12qwpx"
                                               consumerSecret:@"zbBxQNTLry6add284m8AecDf5VRdIpuUpuuVu0TM41tci8a0Jd"];
        }
    });
    
    return instance;
}

// GET statuses/home_timeline
// https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
- (AFHTTPRequestOperation *)homeTimelineWithParams:(NSMutableDictionary *)params
                                           success:(void(^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                           failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (params == nil) {
        params =
        [@{
          @"count": [[NSNumber alloc] initWithInt:2]
        } mutableCopy];
    }
    else if (params[@"count"] == nil){
        params[@"count"] = [[NSNumber alloc] initWithInt:2];
    }
    NSLog(@"client: params: %@", params);
    
    return [self GET:@"1.1/statuses/home_timeline.json"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id response) {
                 NSLog(@"success: %@", response);
                 success(operation, [Tweet parseTweets:response]);
             }
             failure:failure];
};

// POST statuses/update
// https://dev.twitter.com/docs/api/1.1/post/statuses/update
- (AFHTTPRequestOperation *)updateWithParams:(NSDictionary *)params
                                     success:(void(^)(AFHTTPRequestOperation *operation, Tweet *tweet))success
                                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self POST:@"1.1/statuses/update.json"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id response) {
                 NSLog(@"success: %@", response);
                 success(operation, [Tweet parseTweet:response]);
             }
             failure:failure];
}

// GET account/verify_credentials
// https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials
- (AFHTTPRequestOperation *)verifyCredentialsWithParams:(NSDictionary *)params
                                                success:(void(^)(AFHTTPRequestOperation *operation, User *user))success
                                                failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self GET:@"1.1/account/verify_credentials.json"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id response) {
                 NSLog(@"success: %@", response);
                 success(operation, [User parseUser:response]);
             }
             failure:failure];
}

// POST oauth/request_token
// https://dev.twitter.com/docs/api/1/post/oauth/request_token
- (void)requestTokenWithSuccess:(void(^)(BDBOAuthToken *requestToken))success
                        failure:(void(^)(NSError *error))failure
{
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"oauth://ios_twitter"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSLog(@"request_token: %@", requestToken.token);
                                success(requestToken);
                            }
                            failure:^(NSError *error) {
                                NSLog(@"request_token: %@", error);
                                failure(error);
                            }];
}

// POST oauth/access_token
// https://dev.twitter.com/docs/api/1/post/oauth/access_token
- (void)accessTokenWithURL:(NSURL *)url
                   success:(void(^)(BDBOAuthToken *accessToken))success
                   failure:(void(^)(NSError *error))failure
{
    NSDictionary *parameters = [url dictionaryFromQueryString];
    
    if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
    
        [self fetchAccessTokenWithPath:@"/oauth/access_token"
                                  method:@"POST"
                            requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                 success:^(BDBOAuthToken *accessToken) {
                                     NSLog(@"access_token: %@", accessToken.token);
                                     success(accessToken);
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"access_token: %@", error);
                                     failure(error);
                                 }];
    }
}

- (void)connectWithSuccess:(void(^)())success
                   failure:(void(^)(NSError *error))failure;
{
    [self.requestSerializer removeAccessToken];
    
    [self requestTokenWithSuccess:^(BDBOAuthToken *requestToken)
    {
        // store the request token for OAuth1.0a
        if (requestToken != nil) {
            NSLog(@"Got the request token.");
            NSLog(@"request_token: %@", requestToken.token);
            NSLog(@"request_token_secret: %@", requestToken.secret);
        }

        // launch the authorization URL in the browser
        //NSString *authorizeUrl = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        NSString *authorizeUrl = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authenticate?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authorizeUrl]];
    }
                          failure:^(NSError *error)
    {
        NSLog(@"Fail to get the request token.");
    }];
}

- (void)authorizeWithURL:(NSURL *)url
                 success:(void(^)())success
                 failure:(void(^)(NSError *error))failure
{
    [self accessTokenWithURL:url
                     success:^(BDBOAuthToken *accessToken)
    {
        // store the access token in client
        if (accessToken != nil) {
            NSLog(@"Got the access token.");
            NSLog(@"access_token: %@", accessToken.token);
            NSLog(@"access_token_secret: %@", accessToken.secret);
            
            [self.requestSerializer saveAccessToken:accessToken];
        }
        success();
    }
                     failure:^(NSError *error)
    {
        NSLog(@"Fail to get the access token.");
        failure(error);
    }];
}

// Removes the access tokens (for signing out)
- (void)removeAccessToken
{
    NSLog(@"client: remove access token");
    [self.requestSerializer removeAccessToken];
}

- (BOOL)isAuthenticated
{
    return [self isAuthorized];
}

@end