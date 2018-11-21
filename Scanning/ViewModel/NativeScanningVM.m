//
//  ScanningVM.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/15.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "NativeScanningVM.h"

@implementation NativeScanningVM

+ (instancetype)create {
    return [[self alloc] init];
}
- (NativeScanningVM * (^)(BOOL))rectOfInterestSet {
    return ^(BOOL rectOfInterest) {
        _rectOfInterest = rectOfInterest;
        
        return self;
    };
}

@end
