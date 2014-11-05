//
//  TLImage.h
//  TongLian
//
//  Created by mac on 13-9-26.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLImage : NSObject<NSCoding>
@property (nonatomic,strong) NSString *directory;

-(id)initWithPath:(NSString *)path;
-(void)saveToFile:(UIImage *)image ImageName:(NSString *)name photoType:(NSString *)type;
-(NSString *)getFromFile:(NSString *)name;

-(void) encodeWithCoder:(NSCoder *)encoder;
-(id) initWithCoder:(NSCoder *)decoder;

@end
