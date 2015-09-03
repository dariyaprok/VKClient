//
//  ViewController.m
//  VkClient
//
//  Created by админ on 06.07.15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEOauthWebViewController.h"
#import "EETableViewController.h"
#import "EELogInViewController.h"

@interface EEOauthWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *oauthWebView;
@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator1;
@end

@implementation EEOauthWebViewController
static NSString* const autorizeUrlString = @"https://oauth.vk.com/authorize?client_id=4985115&redirect_uri=https://vk.com/feed&scope=8192&display=mobile&response_type=token";


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self.view addSubview: self.activityIndicator1];
    //[self.activityIndicator1 startAnimating];
    
    
    //[self.activityIndicator1 stopAnimating];
    NSURL* urlToLogin = [NSURL URLWithString:autorizeUrlString];
    NSURLRequest* requestToLogin = [NSURLRequest requestWithURL:urlToLogin];
    [self.oauthWebView loadRequest:requestToLogin];
    //    if([self.oauthWebView isLoading]){
    //        [self.activityIndicator1 stopAnimating];
    //    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIActivityIndicatorView *)activityIndicator1 {
    if (_activityIndicator1 == nil) {
        _activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator1.frame=CGRectMake(0.0,0.0, 40.0, 40.0);
        _activityIndicator1.center=self.view.center;
    }
    return _activityIndicator1;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    if([self.activityIndicator1 isAnimating]) {
    //        [self.activityIndicator1 stopAnimating];
    //    }
    [self.activityIndicator1 startAnimating];
    if([[request.URL absoluteString] containsString:@"access_token="]) {
        // [self.activityIndicator1 stopAnimating];
       // NSRange tokenRange;
        NSArray* arrayOfData = [request.URL.absoluteString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        //tokenRange.location = NSMaxRange([[request.URL absoluteString] rangeOfString:@"access_token="]);
        //tokenRange.length = [[request.URL absoluteString] rangeOfString:@"&expires_in"].location - tokenRange.location;
        //NSString* token = [[request.URL absoluteString] substringWithRange:tokenRange];
        NSString* token = arrayOfData[1];
        NSString* userId = arrayOfData[5];
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.delegate respondsToSelector:@selector(EEWebInOauthViewControllerDelegate:didSuccessWithToken:andId:)]) {
            [self.delegate EEWebInOauthViewControllerDelegate:self didSuccessWithToken:token andId:userId];
        }
        
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator1 stopAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(EEWebInOauthViewControllerDelegate:didFailLoadWithError:)]) {
        [self.delegate EEWebInOauthViewControllerDelegate:self didFailLoadWithError:error];
    }
}


@end
