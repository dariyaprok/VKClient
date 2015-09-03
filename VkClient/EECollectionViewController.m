//
//  EECollectionViewController.m
//  VkClient
//
//  Created by админ on 8/12/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EECollectionViewController.h"
#import "Haneke.h"
#import "EEBigPhotoViewController.h"
#import "EETransitionForBigPhoto.h"
#import "EECollectionViewCustomCell.h"

@interface EECollectionViewController()

@property (strong, nonatomic) EEVkClientManager* manager;
@property (strong,nonatomic) UIImageView* bigImageView;


@end

@implementation EECollectionViewController
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

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.manager = [EEVkClientManager sharedModel];
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger toReturn = ((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos.count;
    return toReturn;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView* photoView = ((UIImageView*)[cell viewWithTag:110]);
    [photoView hnk_setImageFromURL: [NSURL URLWithString:((EEPhoto*)((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[indexPath.row]).linkForSmallId]];
    return cell;
    }



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.manager.numberOfSelectedPhoto = indexPath.row;
    self.indexOfSelectedPhoto = indexPath.row;

    [self performSegueWithIdentifier:@"pushBigPhotoCellIdentifier" sender:self];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushBigPhotoCellIdentifier"]) {
       
        
        // Set the thing on the view controller we're about to show
            EEBigPhotoViewController *secondViewController = segue.destinationViewController;
        secondViewController.openedPhoto = ((EEAlbum*)((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).albums[self.manager.numberOfSelectedAlbum]).arrayOfPhotos[self.manager.numberOfSelectedPhoto];
        
    }
}


#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[EEBigPhotoViewController class]]) {
        return [[EETransitionForBigPhoto alloc] init];
    }
    else {
        return nil;
    }
}

-(EECollectionViewCustomCell*)cellWithAmountOfSwipe: (NSInteger)amountOfSwipe {

    return (EECollectionViewCustomCell*)[self.collectionViewOfPhotos cellForItemAtIndexPath:[NSIndexPath indexPathForRow:(self.indexOfSelectedPhoto + amountOfSwipe) inSection:0]];

}
@end
