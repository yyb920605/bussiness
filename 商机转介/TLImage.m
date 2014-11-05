//
//  TLImage.m
//  TongLian
//
//  Created by mac on 13-9-26.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLImage.h"

@implementation TLImage
-(id)initWithPath:(NSString *)path{
    self = [self init];
    _directory = path;
    return self;
}
-(void)saveToFile:(UIImage *)image ImageName:(NSString *)name photoType:(NSString *)type{
    NSData *data;
    CGSize size;
    //如果是资质原件或者复印件宽高比设置
    if([type isEqualToString:@"QUALIFICATION"]||[type isEqualToString:@"QUALIFICATIONCOPY"]){
        
        size = CGSizeMake(1365,1024);
    
    }
    else{
        size = CGSizeMake(1024,1365);
    }
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    float rate = 0.4;
    data = UIImageJPEGRepresentation(scaledImage, rate);
    //照片大小限于190k
    while ([data length]>190000) {
        rate = rate -0.05;
        data = UIImageJPEGRepresentation(scaledImage, rate);
    }
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@.png",self.directory,name];
    NSLog(@"savepath==%@",path);
    //NSLog(@"%l",data.length);
    if([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    if([fileManager createDirectoryAtPath:self.directory withIntermediateDirectories:YES attributes:nil error:&error]){
        if(![data writeToFile:path atomically:YES]){
            NSLog(@"NO");
        }
    }
    
}
-(NSString *)getFromFile:(NSString *)name{
    NSString *path = [NSString stringWithFormat:@"%@/%@.png",self.directory,name];
    return path;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.directory forKey:@"directorykey"];
}
-(id)initWithCoder:(NSCoder *)decoder{
    self.directory = [decoder decodeObjectForKey:@"directorykey"];
    return self;
}
@end
