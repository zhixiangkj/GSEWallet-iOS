//
//  GSE_WebViewController.m
//  GSEWallet
//
//  Created by 付金亮 on 2018/11/22.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WebViewController.h"
#import <WebKit/WKWebView.h>
@interface GSE_WebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) UIView *noPageView;
@property (weak, nonatomic) IBOutlet UILabel *pageNoFoundLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation GSE_WebViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *wkWV = (WKWebView *)self.webView;
    wkWV.frame = CGRectMake(0, -STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + STATUS_BAR_HEIGHT);
    wkWV.scrollView.bounces = NO;
    wkWV.navigationDelegate = self;
    wkWV.UIDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)handleCloseButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)handkeRefreshButtonTapped:(id)sender {
    self.pageNoFoundLabel.alpha = 0;
    self.activityIndicatorView.alpha = 1;
    [self.activityIndicatorView startAnimating];
    WKWebView *wkWV = (WKWebView *)self.webView;
    if (wkWV.URL != nil) {
        [wkWV reload];
    } else {
        [wkWV reloadFromOrigin];
    }
}
#pragma mark // TODO: 关于页面没找到，存在bug 后续解决
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"1");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"2");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"3");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"4");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"5");
}
// 网页加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"website load fail");
    self.noPageView = [[NSBundle mainBundle] loadNibNamed: @"WebPageNotFoundView" owner:self options:nil].lastObject;
    self.activityIndicatorView.alpha = 0;
    [self.activityIndicatorView stopAnimating];
    self.pageNoFoundLabel.alpha = 1;
    [self.view addSubview:self.noPageView];
}
#pragma mark - WKUIDelegate
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
