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
#import "EEUIColor+OwnColors.h"
#import "EELayerButton.h"
#import "EEPersonalPageViewController.h"
#import "Haneke.h"
#import "EEListOfFriensTableViewCell.h"


@interface EETableViewController()
@property (weak, nonatomic) EEVkClientManager* manager;



@end

@implementation EETableViewController

- (IBAction)logOutButtonPressed:(id)sender {
    [self.manager makeRquestForLogOut];
    [self performSegueWithIdentifier:@"logOutSegueIdentifier" sender:self];
}

-(void)viewDidLoad {
    //NSString* responseString;
    self.manager = [EEVkClientManager sharedModel];
    self.manager.delegate = self;
    [self.manager makeRequestForListOfFriends];
}

-(void) viewDidAppear:(BOOL)animated {
    self.manager.delegate = self;
}
-(void)friendsLoadWithSuccses {
    [self.tableView reloadData];
}



#pragma mark dataSource methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cell_identifier";
    EEListOfFriensTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[EEListOfFriensTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier];
    }

    cell.nameAntLastNameLabel.text = [NSString stringWithFormat:@"%@ %@", ((EEFriend*)self.manager.arrayOfFriends[indexPath.row]).name, ((EEFriend*)self.manager.arrayOfFriends[indexPath.row]).lastName];

    [cell.littleImageView hnk_setImageFromURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@", ((EEFriend*)self.manager.arrayOfFriends[indexPath.row]).linkForAvatar50]]];
    if([((EEFriend*)self.manager.arrayOfFriends[indexPath.row]).isOnline isEqual:@1]) {
        cell.isOnlineLabel.text = @"Online";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.manager.amountOfLoadedFriends;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.manager.numberOfSelectedFriend = indexPath.row;
    [self performSegueWithIdentifier:@"pushPersonalPageControllerSegueIdrntifier" sender:self];
    [self.manager prepareDataForFriendWithNumber:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.manager.numberOfSelectedFriend = indexPath.row;
    self.manager.delegate = self;
    [self.manager makeRequestForAlbumForFriendWithNumber:indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.manager.amountOfLoadedFriends - 1) {
         [self.manager makeRequestForNameAndLastName];
        
    }
}

- (void) succsesLoadedAlbumsWithNumber:(NSInteger)number {
    [self performSegueWithIdentifier:@"showAlbumsTableViewControllerSegueIdentifier" sender:self];
    [self.manager prepareAlbumsForFriendsWithNaumber:number];
}


@end
