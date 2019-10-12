//
//  GSE_WalletWebBrowser.m
//  GSEWallet
//
//  Created by user on 01/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletWebBrowser.h"
#import <WebKit/WebKit.h>

#define webViewEstimatedProgress @"estimatedProgress"
#define progressViewProgress @"progress"
@interface GSE_WalletWebBrowser ()<WKUIDelegate, WKNavigationDelegate>{
    UIActivityIndicatorView * _indicator;
}
@property (nonatomic, assign) BOOL navControllerUsesBackSwipe;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UINavigationItem *navigationBarItem;
@end

@implementation GSE_WalletWebBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Loading...", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];

    if (self.navigationController) {
        self.navControllerUsesBackSwipe = YES;
    }else{
        self.navControllerUsesBackSwipe = NO;
    }
    
    self.webView = ({
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.contentView.bounds];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.translatesAutoresizingMaskIntoConstraints = NO;
        webView.allowsBackForwardNavigationGestures = YES;
        [self.contentView  addSubview:webView];
        self.automaticallyAdjustsScrollViewInsets = NO;
        webView;
    });
    
    {
        UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2.0);
        [self.view addSubview:indicator];
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
        _indicator = indicator;
    }
    
    if (self.image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        imageView.image = self.image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
    }
    
    //[self.webView addObserver:self forKeyPath:webViewEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    
    //[_progress setProgress:0.0f animated:NO];
    
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    if (self.navControllerUsesBackSwipe) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [super viewDidDisappear:animated];
}

- (void)setUrl:(NSURL *)url{
    _url = url;
    if (self.isViewLoaded) {
        if (url) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
}

- (void)back{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.modal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    if (!navigationAction.targetFrame) {

        if (navigationAction.request) {
            [webView loadRequest:navigationAction.request];
        }
    }
    
    return nil;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [_indicator stopAnimating];
    
    __weak typeof(self)weakSelf = self;
    
    if (weakSelf.customTitle) {
        weakSelf.title = weakSelf.customTitle;
    }else{
        [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * msg, NSError * _Nullable error) {
            if ([msg isKindOfClass:[NSString class]] && msg.length) {
                weakSelf.title = msg;
            }else{
                weakSelf.title = NSLocalizedString(@"Success", nil);
            }
        }];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if (self.navControllerUsesBackSwipe && webView.allowsBackForwardNavigationGestures) {
        self.navigationController.interactivePopGestureRecognizer.enabled = !webView.canGoBack;
    }
    __weak typeof(self)weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * msg, NSError * _Nullable error) {
        if ([msg isKindOfClass:[NSString class]] && msg.length) {
            //self.title = msg;
            
            weakSelf.navigationBarItem.title = msg;
        }else{
            //self.title = self.customTitle;
            weakSelf.navigationBarItem.title = self.customTitle;
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    //do something here
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    //[[UIApplication sharedApplication] openURL:webView.URL];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s,%@",__func__,webView.URL);
    //[_indicator stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%s,%@,%@",__func__,webView.URL,navigationAction.request.URL);
    if ([navigationAction.request.URL.host hasSuffix:@"itunes.apple.com"] ||
        [navigationAction.request.URL.host hasSuffix:@"appsto.re"] ||
        ![[navigationAction.request.URL.scheme lowercaseString] hasPrefix:@"http"]) {
        
        if (![navigationAction.request.URL.absoluteString.lowercaseString isEqualToString:@"about:blank"]) {
            if ([self.webView.URL isEqual:navigationAction.request.URL] || [self.title isEqualToString:@"正在加载"]) {
                [self.navigationController popViewControllerAnimated:NO];
            }
            
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        }
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%s",__func__);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Grabtalk" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSString *hostName = webView.URL.host;
    
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]) {
        
        NSString *title = @"Authentication Challenge";
        NSString *message = [NSString stringWithFormat:@"%@ requires user name and password", hostName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"User";
            //textField.secureTextEntry = YES;
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Password";
            textField.secureTextEntry = YES;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *userName = ((UITextField *)alertController.textFields[0]).text;
            NSString *password = ((UITextField *)alertController.textFields[1]).text;
            
            NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:userName password:password persistence:NSURLCredentialPersistenceNone];
            
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:^{}];
        });
        
    }
    else if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // needs this handling on iOS 9
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        // or, see also http://qiita.com/niwatako/items/9ae602cb173625b4530a#%E3%82%B5%E3%83%B3%E3%83%97%E3%83%AB%E3%82%B3%E3%83%BC%E3%83%89
    }
    else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    
    NSString *hostString = frame.request.URL.host;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:hostString message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        //textField.placeholder = defaultText;
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSString *hostString = frame.request.URL.host;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:hostString message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:webViewEstimatedProgress]) {

    }
}

@end
