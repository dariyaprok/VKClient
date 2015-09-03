//
//  EEVkClientManager.m
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEVkClientManager.h"
#import "EEFriend.h"
#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "EETableViewController.h"


@interface EEVkClientManager() {
    
}
@property (nonatomic, strong) NSMutableArray* mutArrayOfIds;
@end

@implementation EEVkClientManager

static NSString* baseUrl = @"https://api.vk.com/method/users.get";
static EEVkClientManager *sharedModel;
static NSInteger const amountOfLoadedFriends = 20;

-(NSURLRequest*)getRequestForFriendsId {
    NSString* urlString = [NSString stringWithFormat:@"https://api.vk.com/method/friends.get?order=mobile&access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}


+(instancetype)sharedModel {
    
    //dispatch_once_f
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
    return (amontOfScrollsDown*(amountOfLoadedFriends+1));
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
    self.amountOfLoadedFriends=0;
    if (self.arrayOfFriends == nil) {
        self.arrayOfFriends = [[NSMutableArray alloc] init];
    }
    self.operationManager = [AFHTTPRequestOperationManager manager];
    [self.operationManager GET:@"https://api.vk.com/method/friends.get" parameters:@{@"order":@"mobile", @"access_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //new
        NSArray* responseArray = [responseObject valueForKey:@"response"];
        for(NSInteger i =0; i<responseArray.count; ++i){
        EEFriend* newFriend = [[EEFriend alloc] init];
        newFriend.idOfFriend = [responseArray objectAtIndex:i];
            [self.arrayOfFriends addObject:newFriend];
        }
       
        self.responseListOfId = responseObject;
        [self responseIdToIds];
        
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
    NSDictionary* parameters = @{@"user_ids":[NSString stringWithFormat:@"%@",[self makeStringOfIdsForRequest]], @"fields":@"sex,bdate,photo_max, online, photo_50", @"access_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    NSInteger amountOfIdsInParamenters = [[self makeStringOfIdsForRequest] componentsSeparatedByString:@","].count;
    [self.operationManager GET:@"https://api.vk.com/method/users.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
       
        for(NSInteger i = 0;i<amountOfIdsInParamenters; ++i) {
            //new
            ((EEFriend*)self.arrayOfFriends[i+(amontOfScrollsDown*amountOfLoadedFriends)]).name = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"first_name"];
            ((EEFriend*)self.arrayOfFriends[i+(amontOfScrollsDown*amountOfLoadedFriends)]).lastName = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"last_name"];
            ((EEFriend*)self.arrayOfFriends[i+(amontOfScrollsDown*amountOfLoadedFriends)]).isOnline = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"online"];
            ((EEFriend*)self.arrayOfFriends[i+(amontOfScrollsDown*amountOfLoadedFriends)]).linkForAvatar50 = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"photo_50"];
            ((EEFriend*)self.arrayOfFriends[i+(amontOfScrollsDown*amountOfLoadedFriends)]).dateOfBirth = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"bdate"];
            ((EEFriend*)self.arrayOfFriends[i+(amontOfScrollsDown*amountOfLoadedFriends)]).linkForPhotoMax = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"photo_max"];
            self.amountOfLoadedFriends++;
            
            
           
          //  [((EETableViewController*)self.delegate).tableView reloadData];
        [self.delegate friendsLoadWithSuccses];
        }
        amontOfScrollsDown++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}

-(void)makeRequestForAlbumForFriendWithNumber:(NSInteger)number {
    ((EEFriend*)self.arrayOfFriends[number]).albums = [NSMutableArray new];
    NSDictionary* paramaters = @{@"owner_id": self.mutArrayOfIds[number], @"need_covers":@1, @"access_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [self.operationManager GET:@"https://api.vk.com/method/photos.getAlbums" parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* responseArray = [responseObject valueForKey:@"response"];
        for(NSInteger i=0; i<responseArray.count; ++i) {
        EEAlbum* newAlbum = [EEAlbum new];
        newAlbum.idOfAlbum = [responseArray[i] valueForKey:@"aid"];
        newAlbum.ownerId = [responseArray[i] valueForKey:@"owner_id"];
        newAlbum.amountOfPhotos = [responseArray[i] valueForKey:@"size"];
        newAlbum.coverId = [responseArray[i]valueForKey:@"thumb_src"];
            newAlbum.nameOfAlbum = [responseArray[i] valueForKey:@"title"];
        
            [((EEFriend*)self.arrayOfFriends[number]).albums addObject:newAlbum];
        }
        //self.dataAboutAlbumsFriends = [responseObject valueForKey:@"response"];
        
        
        [self.delegate succsesLoadedAlbumsWithNumber:number ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}

-(void)makeRequestForFriendWithNumber: (NSInteger)number PhotosFromAlbumWithNumber:(NSInteger)albumNumber  {
   
    ((EEAlbum*)((EEFriend*)self.arrayOfFriends[number]).albums[albumNumber]).arrayOfPhotos = [NSMutableArray new];
    NSDictionary* parameters = @{ @"owner_id": ((EEFriend*)self.arrayOfFriends[number]).idOfFriend, @"album_id" : ((EEAlbum*)((EEFriend*)self.arrayOfFriends[number]).albums[albumNumber]).idOfAlbum , @"rev" : @1, @"extended":@1};//@"access_token":self.token,};
    [self.operationManager GET:@"https://api.vk.com/method/photos.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for(NSInteger i =0; i<((NSArray*)[responseObject valueForKey:@"response"]).count; ++i) {
            EEPhoto* newPhoto = [EEPhoto new];
            newPhoto.linkForBigId = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey: @"src_big"];
            newPhoto.linkForSmallId = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey: @"src_small"];
            newPhoto.amountOfLikes = [[[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey: @"likes"] valueForKey:@"count"];
            newPhoto.isUserLiked = [[[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey: @"likes"] valueForKey:@"user_likes"];
            [((EEAlbum*)((EEFriend*)self.arrayOfFriends[number]).albums[albumNumber]).arrayOfPhotos addObject:newPhoto];
            newPhoto.idOfPhoto = [[[responseObject valueForKey:@"response"] objectAtIndex:i] valueForKey:@"aid"];
            
        }
        [self.delegate photosLoadedWithSuccses];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self isError:error];
    }];
}

-(void) makeRquestForLogOut {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //[[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) didLikePhotoWithNumber: (NSInteger)number {
    NSString* addLikeLink = @"https://api.vk.com/method/likes.add";
    NSDictionary* parameters = @{@"type":@"photo", @"owner_id": ((EEFriend*)self.arrayOfFriends[self.numberOfSelectedFriend]).idOfFriend,  @"item_id": ((EEPhoto*)((EEAlbum*)((EEFriend*)self.arrayOfFriends[self.numberOfSelectedFriend]).albums[self.numberOfSelectedAlbum]).arrayOfPhotos[number]).idOfPhoto, @"v":@"5.37", @"access_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [self.operationManager GET:addLikeLink parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
