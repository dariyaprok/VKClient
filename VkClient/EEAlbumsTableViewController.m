//
//  EEAlbumsTableViewController.m
//  VkClient
//
//  Created by админ on 8/5/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEAlbumsTableViewController.h"
#import "EEVkClientManager.h"
#import "EEAlbumsCustumCell.h"
#import "Haneke.h"

@interface EEAlbumsTableViewController()

@property (weak, nonatomic) IBOutlet UITableView *albumsTableView;

@property (strong, nonatomic) EEVkClientManager* manager;
@end

@implementation EEAlbumsTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.manager = [EEVkClientManager sharedModel];
    self.manager.delegate = self;
    return self;
}



-(void)setPosition:(NSInteger)position {
    self.manager.numberOfSelectedFriend = position;
    //self.positionOfFriendForPhotos = position;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"albums_cell_identifier";
    EEAlbumsCustumCell* cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[EEAlbumsCustumCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier];
    }
    [cell.coverAlbumImageView hnk_setImageFromURL:[NSURL URLWithString:((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[indexPath.row]).coverId]];
    //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.manager.dataAboutAlbumsFriends[indexPath.row] objectForKey:@"thumb_src"]]]];
    cell.nameAlbumLabel.text = [NSString stringWithFormat:@"%@ (%@ photos)", ((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[indexPath.row]).nameOfAlbum, ((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[indexPath.row]).amountOfPhotos ];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return ((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.manager.numberOfSelectedAlbum = indexPath.row;
    [self.manager makeRequestForFriendWithNumber:self.manager.numberOfSelectedFriend PhotosFromAlbumWithNumber:indexPath.row];
}

-(void) photosLoadedWithSuccses {
    [self performSegueWithIdentifier:@"showCollectionViewSegueIdentifier" sender:self];
}
@end
