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

@interface MainViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    self.tableView.vmCreate(^(QSPTableViewVM *vm){
        vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            @strongify(self);
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    @strongify(self);
                    [self.navigationController pushViewController:[ScanningViewController create:^(ScanningVM *scanningVM) {
                        scanningVM.titleSet(@"扫一扫").rectOfInterestSet(NO);
                    }] animated:YES];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"扫一扫").detailSet(@"不设置rectOfInterest");
                });
            });
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    @strongify(self);
                    [self.navigationController pushViewController:[ScanningViewController create:^(ScanningVM *scanningVM) {
                        scanningVM.titleSet(@"扫一扫").rectOfInterestSet(YES);
                    }] animated:YES];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"扫一扫").detailSet(@"设置rectOfInterest");
                });
            });
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    @strongify(self);
                    UIImagePickerController *controller = controller = [[UIImagePickerController alloc] init];
                    controller.delegate = self;
                    controller.navigationBar.tintColor = [UIColor blackColor];
                    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:controller animated:YES completion:nil];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(@"识别图片").detailSet(@"CIDetector");
                    });
            });
        });
    });
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{// 创建探测器 CIDetectorTypeQRCode
        CIDetector *detector = [CIDetector detectorOfType: CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        // 取出选中的图片
        UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
        
        // 设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:[self imageSizeWithScreenImage:pickImage].CGImage]];
        
        // 判断是否有数据（即是否是二维码）
        NSString *scannedResult = nil;
        if (features.count > 0) {
            // 取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            scannedResult = feature.messageString ? feature.messageString : nil;
        }
        
        UIAlertController *nextCtr = [UIAlertController alertControllerWithTitle:@"识别结果" message:scannedResult ? scannedResult : @"未识别图片中的二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [nextCtr addAction:okAction];
        [self presentViewController:nextCtr animated:YES completion:nil];
    }];
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
