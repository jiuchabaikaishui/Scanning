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
#import "ZBarSDK.h"

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
        if ([cellVM.nextVM isKindOfClass:ScanningVM.class]) {
            [self.navigationController pushViewController:[ScanningViewController controllerWithVM:cellVM.nextVM] animated:YES];
        } else if ([cellVM.nextVM isKindOfClass:ImagePickerVM.class]) {
            ImagePickerVM *imagePickerVM = (ImagePickerVM *)cellVM.nextVM;
            switch (imagePickerVM.type) {
                case ImagePickerVMTypeCIDetector:
                {
                    UIImagePickerController *controller = controller = [[UIImagePickerController alloc] init];
                    controller.delegate = self;
                    controller.navigationBar.tintColor = [UIColor blackColor];
                    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:controller animated:YES completion:nil];
                }
                    break;
                case ImagePickerVMTypeZBarSDK:
                {
                    ZBarReaderController *imagePicker = [ZBarReaderController new];
                    
                    imagePicker.showsHelpOnFail = NO; // 禁止显示读取失败页面
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *QRCodeString = nil;
    if ([picker isKindOfClass:ZBarReaderController.class]) {
        id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
        
        ZBarSymbol *symbol = nil;
        
        for(symbol in results) {
            
            break;
        }
        
        //二维码字符串
        QRCodeString =  symbol.data;
    } else {
        // 创建探测器 CIDetectorTypeQRCode
        CIDetector *detector = [CIDetector detectorOfType: CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
        
        // 取出选中的图片
        UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
        
        // 设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:[self imageSizeWithScreenImage:pickImage].CGImage]];
        
        // 判断是否有数据（即是否是二维码）
        if (features.count > 0) {
            // 取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            QRCodeString = feature.messageString ? feature.messageString : nil;
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIAlertController *nextCtr = [UIAlertController alertControllerWithTitle:@"识别结果" message:QRCodeString ? QRCodeString : @"未识别图片中的二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [nextCtr addAction:okAction];
        [self presentViewController:nextCtr animated:YES completion:nil];
    }];
}
- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry {
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (screenHeight * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
