//
//  WebViewController.m
//  PrudentialPrototype
//
//  Created by Marco Lau on 17/11/2015.
//  Copyright © 2015 Marco Lau. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // webView config
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    
    // Tableau auth
    NSURL *loginUrl = [NSURL URLWithString:@"https://sso.online.tableau.com/public/prelogin/sendPassword"];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:loginUrl];
    
    // POST
    [requestObj setHTTPMethod:@"POST"];
    NSString *credPath = [[NSBundle mainBundle] pathForResource: @"Cred" ofType: @"plist"];
    NSDictionary *credDict = [NSDictionary dictionaryWithContentsOfFile: credPath];
    NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@", [credDict objectForKey:@"email"], [credDict objectForKey:@"password"]];
    NSData *data = [postString dataUsingEncoding: NSUTF8StringEncoding];
    [requestObj setHTTPBody:data];
    
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if([webView.request.URL.absoluteString isEqual: @"https://10ay.online.tableau.com/#/?:isFromSaml=y"]){
        double delayInSeconds = 0.5;
        dispatch_time_t redirectTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(redirectTime, dispatch_get_main_queue(), ^(void) {
            NSURL *tableauUrl = [NSURL URLWithString:@"https://10ay.online.tableau.com/#/site/iit4prudential/views/AnalyzeSuperstore/Overview"];
            NSMutableURLRequest *redirectRequest = [NSMutableURLRequest requestWithURL:tableauUrl];
            [webView loadRequest:redirectRequest];
        });
    };
}
@end
