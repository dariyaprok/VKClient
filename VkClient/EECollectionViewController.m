//
//  EECollectionViewController.m
//  VkClient
//
//  Created by админ on 8/12/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EECollectionViewController.h"
#import "Haneke.h"
@interface EECollectionViewController()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfPhotos;
@property (strong, nonatomic) EEVkClientManager* manager;
@end

@implementation EECollectionViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.manager = [EEVkClientManager sharedModel];
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.manager.linksForSmallPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView* photoView = ((UIImageView*)[cell viewWithTag:110]);
    [photoView hnk_setImageFromURL: [NSURL URLWithString:self.manager.linksForSmallPhotos[indexPath.row]]];
    return cell;
    }


@end
