//
//  ITags.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/10/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITags : NSObject

+ (ITags *)getInstance;
- (NSMutableArray *)getTagsArray;
- (NSMutableArray *)getSelectedTagsByCodes:(NSString*)codes;
- (NSString *)getCodesBySelectedTags:(NSMutableArray *)selectedTags;
@property (nonatomic, copy) NSMutableArray *tags;
@property (nonatomic, copy) NSMutableArray *tagsArray;
@end
