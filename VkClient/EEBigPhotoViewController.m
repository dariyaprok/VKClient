//
//  EEBigPhotoViewController.m
//  VkClient
//
//  Created by админ on 8/29/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEBigPhotoViewController.h"
#import "EECollectionViewController.h"
#import "Haneke.h"
#import "EETransitionFromBigPhotoToCollectionView.h"
#import "EEVkClientManager.h"

@interface EEBigPhotoViewController ()

@property (strong, nonatomic)EEVkClientManager* manager;

@end
@implementation EEBigPhotoViewController
-(void)viewDidLoad {
    self.manager = [EEVkClientManager sharedModel];
    
    [self reloadLikeButtonWithIndex:self.manager.numberOfSelectedPhoto];
    
    [self.imageView hnk_setImageFromURL:[NSURL URLWithString:((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).linkForBigId]];
    self.amountOfSwipes = 0;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.imageView addGestureRecognizer:swipeLeft];
    [self.imageView addGestureRecognizer:swipeRight];
    [self.imageView addGestureRecognizer:tap];
    
    

}


-(void)tapped {
    [UIView animateWithDuration:0.3 animations:^{
        if(self.viewWithButtons.hidden == YES) {
            self.viewWithButtons.hidden = NO;
        }
        else {
            self.viewWithButtons.hidden = YES;
        }
    }];
    
}

-(void)reloadLikeButtonWithIndex: (NSInteger)index {
   
    [self.likesButton setTitle: [((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).amountOfLikes stringValue] forState:UIControlStateNormal];
    if([((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).isUserLiked isEqual:@1]) {
        [self.likesButton setImage: [UIImage imageNamed:@"likeButtonRed"] forState:UIControlStateNormal];
    }
    else {
        [self.likesButton setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)likeButtonTapped:(id)sender {
    
    if([((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).isUserLiked isEqual:@0]) {
        [self.manager didLikePhotoWithNumber:self.manager.numberOfSelectedPhoto];
        int amauntOfLikes = [((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).amountOfLikes intValue];
        amauntOfLikes++;
        ((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).amountOfLikes = [NSNumber numberWithInt:amauntOfLikes];
       
        ((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto]).isUserLiked = @1;
    
        [self reloadLikeButtonWithIndex:self.manager.numberOfSelectedPhoto];
    }
}

-(void)handleSwipes: (UISwipeGestureRecognizer*)sender {
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if((self.manager.numberOfSelectedPhoto+1) < ((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos.count ){
            [self.imageView hnk_setImageFromURL:[NSURL URLWithString:((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto+1]).linkForBigId]];
            self.manager.numberOfSelectedPhoto++;
            //self.indexOfPhoto++;
            self.amountOfSwipes++;
            [self reloadLikeButtonWithIndex:self.manager.numberOfSelectedPhoto];
             //self.indexOfPhoto];
        }
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.manager.numberOfSelectedPhoto != 0){
            [self.imageView hnk_setImageFromURL:[NSURL URLWithString:((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto-1]).linkForBigId]];
            self.manager.numberOfSelectedPhoto--;
            self.amountOfSwipes--;
            [self reloadLikeButtonWithIndex:self.manager.numberOfSelectedPhoto];
        }
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}
- (IBAction)closePhoto:(id)sender {
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLFirstViewController
    if (fromVC == self && [toVC isKindOfClass:[EECollectionViewController class]]) {
        return [[EETransitionFromBigPhotoToCollectionView alloc] init];
    }
    else {
        return nil;
    }
}



@end
