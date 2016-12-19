//
//  NSObject+Mutual.h
//  runtime实现字典转模型
//
//  Created by ztf on 16/10/15.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Mutual)


-(NSDictionary *)toDic;
-(void)setDic:(NSDictionary *)dic;



@end
