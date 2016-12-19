//
//  NSObject+Mutual.m
//  runtime实现字典转模型
//
//  Created by ztf on 16/10/15.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import "NSObject+Mutual.h"
#import <objc/runtime.h>
@implementation NSObject (Mutual)


-(NSDictionary *)toDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
    unsigned int copyIvarListCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &copyIvarListCount);
    for (NSInteger i = 0; i< copyIvarListCount; i ++) {
        Ivar ivar = ivars[i];
        id value = object_getIvar(self, ivar);
        if (value) {
            [dic setObject:value forKey:[[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1]];
        }
    }
    free(ivars);//对应copy关键字
    return dic;
}



-(void)setDic:(NSDictionary *)dic{
    NSArray *keys = dic.allKeys;
    for (NSString *key in keys) {
        NSString *att_key = [@"_" stringByAppendingString:key];
        Ivar ivar = class_getInstanceVariable([self class], [att_key UTF8String]);
        if (ivar) {
            id value = [dic objectForKey:key];
            object_setIvar(self, ivar, value);
        }
    }
}

@end
