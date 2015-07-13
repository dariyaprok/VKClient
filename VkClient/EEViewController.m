//
//  ViewController.m
//  VkClient
//
//  Created by админ on 06.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEViewController.h"
#import "EEMainViewController.h"

@interface EEViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (nonatomic, retain) NSString* token;


@end

@implementation EEViewController
static NSString* const autorizeUrlString = @"https://oauth.vk.com/authorize?client_id=4985115&redirect_uri=https://vk.com/feed&scope=129&display=mobile&response_type=token";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* urlToLogin = [NSURL URLWithString:autorizeUrlString];
    NSURLRequest* requestToLogin = [NSURLRequest requestWithURL:urlToLogin];
    [self.mainWebView loadRequest:requestToLogin];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([[request.URL absoluteString] containsString:@"access_token="]) {
        NSRange tokenRange;
        
        tokenRange.location = NSMaxRange([[request.URL absoluteString] rangeOfString:@"access_token="]);
        tokenRange.length = [[request.URL absoluteString] rangeOfString:@"&expires_in"].location - tokenRange.location;
        self.token = [[request.URL absoluteString] substringWithRange:tokenRange];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"pushAction" sender:self];
    }
    return YES;
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView* message;
    message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you didn't log in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
}

/*- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"dff");
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
