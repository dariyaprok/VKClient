//
//  EEFriend.h
//  VkClient
//
//  Created by админ on 9/1/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEFriend : NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* dateOfBirth;
@property (strong, nonatomic) NSNumber* isOnline;
@property (strong, nonatomic) NSString* idOfFriend;
@property (strong, nonatomic) NSMutableArray* albums;
@property (strong, nonatomic) NSString* linkForAvatar50;
@property (strong, nonatomic) NSString* linkForPhotoMax;
@end
