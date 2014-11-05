//
//  TLMyMapViewController.h
//  商机转介
//
//  Created by yyb on 14-10-28.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "CNPPopupController.h"

@class Position;
@interface TLMyMapViewController : UIViewController
@property (strong,nonatomic)IBOutlet BMKMapView* mapView;
@property (strong,nonatomic)BMKLocationService* locService;
@property (retain,nonatomic)NSString* trade;
@property (retain,nonatomic)NSString* distance;
@property (retain,nonatomic)NSArray* menuArray;

@property (assign,nonatomic) CLLocationCoordinate2D currentSelectCoordinate;
@property (assign,nonatomic)BOOL isSetMapSpan;


-(void)setAnnotation:(NSMutableArray *)muarray;//添加标注 muarray存获取的公司信息集合
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate andSpan:(BMKCoordinateSpan)span;//定位后，将地图移动到定位点并设立显示范围大小

-(void)showPopupWithStyle:(CNPPopupStyle)popupStyle andPosition:(Position *)pos;//设立弹出地图的样式和地点

-(void)getSearchedPositions:(NSString *)trade andDistance:(NSString *)distance;//根据行业和范围查找商户的列表
@end

