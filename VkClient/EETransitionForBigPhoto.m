//
//  EETransitionForBigPhoto.m
//  VkClient
//
//  Created by админ on 8/29/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EETransitionForBigPhoto.h"
#import "EECollectionViewCustomCell.h"
#import "EEBigPhotoViewController.h"
#import "EECollectionViewController.h"


@implementation EETransitionForBigPhoto
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    EECollectionViewController *fromViewController = (EECollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EEBigPhotoViewController *toViewController = (EEBigPhotoViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // Get a snapshot of the thing cell we're transitioning from
    EECollectionViewCustomCell *cell = (EECollectionViewCustomCell*)[fromViewController.collectionViewOfPhotos cellForItemAtIndexPath:[[fromViewController.collectionViewOfPhotos indexPathsForSelectedItems] firstObject]];
    UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    cell.imageView.hidden = YES;
    
    

    double toMakePhotoBigger = (toViewController.view.frame.size.width/cell.imageView.image.size.width > toViewController.view.frame.size.height/cell.imageView.image.size.height) ? toViewController.view.frame.size.height/cell.imageView.image.size.height : toViewController.view.frame.size.width/cell.imageView.image.size.width;
    // Setup the initial view states
    toViewController.view.alpha = 0;
    toViewController.imageView.hidden = YES;
    
    

    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        toViewController.view.alpha = 1.0;
        
        // Move the cell snapshot so it's over the second view controller's image view
        CGRect frame = CGRectMake((fromViewController.view.frame.size.width - cellImageSnapshot.frame.size.width*toMakePhotoBigger)/2, (fromViewController.view.frame.size.height - cellImageSnapshot.frame.size.height*toMakePhotoBigger)/2, cellImageSnapshot.frame.size.width*toMakePhotoBigger, cellImageSnapshot.frame.size.height*toMakePhotoBigger);
        cellImageSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        // Clean up
        toViewController.imageView.hidden = NO;
        cell.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end
