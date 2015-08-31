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
    return self.manager.linksForSmallPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView* photoView = ((UIImageView*)[cell viewWithTag:110]);
    [photoView hnk_setImageFromURL: [NSURL URLWithString:self.manager.linksForSmallPhotos[indexPath.row]]];
    return cell;
    }

/*-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionViewOfPhotos cellForItemAtIndexPath:indexPath];
    self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    [self addImageWithNumber:indexPath.row];
    
    
}*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.indexOfSelectedPhoto = indexPath.row;
    //self.indexPathOfCell = indexPath;
    //self.manager.delegate = self;
    //[self.manager ]
    [self performSegueWithIdentifier:@"pushBigPhotoCellIdentifier" sender:self];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}


/*-(void)addImageWithNumber: (NSInteger) number {
    numberOfPicture = number;
    [self.bigImageView hnk_setImageFromURL: [NSURL URLWithString:self.manager.linksForSmallPhotos[number]]];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bigImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bigImageView];
    [UIView animateWithDuration:2 animations:^{
        
        self.bigImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    self.bigImageView.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:0.9];
    [self.bigImageView hnk_setImageFromURL:[NSURL URLWithString:self.manager.linksForBigPhotos[number]]];
    self.bigImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.bigImageView addGestureRecognizer:tap];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];

    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.bigImageView addGestureRecognizer:swipeLeft];
    [self.bigImageView addGestureRecognizer:swipeRight];
}*/

/*-(void)tapped {
    [self.bigImageView removeFromSuperview];
    numberOfPicture = nil;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if(numberOfPicture == 0) {
            numberOfPicture = self.manager.linksForSmallPhotos.count - 1;
        }
        else {
            numberOfPicture--;
        }
        [self addImageWithNumber:numberOfPicture];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(numberOfPicture == self.manager.linksForSmallPhotos.count-1) {
            numberOfPicture = 0;
        }
        else {
            numberOfPicture++;
        }
        [self addImageWithNumber:numberOfPicture];;
    }
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushBigPhotoCellIdentifier"]) {
        // Get the selected item index path
        //NSIndexPath *selectedIndexPath = [[self.collectionViewOfPhotos indexPathsForSelectedItems] firstObject];
        
        // Set the thing on the view controller we're about to show
            EEBigPhotoViewController *secondViewController = segue.destinationViewController;
            secondViewController.linkForBigUrl = self.manager.linksForBigPhotos[self.indexOfSelectedPhoto];
        secondViewController.indexOfPhoto = self.indexOfSelectedPhoto;
        
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
    //EECollectionViewCustomCell* cell =
    return (EECollectionViewCustomCell*)[self.collectionViewOfPhotos cellForItemAtIndexPath:[NSIndexPath indexPathForRow:(self.indexOfSelectedPhoto + amountOfSwipe) inSection:0]];
//    NSArray* visibleItems = [self.collectionViewOfPhotos visibleCells];
//    UICollectionViewLayoutAttributes *attributes = [self.collectionViewOfPhotos layoutAttributesForItemAtIndexPath:self.indexPathOfCell];
 //   CGRect cellRect = attributes.frame;
//    CGRect cellFrameInSuperview = [self.collectionViewOfPhotos convertRect:cellRect toView:[self.collectionViewOfPhotos superview]];
//    for(EECollectionViewCustomCell* visibleCell in visibleItems) {
//        if([cell.imageView.image isEqual:visibleCell.imageView.image]) {
//            return visibleCell;
//        }
 //   }
//    return nil;
}
@end
