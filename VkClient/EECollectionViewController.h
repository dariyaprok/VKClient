//
//  EECollectionViewController.h
//  VkClient
//
//  Created by админ on 8/12/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EETableViewController.h"

@interface EECollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, EEVkClientManagerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfPhotos;
@property NSInteger indexOfSelectedPhoto;
@end

