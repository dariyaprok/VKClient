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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionViewOfPhotos cellForItemAtIndexPath:indexPath];
    UIImageView* bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    [bigImageView hnk_setImageFromURL: [NSURL URLWithString:self.manager.linksForSmallPhotos[indexPath.row]]];
    bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bigImageView];
    [UIView animateWithDuration:2 animations:^{
        bigImageView.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:0.9];
        bigImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [bigImageView hnk_setImageFromURL:[NSURL URLWithString:self.manager.linksForBigPhotos[indexPath.row]]];
    }];
    
    
    
}
@end
