//
//  RSAEncryptor.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/14.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject
/**
 公钥字符串
 */
@property (nonatomic, strong) NSString *publicKey;

#pragma mark - Instance Method


/**
 使用ksecNoPadding方式RSA加密

 @param str 源字符串
 @return 加密后的字符串
 */
- (NSString *)encryptString:(NSString *)str;


/**
 使用指定方式的RSA加密

 @param str 源字符串
 @param padding 加密方式
 @return 加密后的字符串
 */
- (NSString *)encryptString:(NSString *)str withPadding:(SecPadding)padding;

#pragma mark - Class Method


/**
 单例模式

 @return 加密方法对象
 */
+ (RSAEncryptor *)shareInstance;

@end
