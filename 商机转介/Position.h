//
//  position.h
//  地图地图
//
//  Created by yyb on 14-10-24.
//  Copyright (c) 2014年 yyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject
@property (retain,nonatomic) NSString *branchId;//分店id
@property (retain,nonatomic) NSString *companyName;//分店名字
@property (assign,nonatomic) double latit;//分店纬度
@property (assign,nonatomic) double longit;//分店经度
@property (retain,nonatomic) NSString *companyDescription;//分店描述
@property (retain,nonatomic) NSString *companyContact;//分店联系
@property (retain,nonatomic) NSString *companyPhone;//分店电话
@property (retain,nonatomic) NSString *companyImage;//分店图片
@property (retain,nonatomic) NSString *companyAddress;//分店地址

-(id)initWithBranchId:(NSString *)bi andLatit:(double)la andLongit:(double)lg
andCompanyDescription:(NSString *)cd andCompanyContact:(NSString *)cc andCompanyPhone:(NSString *)cp andCompanyImage:(NSString *)ci andCompanyName:(NSString *)cn andCompanyAddress:(NSString *)ca;
@end
