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
#import "EEUIColorOwnColors.h"
#import "EELayerButton.h"
#import "EEPersonalPageViewController.h"
#import "Haneke.h"
#import "EEListOfFriensTableViewCell.h"

//#import "ASIFormDataRequest.h"
@interface EETableViewController()
@property (weak, nonatomic) EEVkClientManager* manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation EETableViewController

- (IBAction)logOutButtonPressed:(id)sender {
    [self.manager makeRquestForLogOut];
}

-(void)viewDidLoad {
    //NSString* responseString;
    self.manager = [EEVkClientManager sharedModel];
    self.manager.delegate = self;
    [self.manager makeRequestForListOfFriends];
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
    NSArray* arrayOfData = [[self.manager.dataAboutFriends objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
    cell.nameAntLastNameLabel.text = [NSString stringWithFormat:@"%@ %@", arrayOfData[0], arrayOfData[1]];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", arrayOfData[0], arrayOfData[1]];
    //cell.textLabel.textColor = [UIColor vkBlueColor];
    //cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@", arrayOfData[6]]]]];
    [cell.littleImageView hnk_setImageFromURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@", arrayOfData[6]]]];
    if([arrayOfData[4] isEqual:@"1"]) {
        cell.isOnlineLabel.text = @"Online";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.manager getNumberOfFriends];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"pushPersonalPageControllerSegueIdrntifier" sender:self];
    [self.manager prepareDataForFriendWithNumber:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.manager.delegate = self;
    self.manager.numberOfFriendSelected = indexPath.row;
    [self.manager makeRequestForAlbumForFriendWithNumber:indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.manager getNumberOfFriends] - 1) {
         [self.manager makeRequestForNameAndLastName];
    }
}

- (void) succsesLoadedAlbumsWithNumber:(NSInteger)number {
    [self performSegueWithIdentifier:@"showAlbumsTableViewControllerSegueIdentifier" sender:self];
    [self.manager prepareAlbumsForFriendsWithNaumber:number];
}


@end
