//
//  ImagePickerVM.h
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/16.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "BaseViewControllerVM.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ImagePickerVMType) {
    ImagePickerVMTypeCIDetector = 0,
    ImagePickerVMTypeZXingSDK = 1,
    ImagePickerVMTypeZBarSDK = 2
};
@interface ImagePickerVM : BaseViewControllerVM <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (assign, nonatomic, readonly) ImagePickerVMType type;

+ (instancetype)create;
- (ImagePickerVM * (^)(ImagePickerVMType))typeSet;

@end

NS_ASSUME_NONNULL_END
