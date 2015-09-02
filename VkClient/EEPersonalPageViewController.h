//
//  EEPersonalPageViewController.h
//  VkClient
//
//  Created by админ on 7/31/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEVkClientManager.h"
//@protocol EEPersonalPageViewControllerDelegate  <NSObject>
//-(void)setPositionOfFriends;
//@end

@interface EEPersonalPageViewController : UIViewController <EEVkClientManagerDelegate>
//@property NSInteger positionOfFriend;
@property (strong, nonatomic) EEVkClientManager* manager;
//@property (weak, nonatomic) id <EEPersonalPageViewControllerDelegate> delegate;
@end
