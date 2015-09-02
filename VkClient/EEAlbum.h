//
//  EEAlbum.h
//  VkClient
//
//  Created by админ on 9/1/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEAlbum : NSObject

@property (strong, nonatomic) NSString* idOfAlbum;
@property (strong, nonatomic) NSString* ownerId;
@property (strong, nonatomic) NSNumber* amountOfPhotos;
@property (strong, nonatomic) NSString* nameOfAlbum;
@property (strong, nonatomic) NSString* coverId;
@property (strong, nonatomic) NSMutableArray* arrayOfPhotos;

@end
