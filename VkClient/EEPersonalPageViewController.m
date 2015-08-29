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
    self.positionOfFriend = position;
}

-(void)viewDidLoad {
    NSArray* arrayOfData = [self.manager.dataAboutFriends[(int)self.positionOfFriend] componentsSeparatedByString:@","];
    self.firstNameLabel.text = arrayOfData[0];
    self.lastNameLabel.text = arrayOfData[1];
    if(![arrayOfData[5] isEqualToString:@"(null)"]) {
    self.bDayDateLabel.text = [self stringOfBdayDate:arrayOfData[5]];
    }
    else {
        self.bDayDateLabel.text = nil;
        self.bDayDateStandartTextLabel.text = nil;
    }
    [self.avatarImage hnk_setImageFromURL:[NSURL URLWithString:arrayOfData[2]]];
        if([arrayOfData[4] isEqual:@"1"]) {
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
