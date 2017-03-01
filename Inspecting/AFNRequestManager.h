//
//  AFNRequestManager.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/22.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

// server
#define BASE_URL @"http://120.24.159.160:9500/xunjian/appapi/"
// image server
#define IMG_URL @"http://120.24.159.160:9500/xunjian/appapi/"

#pragma mark - networking request type
enum HTTP_METHOD {
    METHOD_GET = 0,
    METHOD_POST = 1
};


@interface AFNRequestManager : NSObject

/**
 class function

 @return AFNReequestManager instance
 */
+ (AFNRequestManager *)sharedUtil;


/**
 IOS's networking request

 @param urlString server
 @param method type
 @param params parameters
 @param block block
 */
+ (void)requestURL:(NSString *)urlString httpMethod:(NSString *)method params:(NSMutableDictionary *)params completation:(void(^)(id result))block;


/**
 AFNetworking request

 @param urlString server
 @param method get or post
 @param params parameters
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString httpMethod:(NSInteger)method params:(id)params succeed:(void(^)(id))succeed failure:(void(^)(NSError*))failure;


/**
 upload a single image

 @param urlString server
 @param params parameters
 @param imageData image data
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString params:(id)params imageData:(NSData *)imageData succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure;


/**
 update multiple images

 @param urlString server
 @param params parameters
 @param imageDataArray image data array
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString params:(id)params imageDataArray:(NSArray *)imageDataArray succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure;

/**
 upload a single file

 @param urlString server
 @param params parameters
 @param fileData file data
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString params:(id)params fileData:(NSData *)fileData succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure;

/**
 convert json string to NSDictionary

 @param jsonString json string
 @return json dictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 convert json dictioinary to json string

 @param paramDict json dictionary
 @param _type <#_type description#>
 @return json string
 */
+ (NSString *)URLEncryOrDecryString:(NSDictionary *)paramDict isHead:(BOOL)_type;
@end
