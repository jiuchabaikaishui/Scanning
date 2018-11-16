//
//  ScanningVM.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/15.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "ScanningVM.h"

@implementation ScanningVM

+ (instancetype)create {
    return [[self alloc] init];
}
- (ScanningVM * (^)(BOOL))rectOfInterestSet {
    return ^(BOOL rectOfInterest) {
        _rectOfInterest = rectOfInterest;
        
        return self;
    };
}

@end
