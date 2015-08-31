//
//  EETransitionFromBigPhotoToCollectionView.m
//  VkClient
//
//  Created by админ on 8/29/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EETransitionFromBigPhotoToCollectionView.h"
#import "EECollectionViewCustomCell.h"
#import "EEBigPhotoViewController.h"
#import "EECollectionViewController.h"

@implementation EETransitionFromBigPhotoToCollectionView
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    EEBigPhotoViewController* fromViewController = (EEBigPhotoViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EECollectionViewController* toViewController = (EECollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *imageSnapshot = [fromViewController.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.imageView.superview];
    fromViewController.imageView.hidden = YES;
    
    EECollectionViewCustomCell *oldCell =  [toViewController cellWithAmountOfSwipe:0];
    oldCell.imageView.hidden = NO;
    EECollectionViewCustomCell *cell =  [toViewController cellWithAmountOfSwipe:fromViewController.amountOfSwipes];
    cell.imageView.hidden = YES;
    
    UICollectionViewLayoutAttributes *attributes = [toViewController.collectionViewOfPhotos layoutAttributesForItemAtIndexPath:[toViewController.collectionViewOfPhotos indexPathForCell:cell]];
    CGRect cellRect = attributes.frame;
    CGRect frameInSuperView = [toViewController.collectionViewOfPhotos convertRect:cellRect toView:[toViewController.collectionViewOfPhotos superview]];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    double toMakePhotoBigger = (fromViewController.view.frame.size.width/cell.imageView.image.size.width > fromViewController.view.frame.size.height/cell.imageView.image.size.height) ? fromViewController.view.frame.size.height/cell.imageView.image.size.height : fromViewController.view.frame.size.width/cell.imageView.image.size.width;
    CGRect finalFrame = CGRectMake(frameInSuperView.origin.x + (frameInSuperView.size.width - fromViewController.imageView.frame.size.width/toMakePhotoBigger)/2, frameInSuperView.origin.y - (fromViewController.imageView.frame.size.height/toMakePhotoBigger - cell.frame.size.height)/2, fromViewController.imageView.frame.size.width/toMakePhotoBigger, fromViewController.imageView.frame.size.height/toMakePhotoBigger);
    [UIView animateWithDuration:duration animations:^{
        // Fade out the source view controller
        fromViewController.view.alpha = 0.0;
        
        if(finalFrame.size.width == 0 || finalFrame.size.height == 0) {
            [imageSnapshot removeFromSuperview];
        }
        else {
            imageSnapshot.frame = finalFrame;
        }

        
    } completion:^(BOOL finished) {
        // Clean up
        fromViewController.amountOfSwipes = 0;
        [imageSnapshot removeFromSuperview];
        fromViewController.imageView.hidden = NO;
        cell.imageView.hidden = NO;
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

    
}
@end
