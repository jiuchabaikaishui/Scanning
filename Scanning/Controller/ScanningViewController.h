//
//  ScanningViewController.h
//  Scanning
//
//  Created by 綦 on 17/3/31.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "BaseViewController.h"
#import "NativeScanningVM.h"

@interface ScanningViewController : BaseViewController

@property (strong, nonatomic, readonly) NativeScanningVM *scanningVM;

@end
