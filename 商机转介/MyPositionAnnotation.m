//
//  MyPositionAnnotation.m
//  地图地图
//
//  Created by yyb on 14-10-27.
//  Copyright (c) 2014年 yyb. All rights reserved.
//

#import "MyPositionAnnotation.h"
#import "Position.h"
@implementation MyPositionAnnotation
-(id)initWithPosition:(Position *) myPosition{
    MyPositionAnnotation *myPo=[super init];
    myPo.position=myPosition;
    [self addContent];
    return myPo;
}
-(void)addContent{
    if(_position){
        self.title=_position.companyName;
        CLLocationCoordinate2D coor;
        coor.latitude = _position.latit;
        coor.longitude =_position.longit;
        self.coordinate=coor;
    }
}
@end
