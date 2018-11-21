//
//  ViewController.m
//  Scanning
//
//  Created by 綦 on 17/3/31.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanningViewController.h"
#import "ZXScanningViewController.h"
#import "ZBarSDK.h"
#import "UIImage+Recognition.h"
#import "ZXingObjC.h"

@interface MainViewController () <UINavigationControllerDelegate, ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - 属性方法
- (MainVM *)mainVM {
    return (MainVM *)super.vm;
}

#pragma mark - 控制器周期
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder andVM:[[MainVM alloc] init]]) {
        
    }
    
    return self;
}
- (instancetype)init {
    if (self = [super initWithVM:[[MainVM alloc] init]]) {
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    [self bindVM];
}

#pragma mark - 自定义方法
- (void)settingUI {
    
}
- (void)bindVM {
    self.tableView.vmSet(self.mainVM.tableViewVM);
    @weakify(self);
    [self.mainVM.tableViewVM.didSelectRowSignal subscribeNext:^(QSPTableViewAndIndexPath *x) {
        @strongify(self);
        MainTableVIewCellVM *cellVM = [x.tableView.vm rowVMWithIndexPath:x.indexPath];
        if ([cellVM.nextVM isKindOfClass:NativeScanningVM.class]) {
            [self.navigationController pushViewController:[ScanningViewController controllerWithVM:cellVM.nextVM] animated:YES];
        } else if ([cellVM.nextVM isKindOfClass:ZXScanningVM.class]) {
            [self.navigationController pushViewController:[ZXScanningViewController controllerWithVM:cellVM.nextVM] animated:YES];
        } else if ([cellVM.nextVM isKindOfClass:ZBarScanningVM.class]) {
            //初始化扫描二维码控制器
            ZBarReaderViewController *reader = [ZBarReaderViewController new];
            //设置代理
            reader.readerDelegate = self;
            //基本适配
            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            //二维码/条形码识别设置
            ZBarImageScanner *scanner = reader.scanner;
            [scanner setSymbology: ZBAR_I25
                           config: ZBAR_CFG_ENABLE
                               to: 0];
            //弹出系统照相机，全屏拍摄
            [self presentViewController:reader animated:YES completion:nil];
        } else if ([cellVM.nextVM isKindOfClass:ImagePickerVM.class]) {
            ImagePickerVM *imagePickerVM = (ImagePickerVM *)cellVM.nextVM;
            self.mainVM.currentImagePickerType = imagePickerVM.type;
            if (imagePickerVM.type == ImagePickerVMTypeZBarSDK) {
                ZBarReaderController *imagePicker = [ZBarReaderController new];
                imagePicker.showsHelpOnFail = NO; // 禁止显示读取失败页面
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            } else {
                UIImagePickerController *controller = controller = [[UIImagePickerController alloc] init];
                controller.delegate = self;
                controller.allowsEditing = NO;
                controller.navigationBar.tintColor = [UIColor blackColor];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    switch (self.mainVM.currentImagePickerType) {
        case ImagePickerVMTypeCIDetector:
            {
                // 取出选中的图片
                UIImage *pickImage = info[UIImagePickerControllerEditedImage];
                if (!pickImage) {
                    pickImage = info[UIImagePickerControllerOriginalImage];
                }
                
                [pickImage QRRecognite:^(NSString *codeStr) {
                    [picker dismissViewControllerAnimated:YES completion:^{
                        UIAlertController *nextCtr = [UIAlertController alertControllerWithTitle:@"识别结果" message:codeStr ? codeStr : @"未识别图片中的二维码" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [nextCtr addAction:okAction];
                        [self presentViewController:nextCtr animated:YES completion:nil];
                    }];
                }];
            }
            break;
        case ImagePickerVMTypeZXingSDK:
        {
            // 取出选中的图片
            UIImage *pickImage = info[UIImagePickerControllerEditedImage];
            if (!pickImage) {
                pickImage = info[UIImagePickerControllerOriginalImage];
            }
            
            ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:pickImage.CGImage];
            ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
            
            NSError *error = nil;
            
            ZXDecodeHints *hints = [ZXDecodeHints hints];
            
            ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
            ZXResult *result = [reader decode:bitmap hints:hints error:&error];
            
            
            [picker dismissViewControllerAnimated:YES completion:^{
                UIAlertController *nextCtr = [UIAlertController alertControllerWithTitle:@"识别结果" message:result && result.text ? result.text : @"未识别图片中的二维码" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [nextCtr addAction:okAction];
                [self presentViewController:nextCtr animated:YES completion:nil];
            }];
        }
            break;
        case ImagePickerVMTypeZBarSDK:
        {
            id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
            
            ZBarSymbol *symbol = nil;
            
            for(symbol in results) {
                
                break;
            }
            
            //二维码字符串
            NSString *QRCodeString =  symbol.data;
            
            [picker dismissViewControllerAnimated:YES completion:^{
                UIAlertController *nextCtr = [UIAlertController alertControllerWithTitle:@"识别结果" message:QRCodeString ? QRCodeString : @"未识别图片中的二维码" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [nextCtr addAction:okAction];
                [self presentViewController:nextCtr animated:YES completion:nil];
            }];
        }
            break;
            
        default:
            break;
    }
}
- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry {
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
