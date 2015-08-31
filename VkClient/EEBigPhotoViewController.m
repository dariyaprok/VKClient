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
    
    [self reloadLikeButtonWithIndex:self.indexOfPhoto];
    
    [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.linkForBigUrl]];
    self.amountOfSwipes = 0;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.imageView addGestureRecognizer:swipeLeft];
    [self.imageView addGestureRecognizer:swipeRight];
    [self.imageView addGestureRecognizer:tap];
    
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.view addGestureRecognizer:pan];
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
    [self.likesButton setTitle:[[self.manager.infoAboutLikes[self.indexOfPhoto] objectForKey:@"count"] stringValue] forState:UIControlStateNormal];
    if([[self.manager.infoAboutLikes[self.indexOfPhoto] objectForKey:@"user_likes" ] isEqual:@1]) {
        [self.likesButton setImage: [UIImage imageNamed:@"likeButtonRed"] forState:UIControlStateNormal];
    }
    else {
        [self.likesButton setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)likeButtonTapped:(id)sender {
    NSInteger amountOfLikes = [[self.manager.infoAboutLikes[self.indexOfPhoto] objectForKey:@"count"] integerValue];
    if([[self.manager.infoAboutLikes[self.indexOfPhoto] objectForKey:@"user_likes" ] isEqual:@0]) {
        [self.manager didLikePhotoWithNumber:self.indexOfPhoto];
        amountOfLikes++;
        [self.manager.infoAboutLikes[self.indexOfPhoto] setObject:@(amountOfLikes) forKey:@"count"];
        [self.manager.infoAboutLikes[self.indexOfPhoto] setObject:@(1)forKey:@"user_likes"];
        [self reloadLikeButtonWithIndex:self.indexOfPhoto];
    }
}

-(void)handleSwipes: (UISwipeGestureRecognizer*)sender {
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.indexOfPhoto != self.manager.linksForBigPhotos.count-1){
            [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.manager.linksForBigPhotos[self.indexOfPhoto+1]]];
            self.indexOfPhoto++;
            self.amountOfSwipes++;
            [self reloadLikeButtonWithIndex:self.indexOfPhoto];
        }
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.indexOfPhoto != 0){
            [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.manager.linksForBigPhotos[self.indexOfPhoto-1]]];
            self.indexOfPhoto--;
            self.amountOfSwipes--;
            [self reloadLikeButtonWithIndex:self.indexOfPhoto];
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
