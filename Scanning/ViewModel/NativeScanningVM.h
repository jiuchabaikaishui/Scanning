//
//  ScanningVM.h
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/15.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "BaseViewControllerVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeScanningVM : BaseViewControllerVM

/**
 扫描区域
 */
@property (assign, nonatomic, readonly) BOOL rectOfInterest;
/**
 相机自动调节，自动白平衡、自动对焦、自动曝光
 */
@property (assign, nonatomic, readonly) BOOL cameraAuto;
/**
 相机推拉
 */
@property (assign, nonatomic, readonly) BOOL cameraPushAndPull;

+ (instancetype)create;
- (NativeScanningVM * (^)(BOOL))rectOfInterestSet;
- (NativeScanningVM * (^)(BOOL))cameraAutoSet;
- (NativeScanningVM * (^)(BOOL))cameraPushAndPullSet;

@end

NS_ASSUME_NONNULL_END
