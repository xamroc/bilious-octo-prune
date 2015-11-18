//
//  WebViewController.m
//  PrudentialPrototype
//
//  Created by Marco Lau on 17/11/2015.
//  Copyright © 2015 Marco Lau. All rights reserved.
//

#import "WebViewController.h"
#import "DKScrollingTabController.h"

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
    [self loadScrollingTab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
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

- (void)loadScrollingTab {
    // Add controller as a child view controller (standard view controller containment)
    DKScrollingTabController *tabController = [[DKScrollingTabController alloc] init];
    [self addChildViewController:tabController];
    [tabController didMoveToParentViewController:self];
    [self.view addSubview:tabController.view];
    
    // Customize the tab controller (more options in DKScrollingTabController.h or check the demo)
    NSLog(@"frame width: %f", self.view.bounds.size.width);
    tabController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    tabController.buttonPadding = 20;
    tabController.selection = @[@"PCA", @"PCA Channel Mix", @"PCA Product Mix", @"LBU APE", @"LU Channel Mix", @"LU Product Mix", @"LU Month Trend", @"LU Month Data"];
    
    // Set the delegate (conforms to DKScrollingTabControllerDelegate)
    tabController.delegate = self;
}

#pragma mark - DKScrollingTabControllerDelegate

- (void)ScrollingTabController:(DKScrollingTabController *)controller selection:(NSUInteger)selection {
    NSLog(@"Selection controller action button with index=%@", @(selection));
}
@end
