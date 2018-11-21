//
//  MainVM.h
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/16.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "BaseViewControllerVM.h"
#import "MainTableVIewCellVM.h"
#import "NativeScanningVM.h"
#import "ImagePickerVM.h"
#import "ZBarScanningVM.h"
#import "ZXScanningVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainVM : BaseViewControllerVM

@property (strong, nonatomic, readonly) QSPTableViewVM *tableViewVM;
@property (assign, nonatomic) ImagePickerVMType currentImagePickerType;

@end

NS_ASSUME_NONNULL_END
