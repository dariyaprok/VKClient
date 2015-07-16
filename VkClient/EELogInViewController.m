//
//  EELogInViewController.m
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EELogInViewController.h"

@interface EELogInViewController()

@property NSString* userToken;

@end
@implementation EELogInViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentOauthControllerSegueIdrntifier"]) {
        ((EEOauthWebViewController*)segue.destinationViewController).delegate = self;
    }
}

#pragma mark protocolmethods
-(void)webViewController: (EEOauthWebViewController*)viewController didSuccessWithToken:(NSString*)token {
    self.userToken = token;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"showVebViewControllerSegueIndentifier" sender:self];
    
}
-(void)webViewController:(EEOauthWebViewController*)viewController didFailLoadWithError:(NSError*)error {
    UIAlertView* message;
    message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you didn't log in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
    
}

@end
