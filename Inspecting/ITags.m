//
//  ITags.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/10/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITags.h"

@implementation ITags


- (id)init {
    self = [super init];
    if (self) {
        _tags = [[NSMutableArray alloc]init];
        _tagsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (ITags *)getInstance {
    static dispatch_once_t onceToken;
    static ITags *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ITags alloc] init];
    });
    return instance;
}

- (void)setTags:(NSMutableArray *)tags {
    _tags = tags;
    [_tagsArray removeAllObjects];
    for (NSDictionary *dict in _tags) {
        [_tagsArray addObject:[dict objectForKey:@"name"]];
    }
}

- (NSMutableArray *)getTagsArray {
    return self.tagsArray;
}

- (NSMutableArray *)getSelectedTagsByCodes:(NSString *)codes {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSArray *codeArray = [codes componentsSeparatedByString:@"|"];
    for (NSString *code in codeArray) {
        for (NSDictionary *dict in _tags) {
            if ([code compare:[dict objectForKey:@"code"]] == NSOrderedSame) {
                [result addObject:[dict objectForKey:@"name"]];
            }
        }
    }
    return result;
}

- (NSString *)getCodesBySelectedTags:(NSMutableArray *)selectedTags {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in _tags) {
        for (NSString *tag in selectedTags) {
            if ([tag compare:[dict objectForKey:@"name"]] == NSOrderedSame) {
                [result addObject:[dict objectForKey:@"code"]];
                break;
            }
        }
    }
    return [result componentsJoinedByString:@"|"];
}
@end
