//
//  EEVkClientManager.h
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "EEFriend.h"
#import "EEAlbum.h"
#import "EEPhoto.h"

@protocol EEVkClientManagerDelegate <NSObject>
@optional
-(void)friendsLoadWithSuccses;
-(void)setPosition: (NSInteger)position;
-(void)succsesLoadedAlbumsWithNumber:(NSInteger)number;
-(void)photosLoadedWithSuccses;
@end

@interface EEVkClientManager : NSObject
@property (strong, nonatomic) NSMutableArray* arrayOfFriends;
@property NSInteger numberOfSelectedFriend;
@property NSInteger numberOfSelectedAlbum;
@property NSInteger numberOfSelectedPhoto;
@property (nonatomic) NSInteger amountOfLoadedFriends;
@property NSInteger amountOfLoadedAlbums;


//@property (strong, nonatomic) NSString* userId;
//@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDictionary* responseListOfId;
@property (nonatomic, weak) id<EEVkClientManagerDelegate> delegate;
@property (nonatomic, strong) AFHTTPRequestOperationManager* operationManager;


+(instancetype)sharedModel;

-(NSURLRequest*)getRequestForFriendsId;
-(void)isError: (NSError*)error;
-(NSInteger)getNumberOfFriends;
-(void)responseIdToIds;
-(void)makeRequestForListOfFriends;
-(void)makeRequestForNameAndLastName;
-(void)prepareDataForFriendWithNumber: (NSInteger)number;
-(void)makeRequestForAlbumForFriendWithNumber:(NSInteger)number;
-(void)prepareAlbumsForFriendsWithNaumber: (NSInteger)number;
-(void)makeRequestForFriendWithNumber: (NSInteger)number PhotosFromAlbumWithNumber:(NSInteger)albumNumber ;
-(void)makeRquestForLogOut;
-(void) didLikePhotoWithNumber: (NSInteger)number;

@end
