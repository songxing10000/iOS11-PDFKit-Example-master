//
//  NSObject+Ext.m
//  PDF-Demo
//
//  Created by dfpo on 2022/5/26.
//  Copyright © 2022 com.tzshlyt.demo. All rights reserved.
//

#import "NSObject+Ext.h"
#import <objc/message.h>
#import <UIKit/UIViewController.h>

@implementation NSObject (Ext)
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
     
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [UIViewController attemptRotationToDeviceOrientation];
}
@end
