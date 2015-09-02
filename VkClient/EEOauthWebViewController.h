//
//  ViewController.h
//  VkClient
//
//  Created by админ on 06.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - EEViewControllerDelegate

@class EEOauthWebViewController;

@protocol EEWebInOauthViewControllerDelegate  <NSObject>
@optional
-(void)EEWebInOauthViewControllerDelegate:(EEOauthWebViewController*)viewController didSuccessWithToken:(NSString*)token;
-(void)EEWebInOauthViewControllerDelegate:(EEOauthWebViewController*)viewController didFailLoadWithError:(NSError*)error;

@end

@interface EEOauthWebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, weak) id <EEWebInOauthViewControllerDelegate> delegate;

@end

