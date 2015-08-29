//
//  EEBigPhotoViewController.m
//  VkClient
//
//  Created by админ on 8/29/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEBigPhotoViewController.h"
#import "Haneke.h"

@implementation EEBigPhotoViewController
-(void)viewDidLoad {
    [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.linkForBigUrl]];
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

@end
