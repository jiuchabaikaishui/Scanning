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
@property (weak, nonatomic) AVCaptureDeviceInput *input;
@property (weak, nonatomic) AVCaptureMetadataOutput *output;
@property (weak, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ScanningViewController

#pragma mark - 属性方法
- (NativeScanningVM *)scanningVM {
    return (NativeScanningVM *)super.vm;
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    [self bindVM];
}

#pragma mark - 自定义方法
- (void)settingUI {
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
}
- (void)bindVM {
    self.title = self.scanningVM.title;
    
    if (self.scanningVM.cameraAuto) {
        [self.input.device lockForConfiguration:nil];
        //自动白平衡
        if ([self.input.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
        {
            [self.input.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //先进行判断是否支持控制对焦,不开启自动对焦功能，很难识别二维码。
        if (self.input.device.isFocusPointOfInterestSupported &&[self.input.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            [self.input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([self.input.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
        {
            [self.input.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        [self.input.device unlockForConfiguration];
    }
    
    if (self.scanningVM.cameraPushAndPull) {
        //添加捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [self.view addGestureRecognizer:pinch];
    }
}

- (void)loadScanView{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
//    //监听相机自动对焦
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:device];
//
//    [session beginConfiguration];
//    [device lockForConfiguration:nil];
//    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//        [device setFocusMode:AVCaptureFocusModeAutoFocus];
//    }
//    device.flashMode = AVCaptureFlashModeAuto;
//    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
//        device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
//    }
//    [device unlockForConfiguration];
//    [session commitConfiguration];
    
    //配置AVCaptureDeviceInput
    NSError *error = NULL;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    self.input = input;
    
    //配置AVCaptureMetadataOutput
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    DebugLog(@"%@", NSStringFromCGRect(output.rectOfInterest));
    if (self.scanningVM.rectOfInterest) {
        CGFloat margin = self.view.frame.size.width/6.0;
        CGFloat X = margin;
        CGFloat W = margin*4;
        CGFloat H = W;
        CGFloat Y = (self.view.frame.size.height - H)/2;
        output.rectOfInterest = CGRectMake(Y/self.view.frame.size.height, X/self.view.frame.size.width, H/self.view.frame.size.height, W/self.view.frame.size.width);
        DebugLog(@"%@", NSStringFromCGRect(output.rectOfInterest));
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    self.output = output;
    
    //配置AVCaptureStillImageOutput
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [stillImageOutput setOutputSettings:outputSettings];
    if ([session canAddOutput:stillImageOutput])
    {
        [session addOutput:stillImageOutput];
    }
    self.stillImageOutput = stillImageOutput;
    
    //配置AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:previewLayer];
    self.previewLayer = previewLayer;
    
    [session startRunning];
    self.session = session;
    
    //设置阴影视图
    ShadowView *view = [[ShadowView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    self.shadowView = view;
}

- (void)pinchAction:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
//        DebugLog(@"----%f----", sender.scale);
//        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//        DebugLog(@"++++%f++++", connection.videoMaxScaleAndCropFactor);
//        DebugLog(@"****%f****", connection.videoScaleAndCropFactor);
//
//        CGFloat scale = connection.videoScaleAndCropFactor*sender.scale;
//        if (scale >= 1 && scale <= connection.videoMaxScaleAndCropFactor) {
//            [self.input.device lockForConfiguration:nil];
//
//            connection.videoScaleAndCropFactor = scale;
//
//            [self.input.device unlockForConfiguration];
//
//            //隐式动画
//            //1.开启事务
//            [CATransaction begin];
//            //2.设置不执行动画的属性
//            [CATransaction setDisableActions:YES];
//            //3.把动画属性放在中间
//            self.previewLayer.affineTransform = CGAffineTransformScale(self.previewLayer.affineTransform, sender.scale, sender.scale);
//            //4.提交事务
//            [CATransaction commit];
//        }
        CGFloat min = 1;
        if (@available(iOS 11.0, *)) {
            min = self.input.device.minAvailableVideoZoomFactor;
        }
        CGFloat max = self.input.device.activeFormat.videoMaxZoomFactor;
        if (@available(iOS 11.0, *)) {
            max = self.input.device.maxAvailableVideoZoomFactor;
        }
        DebugLog(@"----------------\nmin:%f\nmax:%f\ncurrent:%f", min, max, self.input.device.videoZoomFactor);
        CGFloat scale = self.input.device.videoZoomFactor*sender.scale;
        if (scale >= min && scale <= max && [self.input.device lockForConfiguration:nil]) {
            self.input.device.videoZoomFactor = scale;
            [self.input.device unlockForConfiguration];
        }
    }
    sender.scale = 1;
}

- (void)subjectAreaDidChange:(NSNotification *)sender {
    DebugLog(@"%s", __FUNCTION__);
//    AVCaptureDevice *device = sender.object;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    DebugLog(@"%s", __FUNCTION__);
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *object = metadataObjects[0];
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"结果" message:object.stringValue preferredStyle:UIAlertControllerStyleAlert];
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
