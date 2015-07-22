//
//  EEVkClientManager.h
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol EEVkClientManagerDelegate <NSObject>
-(void)friendsLoadWithSuccses;
@end

@interface EEVkClientManager : NSObject
@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDictionary* responseListOfId;
@property (strong, nonatomic) NSMutableArray* friendsNameAnsLastNames;
@property (nonatomic, weak) id<EEVkClientManagerDelegate> delegate;

+(instancetype)sharedModel;
-(NSURLRequest*)getRequestForFriendsId;
-(void)isError: (NSError*)error;
-(NSInteger)getNumberOfFriends;
-(void)responseIdToNames;

@end
