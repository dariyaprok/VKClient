//
//  EEPhoto.h
//  VkClient
//
//  Created by админ on 9/1/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEPhoto : NSObject

@property (strong, nonatomic) NSString* linkForBigId;
@property (strong, nonatomic) NSString* linkForSmallId;
@property (strong, nonatomic) NSString* idOfPhoto;
@property (strong, nonatomic) NSNumber* isUserLiked;
@property (strong, nonatomic) NSNumber* amountOfLikes;
@end
