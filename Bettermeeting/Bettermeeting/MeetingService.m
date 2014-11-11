//
//  MeetingService.m
//  Bettermeeting
//
//  Created by Robin on 11.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "MeetingService.h"
#import "APIService.h"

@implementation MeetingService {
    APIService *apiService;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        apiService = [[APIService alloc] init];
    }
    return self;
}

- (void)doLikeMeeting: (Meeting *)meeting onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"/api/meetings/%@/voteUp", meeting.getId];
    [apiService performPUTonPath:path
                  withParameters:@{}
                       onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                                     success(operation, responseObject);
                                                 }
                                                 onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     NSLog(@"Error: %@", error);
                                                     failure(operation, error);
                                                 }];
}
- (void)doDislikeMeeting: (Meeting *)meeting onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"/api/meetings/%@/voteDown", meeting.getId];
    [apiService performPUTonPath:path
                  withParameters:@{}
                       onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                           success(operation, responseObject);
                       }
                       onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Error: %@", error);
                           failure(operation, error);
                       }];
    
}

@end
