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

@end
