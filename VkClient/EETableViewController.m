//
//  EEMainViewController.m
//  VkClient
//
//  Created by админ on 11.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EETableViewController.h"
#import "EEVkClientManager.h"
#import <AFNetworking/AFHTTPRequestOperation.h>


//#import "ASIFormDataRequest.h"
@interface EETableViewController()
@property (weak, nonatomic) EEVkClientManager* manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EETableViewController


-(void)viewDidLoad {
    //NSString* responseString;
    self.manager = [EEVkClientManager sharedModel];
    self.manager.delegate = self;
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[self.manager getRequestForFriendsId]];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.manager.responseListOfId = responseObject;
        [self.manager responseIdToNames];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.manager isError:error];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(void)friendsLoadWithSuccses {
    [self.tableView reloadData];
}

-(void)makeOperationLoad {
    
}
#pragma mark dataSource methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell_identifier";
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier];
    }
    cell.textLabel.text = [self.manager.friendsNameAnsLastNames objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.manager getNumberOfFriends];
}
@end
