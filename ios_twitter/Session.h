//
//  Session.h
//  ios_twitter
//
//  Created by Stanley Ng on 7/2/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Session : NSObject

+ (Session *)instance;
- (User *)getUser;
- (void)setUser:(User *)user;

@end
