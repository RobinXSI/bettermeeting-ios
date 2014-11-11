//
//  MeetingService.h
//  Bettermeeting
//
//  Created by Robin on 11.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Meeting.h"

@interface MeetingService : NSObject

- (void)doLikeMeeting: (Meeting *)meeting onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)doDislikeMeeting: (Meeting *)meeting onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
