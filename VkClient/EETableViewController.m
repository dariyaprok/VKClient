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
    [self.manager makeRequestForListOfFriends];
}

-(void)friendsLoadWithSuccses {
    [self.tableView reloadData];
}


#pragma mark dataSource methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell_identifier";
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier];
    }
    NSArray* arrayOfData = [[self.manager.dataAboutFriends objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", arrayOfData[0], arrayOfData[1]];
    cell.textLabel.textColor = [UIColor vkBlueColor];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:arrayOfData[2]]]];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.manager.delegate = self;
    [self.manager makeRequestForAlbumForFriendWithNumber:indexPath.row];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
    [self.manager makeRequestForNameAndLastName];
    }
}
-(void) succsesLoadedAlbumsWithNumber:(NSInteger)number {
    [self performSegueWithIdentifier:@"showAlbumsTableViewControllerSegueIdentifier" sender:self];
    [self.manager prepareAlbumsForFriendsWithNaumber:number];
}


@end
