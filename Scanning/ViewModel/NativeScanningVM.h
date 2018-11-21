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

@property (assign, nonatomic, readonly) BOOL rectOfInterest;

+ (instancetype)create;
- (NativeScanningVM * (^)(BOOL))rectOfInterestSet;

@end

NS_ASSUME_NONNULL_END
