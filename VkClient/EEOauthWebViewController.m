//
//  ViewController.m
//  VkClient
//
//  Created by админ on 06.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEOauthWebViewController.h"
#import "EEMainViewController.h"
#import "EELogInViewController.h"

@interface EEOauthWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;


@end

@implementation EEOauthWebViewController
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
        NSString* token = [[request.URL absoluteString] substringWithRange:tokenRange];
        if ([self.delegate respondsToSelector:@selector(webViewController:didSuccessWithToken:)]) {
            [self.delegate webViewController:self didSuccessWithToken:token];
        }
        
    }
    return YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(webViewController:didFailLoadWithError:)]) {
    [self.delegate webViewController:self didFailLoadWithError:error];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
