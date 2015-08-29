//
//  EELogInViewController.m
//  VkClient
//
//  Created by админ on 16.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EELogInViewController.h"
#import "EEVkClientManager.h"

@interface EELogInViewController()

@property (strong, nonatomic) EEVkClientManager* manager;
@end
@implementation EELogInViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentOauthControllerSegueIdrntifier"]) {
        ((EEOauthWebViewController*)segue.destinationViewController).delegate = self;
    }
}

#pragma mark protocolmethods
-(void)webViewController: (EEOauthWebViewController*)viewController didSuccessWithToken:(NSString*)token {

    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"showVebViewControllerSegueIndentifier" sender:self];
    self.manager = [EEVkClientManager sharedModel];
    self.manager.token = token;
    
}
-(void)webViewController:(EEOauthWebViewController*)viewController didFailLoadWithError:(NSError*)error {
    UIAlertView* message;
    message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you didn't log in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
    
}
@end
