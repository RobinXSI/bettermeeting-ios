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

- (void)registerPushTokenOnUser:(User *)user {
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"pushToken"];
    if (pushToken != nil && ![pushToken isEqualToString:@""] && [pushToken length] > 0) {
        user.pushToken = pushToken;
        // UPDATE PUSH TOKEN ONLINE
    }
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
                           [self registerPushTokenOnUser:user];
                           [self persistUserSettingsForUser:user];
                           success(operation, responseObject);
                       }
                         onError:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@", error);
                             failure(operation, error);
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
