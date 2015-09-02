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
#import "EECollectionViewCustomCell.h"
#import "EEPhoto.h"

@interface EECollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, EEVkClientManagerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfPhotos;
@property NSInteger indexOfSelectedPhoto;
//@property (strong, nonatomic) NSIndexPath *indexPathOfCell;
-(EECollectionViewCustomCell*)cellWithAmountOfSwipe: (NSInteger)amountOfSwipe ;

@end

