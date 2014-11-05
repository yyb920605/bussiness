//
//  MyPositionAnnotation.h
//  地图地图
//
//  Created by yyb on 14-10-27.
//  Copyright (c) 2014年 yyb. All rights reserved.
//

#import "BMKPointAnnotation.h"
@class Position;
@interface MyPositionAnnotation : BMKPointAnnotation
@property (retain,nonatomic) Position *position;
-(id)initWithPosition:(Position *) myPosition;
-(void)addContent;
@end
