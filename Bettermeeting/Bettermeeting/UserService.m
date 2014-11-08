//
//  UserService.m
//  Bettermeeting
//
//  Created by Robin on 08.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "UserService.h"
#import "APIService.h"

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

-(User *)getLoggedInUserOnSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDictionary = [defaults objectForKey:@"ActualUser"];
    User *actualUser;
    
    if(userDictionary != nil) {
        actualUser = [User createFromDictionary:userDictionary];
        NSLog(@"Try Login");
        NSString *path = [NSString stringWithFormat:@"/api/user/login?username=%@&password=%@", actualUser.email, actualUser.password];
        [apiService performGETonPath:path
                           onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                               [self registerPushTokenOnUser:actualUser];
                               [self persistUserSettingsForUser:actualUser];
                               success(operation, responseObject);
                           }
                             onError:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"Error: %@", error);
                                 failure(operation, error);
                             }];
    }
    return actualUser;
}

- (void) persistUserSettingsForUser:(User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[user createDictionary] forKey:@"ActualUser"];
}

- (void)registerPushTokenOnUser:(User *)user {
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"PushToken"];
    if (pushToken != nil || "") {
        user.pushToken = pushToken;
    }
    // UPDATE PUSH TOKEN ONLINE
}

- (void)doLoginWithEmail:(NSString *)email andPassword:(NSString *)password onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    User *actualUser = [[User alloc] init];
    actualUser.email = email;
    actualUser.password = password;
    
    [self registerPushTokenOnUser:actualUser];
    
    NSString *path = [NSString stringWithFormat:@"/api/user/login?username=%@&password=%@", actualUser.email, actualUser.password];
    [apiService performGETonPath:path
                       onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                           [self registerPushTokenOnUser:actualUser];
                           [self persistUserSettingsForUser:actualUser];
                           success(operation, responseObject);
                           
                       }
                         onError:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@", error);
                             failure(operation, error);
                         }];
}

- (void)doLogoutOnSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
}



@end
