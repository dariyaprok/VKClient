//
//  EEVkClientManager.m
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEVkClientManager.h"
#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "EETableViewController.h"


@interface EEVkClientManager()
@property (nonatomic, strong) NSMutableArray* mutArrayOfIds;
@end

@implementation EEVkClientManager

static NSString* baseUrl = @"https://api.vk.com/method/users.get";
static EEVkClientManager *sharedModel;
static NSInteger const amountOfLoadedFriends = 20;

-(NSURLRequest*)getRequestForFriendsId {
    NSString* urlString = [NSString stringWithFormat:@"https://api.vk.com/method/friends.get?order=mobile&access_token=%@", self.token];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}


+(instancetype)sharedModel {
    if(sharedModel == nil) {
        sharedModel = [[EEVkClientManager alloc] init];
    }
    return sharedModel;
}

-(void)isError: (NSError*)error {
    UIAlertView* message;
    message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, there is a problem" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
}

-(NSInteger)getNumberOfFriends {
    return self.dataAboutFriends.count;
}

-(void)responseIdToIds {
    NSString* myString = [NSString stringWithFormat:@"%@", [self.responseListOfId objectForKey:@"response"]];
    //NSLog(myString);
    NSArray* arrayOfId = [myString componentsSeparatedByString:@",\n    "];
    NSMutableString* element0 = [arrayOfId[0] mutableCopy];
    NSMutableString* elementLast = [arrayOfId[arrayOfId.count -1] mutableCopy];
    [element0 deleteCharactersInRange:NSMakeRange(0, 6)];
    [elementLast deleteCharactersInRange:NSMakeRange(elementLast.length - 2 , 2)];
    self.mutArrayOfIds = [arrayOfId mutableCopy];
    [self.mutArrayOfIds replaceObjectAtIndex:0 withObject:element0];
    [self.mutArrayOfIds replaceObjectAtIndex:arrayOfId.count - 1 withObject:elementLast];
    
}
-(void)makeRequestForListOfFriends {
    self.operationManager = [AFHTTPRequestOperationManager manager];
    [self.operationManager GET:@"https://api.vk.com/method/friends.get" parameters:@{@"order":@"mobile", @"access_token":[NSString stringWithFormat:@"%@", self.token]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.responseListOfId = responseObject;
        [self responseIdToIds];
        self.dataAboutFriends = [[NSMutableArray alloc] initWithCapacity:self.mutArrayOfIds.count];
        [self makeRequestForNameAndLastName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}

NSInteger amontOfScrollsDown = 0;
-(NSString*)makeStringOfIdsForRequest {
    NSString* stringWithArrayOfIds;
    for(NSInteger i = (amontOfScrollsDown * amountOfLoadedFriends); i < (((amontOfScrollsDown+1) * amountOfLoadedFriends) < self.mutArrayOfIds.count ? ((amontOfScrollsDown+1) * amountOfLoadedFriends) : (self.mutArrayOfIds.count)) ; ++i) {
        if(i == (amontOfScrollsDown * amountOfLoadedFriends)) {
            stringWithArrayOfIds = [NSString stringWithFormat:@"%@", self.mutArrayOfIds[i]];
        }
        else {
        stringWithArrayOfIds = [NSString stringWithFormat:@"%@,%@", stringWithArrayOfIds,self.mutArrayOfIds[i]];
        }
    }
    
    return stringWithArrayOfIds;
}

-(void)makeRequestForNameAndLastName {
    NSDictionary* parameters = @{@"user_ids":[NSString stringWithFormat:@"%@",[self makeStringOfIdsForRequest]], @"fields":@"sex,bdate,photo_max, online, photo_50", @"access_token":[NSString stringWithFormat:@"%@", self.token]};
    NSInteger amountOfIdsInParamenters = [[self makeStringOfIdsForRequest] componentsSeparatedByString:@","].count;
    [self.operationManager GET:@"https://api.vk.com/method/users.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        for(NSInteger i = 0;i<amountOfIdsInParamenters; ++i) {
        NSString* element = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@", [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"first_name"], [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"last_name"], [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"photo_max"], [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"sex"],[[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"online"], [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"bdate"], [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"photo_50"]];
        [self.dataAboutFriends addObject:element];
        [self.delegate friendsLoadWithSuccses];
        }
        amontOfScrollsDown++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}

-(void)makeRequestForAlbumForFriendWithNumber:(NSInteger)number {
    NSDictionary* paramaters = @{@"owner_id": self.mutArrayOfIds[number], @"access_token":[NSString stringWithFormat:@"%@", self.token], @"need_covers":@1};
    [self.operationManager GET:@"https://api.vk.com/method/photos.getAlbums" parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataAboutAlbumsFriends = [responseObject valueForKey:@"response"];
        [self.delegate succsesLoadedAlbumsWithNumber:number ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}

-(void)makeRequestForFriendWithNumber: (NSInteger)number PhotosFromAlbumWithNumber:(NSInteger)albumNumber  {
    self.linksForSmallPhotos = [[NSMutableArray alloc] init];
    self.linksForBigPhotos = [[NSMutableArray alloc] init];
    NSDictionary* parameters = @{ @"owner_id": self.mutArrayOfIds[number], @"album_id" : [self.dataAboutAlbumsFriends[albumNumber] objectForKey:@"aid"], @"rev" : @1, @"access_token":[NSString stringWithFormat:@"%@", self.token]};
    [self.operationManager GET:@"https://api.vk.com/method/photos.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for(NSInteger i =0; i<((NSArray*)[responseObject valueForKey:@"response"]).count; ++i) {
        [self.linksForSmallPhotos addObject:[[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey: @"src_small"] ];
            [self.linksForBigPhotos addObject:[[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey: @"src_big"] ];
        }
        //NSLog(@"%@", self.linksForSmallPhotos);
        [self.delegate photosLoadedWithSuccses];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}


-(void)prepareDataForFriendWithNumber: (NSInteger)number {
    [self.delegate setPosition:number];
    
}

-(void)prepareAlbumsForFriendsWithNaumber: (NSInteger)number {
    [self.delegate setPosition:number];
}


@end
