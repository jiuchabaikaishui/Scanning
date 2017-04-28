//
//  ViewController.m
//  Scanning
//
//  Created by 綦 on 17/3/31.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanningViewController.h"

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

@end

@implementation ViewController

- (IBAction)scanningButtonAction:(UIButton *)sender {
    ScanningViewController *nextCtr = [[ScanningViewController alloc] init];
    nextCtr.title = @"扫一扫";
    [self.navigationController pushViewController:nextCtr animated:YES];
}

@end
