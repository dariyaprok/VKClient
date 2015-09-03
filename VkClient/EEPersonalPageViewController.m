//
//  EEPersonalPageViewController.m
//  VkClient
//
//  Created by админ on 7/31/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEPersonalPageViewController.h"
#import "EEVkClientManager.h"
#import "Haneke.h"
@interface EEPersonalPageViewController()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bDayDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *bDayDateStandartTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *offlineOnlineLabel;



@end
@implementation EEPersonalPageViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.manager = [EEVkClientManager sharedModel];
    self.manager.delegate = self;
    return self;
}
-(void)setPosition:(NSInteger)position {
    
    self.manager.numberOfSelectedFriend = position;
}

-(void) viewDidAppear:(BOOL)animated {
    self.manager.delegate = self;
}
-(void)viewDidLoad {
        self.firstNameLabel.text =  ((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).name;
    self.lastNameLabel.text = ((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).lastName;
    if([((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).dateOfBirth length] != 0) {
    self.bDayDateLabel.text = [self stringOfBdayDate:((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).dateOfBirth];
    }
    else {
        self.bDayDateLabel.text = nil;
        self.bDayDateStandartTextLabel.text = nil;
    }
    [self.avatarImage hnk_setImageFromURL:[NSURL URLWithString:((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).linkForPhotoMax]];
        if([((EEFriend*)self.manager.arrayOfFriends[self.manager.numberOfSelectedFriend]).isOnline isEqual:@1]) {
        self.offlineOnlineLabel.text = @"Online";
    }
    else {
        self.offlineOnlineLabel.text = @"Offline";
    }
}

-(NSString*)stringOfBdayDate: (NSString*)stringOfData {
    NSArray* arrayOfDateOfBirth = [stringOfData componentsSeparatedByString:@"."];
    NSString* bdayDateString = [NSString stringWithFormat:@"%@", arrayOfDateOfBirth[0]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    int monthNumber = [arrayOfDateOfBirth[1] intValue];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(monthNumber-1)];
    bdayDateString = [NSString stringWithFormat:@"%@ %@", bdayDateString, monthName];
    if(arrayOfDateOfBirth.count == 3) {
        bdayDateString = [NSString stringWithFormat:@"%@ %@", bdayDateString, arrayOfDateOfBirth[2]];
    }
    return bdayDateString;
}
@end
