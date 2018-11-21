//
//  ZXScanningViewController.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/21.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "ZXScanningViewController.h"
#import "ZXingObjC.h"

@interface ZXScanningViewController () <ZXCaptureDelegate>

@property (strong, nonatomic) ZXCapture *capture;

@end

@implementation ZXScanningViewController

#pragma mark - 属性方法
- (ZXScanningVM *)scanningVM {
    return (ZXScanningVM *)super.vm;
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    [self bindVM];
}

#pragma mark - 自定义方法
- (void)settingUI {
    self.capture = [[ZXCapture alloc]init];
    self.capture.camera = self.capture.back;
    //自动聚焦
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.layer.frame = CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64);
    [self.view.layer addSublayer:self.capture.layer];
    
    self.capture.delegate = self;
}
- (void)bindVM {
    
}

#pragma mark - <ZXCaptureDelegate>代理方法
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (result.text) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self.capture stop];
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"结果" message:result.text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.capture start];
        }];
        [alertCtr addAction:cancelAction];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertCtr addAction:ensureAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
}
//- (void)captureSize:(ZXCapture *)capture
//              width:(NSNumber *)width
//             height:(NSNumber *)height;
//
//- (void)captureCameraIsReady:(ZXCapture *)capture;

@end
