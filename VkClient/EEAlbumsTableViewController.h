//
//  EEAlbumsTableViewController.h
//  VkClient
//
//  Created by админ on 8/5/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EEVkClientManager.h"

@interface EEAlbumsTableViewController : UIViewController <EEVkClientManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property NSInteger positionOfFriendForPhotos;
@end
