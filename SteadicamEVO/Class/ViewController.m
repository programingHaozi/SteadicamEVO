//
//  ViewController.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/3/6.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        if (granted) {
            NSLog(@"=====用户允许使用相机=====");
        }else{
            NSLog(@"=====用户不允许使用相机=====");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
