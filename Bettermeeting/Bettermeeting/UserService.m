    //
//  UserService.m
//  Bettermeeting
//
//  Created by Robin on 08.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "UserService.h"
#import "APIService.h"
#import <RestKit/RestKit.h>

@implementation UserService {
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

-(void)getUserInformation {
    
}

-(void)getLoggedInUserOnSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    User *actualUser = [self getUserFromPersistance];
    if(![actualUser.email isEqualToString:@""]) {
        
        [self requestLoginWithUser:actualUser onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
}

- (User *)getUserFromPersistance {
    User *actualUser;
    NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActualUser"];
    if(userDictionary != nil) {
        actualUser = [User createFromDictionary:userDictionary];
    } else {
        actualUser = [[User alloc] init];
    }
    return actualUser;
    
}

- (void) persistUserSettingsForUser:(User *)user {
    [[NSUserDefaults standardUserDefaults] setObject:[user createDictionary] forKey:@"ActualUser"];
}

- (void) deregisterUserSettings {
    User *emptyUser = [[User alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[emptyUser createDictionary] forKey:@"ActualUser"];
}

- (NSString *)getPushToken {
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"pushToken"];
    if (pushToken != nil && ![pushToken isEqualToString:@""] && [pushToken length] > 0) {
        return pushToken;
    }
    return @"";
}

- (void)doLoginWithEmail:(NSString *)email andPassword:(NSString *)password onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    User *actualUser = [[User alloc] init];
    actualUser.email = email;
    actualUser.password = password;
    
    [self requestLoginWithUser:actualUser onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)requestLoginWithUser: (User *)user onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"/api/user/login?username=%@&password=%@", user.email, user.password];
    [apiService performGETonPath:path
                       onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);

                           NSError *error;
                           NSMutableDictionary *returnDataAsJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                           if (error) {
                               NSLog(@"%@", [error localizedDescription]);
                           } else {
                               NSDictionary *userDetails = returnDataAsJson[@"user"];
                               User *temp = [[User alloc] init];
                               temp._id = userDetails[@"_id"][@"$oid"];
                               temp.email = userDetails[@"email"];
                               temp.firstName = userDetails[@"firstName"];
                               temp.lastName = userDetails[@"lastName"];
                               temp.password = userDetails[@"password"];
                               temp.pushToken = [self getPushToken];
                               
                               NSString *remotePushToken = userDetails[@"pushToken"];
                               if(!remotePushToken || ![temp.pushToken isEqualToString:remotePushToken]) {
                                   NSLog(@"RemoteToken has been Updated. PUT To Server");
                                   [self updateRemotePushTokenWithToken:temp.pushToken];
                               }
                               
                               NSLog(@"%@", remotePushToken);
                               temp.pushToken = [self getPushToken];
                               [self persistUserSettingsForUser:temp];
                           }
                           success(operation, responseObject);
                       }
                         onError:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@", error);
                             failure(operation, error);
                         }];
}

- (void)updateRemotePushTokenWithToken:(NSString *)token {

    NSString *path = @"/api/user/pushtoken";
    NSDictionary *params = @{@"pushToken": token};
    
    [apiService performPUTonPath:path
                  withParameters:params
                       onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                       }
                       onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Error: %@", error);
                       }];
}

- (void)doLogoutOnSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *path = @"/api/user/logout";
    [apiService performGETonPath:path
                       onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                           [self deregisterUserSettings];
                           success(operation, responseObject);
                           
                       }
                         onError:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@", error);
                             failure(operation, error);
                         }];
}



@end
