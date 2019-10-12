//
//  GSE_WalletScanner.m
//  wallet
//
//  Created by user on 03/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletScanner.h"

#import "GSE_QRScanView.h"

@interface GSE_WalletScanner ()<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign) BOOL isQRCodeCaptured;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMetadataOutput *metaData;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewViewLayer;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation GSE_WalletScanner

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = NSLocalizedString(@"QRCode Scan", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *preview = [[UIView alloc] initWithFrame:self.view.bounds];
    preview.backgroundColor = [UIColor blackColor];
    //preview.hidden = YES;
    [self.contentView addSubview:preview];
    self.previewView = preview;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scanWidth = 265.0f;
    
    self.scanRect = CGRectMake( ( width - scanWidth ) / 2 + 1 , 80 + 1, scanWidth - 2, scanWidth - 2);
    GSE_QRScanView *scanView = [[GSE_QRScanView alloc] initWithScanRect:self.scanRect];
    [preview addSubview:scanView];
    
    {
        CGRect frame = CGRectMake( ( width - scanWidth ) / 2 , 80, scanWidth, scanWidth);
        UIImage *image = [UIImage imageNamed:@"qr_camera"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = frame;
        [preview addSubview:imageView];
    }
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"Put the QR code in the middle of the camara",nil);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        [label sizeToFit];
        label.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 + 114);
        [preview addSubview:label];
    }
    
    self.indicatorView = ({
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = CGPointMake(preview.bounds.size.width / 2, self.scanRect.origin.y + self.scanRect.size.height / 2);
        [indicator setHidesWhenStopped:YES];
        [preview addSubview:indicator];
        [indicator startAnimating];
        indicator;
    });
    
    [self setup];
}

- (void)setup {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    [self setupCapture];
                } else {
                    NSLog(@"%@", @"访问受限");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self goCameraSettings];
                    });
                }
            }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized: {
            [self setupCapture];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self goCameraSettings];
            });
            
            break;
        }
            
        default: {
            break;
        }
    }
}

- (void)goCameraSettings{
    
    NSString *title = NSLocalizedString(@"Allow \"Hupai\" to Access the Camera", nil);
    NSString *message = NSLocalizedString(@"Hupai would like to access your camera, tap Settings to allow access, then you can scan the QR code.", nil);
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title  message: message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@" Settings ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupCapture {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.session) {
            self.session =  [[AVCaptureSession alloc] init];
        }
        
        AVCaptureSession *session = self.session;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (deviceInput && !session.inputs.count) {
            
            [session addInput:deviceInput];
            
            AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
            self.previewViewLayer = previewLayer;
            
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            previewLayer.frame = self.view.frame;
            [self.previewView.layer insertSublayer:previewLayer atIndex:0];
            
            AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
            self.metaData =  metadataOutput;
            
            [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(0, 0)];
            
            [session addOutput:metadataOutput]; // 这行代码要在设置 metadataObjectTypes 前
            
            metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            
            CGRect cropRect = self.scanRect;
            CGFloat height = [UIScreen mainScreen].bounds.size.height;
            CGSize size = self.view.bounds.size;
            metadataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/height,
                                                       cropRect.origin.x/size.width,
                                                       cropRect.size.height/size.height,
                                                       cropRect.size.width/size.width);
            
            [session startRunning];
            
            [self.indicatorView stopAnimating];
            
        } else {
            NSLog(@"%@", error);
        }
    });
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (self.isQRCodeCaptured) {
        return;
    }
    
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode] && !self.isQRCodeCaptured) {
        self.isQRCodeCaptured = YES;
        
        //[self showAlertViewWithMessage:metadataObject.stringValue];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf qrCodeHandleAction: metadataObject.stringValue];
        });
    }
}

#pragma mark - action

- (void)qrCodeHandleAction:(NSString *)string{
    NSLog(@"%@",string);
    if (!string) {
        self.isQRCodeCaptured = NO;
        return;
    }
    [self.indicatorView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.finish) {
            self.finish(string);
        }
        [self.indicatorView stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
