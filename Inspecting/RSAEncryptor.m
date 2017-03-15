//
//  RSAEncryptor.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/14.
//  Copyright © 2017年 default. All rights reserved.
//

#import "RSAEncryptor.h"
#import "RSAEncrypt.h"

@implementation RSAEncryptor

+ (RSAEncryptor *)shareInstance {
    static dispatch_once_t onceToken;
    static RSAEncryptor *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[RSAEncryptor alloc] init];
        instance.publicKey = [RSAEncrypt  PublicKeyStringFromFile:@"public_ios"];
    });
    return instance;
}

- (NSString *)encryptString:(NSString *)str {
    return [RSAEncrypt RSAEncrypt:str publicKey:self.publicKey];
}

- (NSString *)encryptString:(NSString *)str withPadding:(SecPadding)padding {
    return [RSAEncrypt RSAEncrypt:str publicKey:self.publicKey secPadding:padding];
}

@end
