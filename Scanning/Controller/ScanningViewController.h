//
//  ScanningViewController.h
//  Scanning
//
//  Created by 綦 on 17/3/31.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanningVM.h"

@interface ScanningViewController : UIViewController

@property (strong, nonatomic) ScanningVM *vm;

+ (instancetype)create:(void (^)(ScanningVM *vm))vmBlock;

@end
