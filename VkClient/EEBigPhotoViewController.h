//
//  EEBigPhotoViewController.h
//  VkClient
//
//  Created by админ on 8/29/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface EEBigPhotoViewController : UIViewController <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewWithButtons;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UIButton *sharingButton;
@property (strong, nonatomic) NSString* linkForBigUrl;
@property  NSInteger indexOfPhoto;
@property NSInteger amountOfSwipes;
@end
