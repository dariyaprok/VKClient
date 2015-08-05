//
//  EEVkClientManager.h
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
@protocol EEVkClientManagerDelegate <NSObject>
@optional
-(void)friendsLoadWithSuccses;
-(void)setPosition: (NSInteger)position;
@end

@interface EEVkClientManager : NSObject
@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDictionary* responseListOfId;
@property (strong, nonatomic) NSMutableArray* dataAboutFriends;
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

@end
