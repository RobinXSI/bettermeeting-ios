//
//  User.m
//  Bettermeeting
//
//  Created by Robin on 06.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "User.h"

@implementation User


- (NSDictionary *)createDictionary {
    
    NSDictionary *dictionary = @{
                                 @"_id": self._id ? self._id : @"",
                                 @"email": self.email ? self.email : @"",
                                 @"firstName": self.firstName ? self.firstName : @"",
                                 @"lastName": self.lastName ? self.lastName : @"",
                                 @"password": self.password ? self.password : @"",
                                 @"password": self.pushToken ? self.pushToken : @""
                                 };
    return dictionary;
}
+ (User *)createFromDictionary: (NSDictionary *)dictionary {
    User *actualUser = [[User alloc] init];
    
    actualUser._id = dictionary[@"_id"];
    actualUser.email = dictionary[@"email"];
    actualUser.firstName = dictionary[@"firstName"];
    actualUser.lastName = dictionary[@"lastName"];
    actualUser.password = dictionary[@"password"];
    actualUser.pushToken = dictionary[@"pushToken"];
    return actualUser;
}

@end



