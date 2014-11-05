//
//  TLMyMapViewController.m
//  商机转介
//
//  Created by yyb on 14-10-28.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLMyMapViewController.h"
#import "position.h"
#import "MyPositionAnnotation.h"
#import "TLAppDelegate.h"
#import "tooles.h"
#import "ASIFormDataRequest.h"
#import "Position.h"
#import "MXPullDownMenu.h"

@implementation TLMyMapViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSetMapSpan=NO;//初始化置判定定位的数据为no
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];    // Do any additional setup after loading the view, typically from a nib.
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置跟随的状态
    _mapView.showsUserLocation = YES;//显示定位图层

    
    BMKUserLocation *userLocation=[_locService userLocation];
    BMKCoordinateSpan span=BMKCoordinateSpanMake(0.6, 0.6);
    [self setMapRegionWithCoordinate:userLocation.location.coordinate andSpan:span];
    //初始化下拉菜单
    _distance=@"0";//初始化为0表示所有
    _trade=@"全行业";
    NSArray *titles=[[NSArray alloc]initWithObjects:@"选择行业",@"选择距离", nil];
    //此处可以填写中文，在下方需要填写对应英文详见130行左右，距离必须填xx米，因为下面会把米删除
    _menuArray = @[ @[@"全行业",@"计算机",@"金融"], @[@"全距离", @"500米",@"1000米",@"5000米"] ];
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:_menuArray selectedColor:[UIColor redColor] titles:titles];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 60, menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];

    
}
//下拉菜单点击代理
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row{

    if(column==0){
        NSString *str1=[[NSString alloc]initWithString:_menuArray[column][row]];
        if([str1 isEqualToString:@"选择行业"]){
            _trade=@"全行业";
        }else
        {
            _trade=str1;
            
        }
    }else
    {
        NSMutableString *str2=[[NSMutableString alloc]initWithString:_menuArray[column][row]];
        if([str2 isEqualToString:@"选择范围"]||[str2 isEqualToString:@"全距离"]){
            _distance=@"0";
           

        }else
        {
            
            NSRange subStr=[str2 rangeOfString:@"米"];
            [str2 deleteCharactersInRange:subStr];
            _distance=str2;
        }
    
    }
    [self getSearchedPositions:_trade andDistance:_distance];
}

-(void)setAnnotation:(NSMutableArray *)muarray{
//    Position *po1=[[Position alloc]initWithTitle:@"测试一" andLatit:34.7502450000 andLongit:113.6587530000];
//    Position *po2=[[Position alloc]initWithTitle:@"测试二" andLatit:34.7265140000 andLongit:113.7229280000];
//    Position *po3=[[Position alloc]initWithTitle:@"测试3" andLatit:34.7102450000 andLongit:113.6787530000];
    
//    [muarray addObject:po1];
//    [muarray addObject:po2];
//    [muarray addObject:po3];
//  此处为每次添加地图钉子时删除原来的，但是不能直接删除_mapView.annotations,否则会造成线程冲突;且不能arr=_mapView.annotations,直等相当于把arr指向_marView.annotations,当操作arr时相当于操作_mapView.annotations,例子如下：操作arr3 arr2也会变
//    NSMutableArray *arr2=[[NSMutableArray alloc]init];
//    [arr2 addObject:@"2"];
//    [arr2 addObject:@"3"];
//    [arr2 addObject:@"4"];
//    NSMutableArray *arr3=arr2;
//    [arr3 removeObjectAtIndex:1];
    _isSetMapSpan=NO;
    BMKCoordinateSpan span;
    if([_distance isEqualToString:@"0"]){
        span=BMKCoordinateSpanMake(0.6, 0.6);
        
    }else if([_distance isEqualToString:@"500"]){
        span=BMKCoordinateSpanMake(0.02, 0.02);
    
    }else if([_distance isEqualToString:@"1000"]){
        span=BMKCoordinateSpanMake(0.04, 0.04);
        
    }else if([_distance isEqualToString:@"5000"]){
        span=BMKCoordinateSpanMake(0.2, 0.2);
        
    }
    BMKUserLocation *userLocation=[_locService userLocation];
    [self setMapRegionWithCoordinate:userLocation.location.coordinate andSpan:span];
    
    NSArray *arr=[[NSArray alloc]initWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arr];
    for (int i=0;i<[muarray count];i++ ) {
        MyPositionAnnotation* annotation = [[MyPositionAnnotation alloc]initWithPosition:
                                            [muarray objectAtIndex:i]];
        
        
        [_mapView addAnnotation:annotation];
    };
}
-(void)getSearchedPositions:(NSString *)trade andDistance:(NSString *)distance{
    [tooles showHUD:@"正在查询，请稍后。。。"];
   
//    TLAppDelegate *myDelegate=[[UIApplication sharedApplication]delegate];
    NSString *urlstr=[NSString stringWithFormat:@"%@/%@",@"http://192.168.2.3:8080",@"control/json/getBranchs"];
    NSURL *myurl=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:myurl];
    if(![trade isEqualToString:@"全行业"]){
        if([trade isEqualToString:@"计算机"]){
            [request setPostValue:@"IT" forKey:@"trade"];
        }else if ([trade isEqualToString:@"金融"]){
            [request setPostValue:@"FINANCE" forKey:@"trade"];
        }
    }
    BMKUserLocation *userLocation=[_locService userLocation];
    [request setPostValue:distance forKey:@"distance"];
    NSString* longitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    NSString* latitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [request setPostValue:latitude forKey:@"latitude"];
    //[request setPostValue:@"orgid" forKey:@""];
    [request setPostValue:longitude forKey:@"longitude"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    

};
- (void)GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
-(void)GetResult:(ASIHTTPRequest *)request{
    [tooles removeHUD];
    NSError *error;
    NSString *str=[request responseString];
    [str UTF8String];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];NSString *result=[all objectForKey:@"result"];
    if([result isEqualToString:@"success"]){


        NSArray *positionsJson=[all objectForKey:@"branchs"];
        NSMutableArray *positions=[[NSMutableArray alloc]init];
        for(int i=0;i<[positionsJson count];i++){
            NSDictionary *po=[positionsJson objectAtIndex:i];
            Position *postion=[[Position alloc]initWithBranchId:[po objectForKey:@"branchId"] andLatit:[[po objectForKey:@"latitude"] doubleValue] andLongit:[[po objectForKey:@"longitude"] doubleValue] andCompanyDescription:[po objectForKey:@"description"] andCompanyContact:[po objectForKey:@"contact"] andCompanyPhone:[po objectForKey:@"phone"] andCompanyImage:[po objectForKey:@"image"] andCompanyName:[po objectForKey:@"name"] andCompanyAddress:[po objectForKey:@"address"]];
            [positions addObject:postion];
        }
        [self setAnnotation:positions];//在地图上插入大头针
    }else{
        [tooles MsgBox:@"查询错误"];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{


    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    BMKCoordinateRegion region;
    //    region.center.latitude  = userLocation.location.coordinate.latitude;
    //    region.center.longitude = userLocation.location.coordinate.longitude;
    ////    region.span.latitudeDelta  = 0.2;
    ////    region.span.longitudeDelta = 0.2;
    //    if (_mapView)
    //    {
    //        _mapView.region = region;
    //        NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    }
    //[self setMapRegionWithCoordinate:userLocation.location.coordinate];
    NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
    NSLog(@"location error num:%@",error);
}


- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"已进入annotationViewForBubble");
    MyPositionAnnotation *pa=view.annotation;
    if(![pa.title isEqual:@"我的位置"]){
        [self showPopupWithStyle:CNPPopupStyleCentered andPosition:pa.position];
    }
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andPosition:(Position *)pos {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSMutableArray *count=[[NSMutableArray alloc]init];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:pos.companyName attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSParagraphStyleAttributeName : paragraphStyle}];
    UIImage *image=[UIImage imageNamed:pos.companyImage];
    if(image!=nil){
        [count addObject:image];
    }
    if(pos.companyContact!=nil){
        NSString *a=[NSString stringWithFormat:@"联系人:%@",pos.companyContact];
        NSAttributedString *line = [[NSAttributedString alloc] initWithString:a attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : paragraphStyle}];
        [count addObject:line];
    }
    if(pos.companyPhone!=nil){
        NSString *a=[NSString stringWithFormat:@"联系人电话:%@",pos.companyPhone];
        NSAttributedString *line = [[NSAttributedString alloc] initWithString:a attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : paragraphStyle}];
        [count addObject:line];
    }
    if(pos.companyAddress!=nil){
        NSString *a=[NSString stringWithFormat:@"详细地址:%@",pos.companyAddress];
        NSAttributedString *line = [[NSAttributedString alloc] initWithString:a attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : paragraphStyle}];
        [count addObject:line];
    }
    if(pos.companyDescription!=nil){
        NSString *a=[NSString stringWithFormat:@"分店描述:%@",pos.companyDescription];
        NSAttributedString *line = [[NSAttributedString alloc] initWithString:a attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : paragraphStyle}];
        [count addObject:line];
    }






    
    //    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Close me" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];

    CNPPopupController *popupController = [[CNPPopupController alloc] initWithTitle:title contents:count buttonTitles:nil destructiveButtonTitle:nil];
    popupController.theme = [CNPPopupTheme defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
    popupController.theme.dismissesOppositeDirection = YES;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}



//传入经纬度,将baiduMapView 锁定到以当前经纬度为中心点的显示区域和合适的显示范围
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate andSpan:(BMKCoordinateSpan)span;
{
    //bool _isSetMapSpan=NO;
    BMKCoordinateRegion region;
    if (!_isSetMapSpan)//这里用一个变量判断一下,只在第一次锁定显示区域时 设置一下显示范围 Map Region
    {
        region = BMKCoordinateRegionMake(coordinate, span);//越小地图显示越详细
        _isSetMapSpan = YES;
        [_mapView setRegion:region animated:YES];//执行设定显示范围
        _currentSelectCoordinate = coordinate;
        //[_mapView setCenterCoordinate:coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
    }
    
}


//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        BMKPointAnnotation *item = (BMKPointAnnotation *)obj;
//        if (item.coordinate.latitude == _currentSelectCoordinate.latitude && item.coordinate.longitude == _currentSelectCoordinate.longitude )
//        {
//            [_mapView selectAnnotation:obj animated:YES];//执行之后,会让地图中的标注处于弹出气泡框状态
//            *stop = YES;
//        }
//    }];
//}

@end
