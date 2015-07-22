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
@property (weak, nonatomic) EETableViewController* myController;
@end

@implementation EEVkClientManager

static EEVkClientManager *sharedModel;
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
    return self.friendsNameAnsLastNames.count;
}

-(void)responseIdToNames {
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
    [self makeRequestForNameAndLastName];
}
-(void)makeRequestForNameAndLastName {
    for(int i=0; i<self.mutArrayOfIds.count; ++i) {
        NSString* reqString = [NSString stringWithFormat:@"https://api.vk.com/method/users.get?user_id=%@", self.mutArrayOfIds[i]];
        NSURL* url = [NSURL URLWithString:reqString];
        NSURLRequest* req = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        self.friendsNameAnsLastNames = [[NSMutableArray alloc] initWithCapacity:self.mutArrayOfIds.count];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* element = [NSString stringWithFormat:@"%@ %@", [[[responseObject valueForKey:@"response"] objectAtIndex:0] valueForKey:@"last_name"], [[[responseObject valueForKey:@"response"] objectAtIndex:0] valueForKey:@"first_name"]];
            [self.friendsNameAnsLastNames addObject:element];
                [self.delegate friendsLoadWithSuccses];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self isError:error];
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

@end
