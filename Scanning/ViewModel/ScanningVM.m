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
- (ScanningVM * (^)(NSString *))titleSet {
    return ^(NSString *title) {
        _title = title;
        
        return self;
    };
}
- (ScanningVM * (^)(BOOL))rectOfInterestSet {
    return ^(BOOL rectOfInterest) {
        _rectOfInterest = rectOfInterest;
        
        return self;
    };
}

@end
