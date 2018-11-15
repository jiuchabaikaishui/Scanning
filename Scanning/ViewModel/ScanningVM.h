//
//  ScanningVM.h
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/15.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "BaseVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanningVM : BaseVM

@property (copy, nonatomic, copy) NSString *title;
@property (assign, nonatomic, readonly) BOOL rectOfInterest;

+ (instancetype)create;
- (ScanningVM * (^)(BOOL))rectOfInterestSet;
- (ScanningVM * (^)(NSString *))titleSet;

@end

NS_ASSUME_NONNULL_END
