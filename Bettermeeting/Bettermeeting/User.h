//
//  User.h
//  Bettermeeting
//
//  Created by Robin on 06.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *pushId;

- (NSDictionary *)createDictionary;
+ (User *)createFromDictionary: (NSDictionary *)dictionary;

@end
