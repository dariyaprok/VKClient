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
    EECollectionViewCustomCell *cell =  [toViewController.collectionViewOfPhotos cellForItemAtIndexPath:[NSIndexPath indexPathForItem:toViewController.indexOfSelectedPhoto inSection:0]];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        // Fade out the source view controller
        fromViewController.view.alpha = 0.0;
        
        // Move the image view
        imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    } completion:^(BOOL finished) {
        // Clean up
        [imageSnapshot removeFromSuperview];
        fromViewController.imageView.hidden = NO;
        cell.imageView.hidden = NO;
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

    
}
@end
