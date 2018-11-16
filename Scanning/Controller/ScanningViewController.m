//
//  ScanningViewController.m
//  Scanning
//
//  Created by 綦 on 17/3/31.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ShadowView.h"

@interface ScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) ShadowView *shadowView;

@end

@implementation ScanningViewController

#pragma mark - 属性方法
- (ScanningVM *)scanningVM {
    return (ScanningVM *)super.vm;
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    [self bindVM];
}

#pragma mark - 自定义方法
- (void)settingUI {
    //    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied)
    {
        NSLog(@"请授权掌医医护端使用相机服务: 设置 > 隐私 > 相机");
        return;
    }
    else
    {
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            [self loadScanView];
        }
        else
        {
            NSLog(@"该设备无摄像头");
        }
    }
    
    ShadowView *view = [[ShadowView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    self.shadowView = view;
    
    //    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
    //        if (granted) {
    //            [self loadScanView];
    //        }
    //        else
    //        {
    //            NSLog(@"无权限访问相机！");
    //        }
    //    }];
    
    //    [self loadScanView];
}
- (void)bindVM {
    self.title = self.scanningVM.title;
}

- (void)loadScanView{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = NULL;
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    NSLog(@"%@", NSStringFromCGRect(output.rectOfInterest));
    if (self.scanningVM.rectOfInterest) {
        CGFloat margin = self.view.frame.size.width/6.0;
        CGFloat X = margin;
        CGFloat W = margin*4;
        CGFloat H = W;
        CGFloat Y = (self.view.frame.size.height - H)/2;
        output.rectOfInterest = CGRectMake(Y/self.view.frame.size.height, X/self.view.frame.size.width, H/self.view.frame.size.height, W/self.view.frame.size.width);
        NSLog(@"%@", NSStringFromCGRect(output.rectOfInterest));
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    [session startRunning];
    self.session = session;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *object = metadataObjects[0];
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"tishi" message:object.stringValue preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.session startRunning];
        }];
        [alertCtr addAction:cancelAction];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertCtr addAction:ensureAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
}

@end
