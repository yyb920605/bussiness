//
//  position.m
//  地图地图
//
//  Created by yyb on 14-10-24.
//  Copyright (c) 2014年 yyb. All rights reserved.
//

#import "Position.h"

@implementation Position
-(id)initWithBranchId:(NSString *)bi andLatit:(double)la andLongit:(double)lg andCompanyDescription:(NSString *)cd andCompanyContact:(NSString *)cc andCompanyPhone:(NSString *)cp andCompanyImage:(NSString *)ci andCompanyName:(NSString *)cn andCompanyAddress:(NSString *)ca{
    
    self=[super init];
    self.companyName=cn;
    self.latit=la;
    self.longit=lg;
    self.branchId=bi;
    self.companyDescription=cd;
    self.companyContact=cc;
    self.companyPhone=cp;
    self.companyImage=ci;
    self.companyAddress=ca;
    return self;

}
@end
