//
//  UserService.h
//  Bettermeeting
//
//  Created by Robin on 08.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <RestKit/RestKit.h>

@interface UserService : NSObject

- (void)getLoggedInUserOnSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)doLoginWithEmail:(NSString *)email andPassword:(NSString *)password onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)doLogoutOnSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
