//
//  EEListOfFriensTableViewCell.h
//  VkClient
//
//  Created by админ on 8/29/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EEListOfFriensTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *littleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameAntLastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOnlineLabel;

@end
