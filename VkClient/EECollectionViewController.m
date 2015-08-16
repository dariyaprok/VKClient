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
@property (strong,nonatomic) UIImageView* bigImageView;
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
    self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    [self addImageWithNumber:indexPath.row];
    
    
}
static NSInteger numberOfPicture;
-(void)addImageWithNumber: (NSInteger) number {
    numberOfPicture = number;
    [self.bigImageView hnk_setImageFromURL: [NSURL URLWithString:self.manager.linksForSmallPhotos[number]]];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bigImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bigImageView];
    [UIView animateWithDuration:2 animations:^{
        
        self.bigImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    self.bigImageView.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:0.9];
    [self.bigImageView hnk_setImageFromURL:[NSURL URLWithString:self.manager.linksForBigPhotos[number]]];
    self.bigImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.bigImageView addGestureRecognizer:tap];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];

    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.bigImageView addGestureRecognizer:swipeLeft];
    [self.bigImageView addGestureRecognizer:swipeRight];
}

-(void)tapped {
    [self.bigImageView removeFromSuperview];
    numberOfPicture = nil;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if(numberOfPicture == 0) {
            numberOfPicture = self.manager.linksForSmallPhotos.count - 1;
        }
        else {
            numberOfPicture--;
        }
        [self addImageWithNumber:numberOfPicture];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(numberOfPicture == self.manager.linksForSmallPhotos.count-1) {
            numberOfPicture = 0;
        }
        else {
            numberOfPicture++;
        }
        [self addImageWithNumber:numberOfPicture];;
    }
}
@end
