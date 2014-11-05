//
//  TLReaderViewController.m
//  TongLian
//
//  Created by mac on 14-3-17.
//  Copyright (c) 2014年 BoYunSen. All rights reserved.
//

#import "TLReaderViewController.h"

@interface TLReaderViewController ()

@end

@implementation TLReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self setTag1:0];
    [self setTag2:0];
    [self setTag3:0];
    [self setTag:0];
    
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return(YES);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.allPhoto = [[NSMutableDictionary alloc]init];
     self.province.titleLabel.textAlignment = NSTextAlignmentLeft;
	// Do any additional setup after loading the view.
}
//商机提交
-(IBAction)button_click:(id)sender{
    [self subbmit:@"chanceAdd"];
}
//商机保存
-(IBAction)save:(id)sender{
    [self subbmit:@"chanceSave"];
}
-(void)subbmit:(NSString *)action{
    
    NSString *businessName = [self.businessName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *person = [self.contactPerson.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = [self.contactPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(businessName.length==0){
        [tooles MsgBox:@"请输入商户工商注册名称！"];
        return;
    }
    if(person.length == 0){
        [tooles MsgBox:@"请输入联系人姓名！"];
        return;
    }
    if(phone.length ==0){
        [tooles MsgBox:@"请输入联系人电话！"];
        return;
    }
//    if(self.detailAdress.text.length ==0){
//        [tooles MsgBox:@"请输入商户地址！"];
//        return;
//    }
//    if(self.pro.length == 0){
//        [tooles MsgBox:@"请选择商户所在省市县！"];
//        return;
//    }
    [tooles showHUD:@"请稍候！"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,action];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    NSString *license = [self.allPhoto objectForKey:@"license"];
    NSString *head = [self.allPhoto objectForKey:@"head"];
    NSString *locale = [self.allPhoto objectForKey:@"locale"];
    
    if(![license isKindOfClass:[NSNull class]]&&[license length]!=0){
        [request setFile:[NSString stringWithFormat:@"%@/license.png",license] forKey:@"license"];
    }
    if(![head isKindOfClass:[NSNull class]]&&[head length]!=0){
        [request setFile:[NSString stringWithFormat:@"%@/head.png",head] forKey:@"head"];
    }
    if(![locale isKindOfClass:[NSNull class]]&&[locale length]!=0){
        [request setFile:[NSString stringWithFormat:@"%@/locale.png",locale] forKey:@"businessZone"];
    }
    [request setPostValue:@"BANKCARD" forKey:@"serviceType"];
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:@"测试备注" forKey:@"comment"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:businessName forKey:@"name"];
    [request setPostValue:person forKey:@"person"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:@"0" forKey:@"processId"];
    [request setPostValue:@"beizhu" forKey:@"comment"];
    if(self.detailAdress.text.length !=0){
        [request setPostValue:self.detailAdress.text forKey:@"addressDetail"];
    }
    if(self.pro.length != 0){
        [request setPostValue:self.pro forKey:@"province"];
        [request setPostValue:self.city forKey:@"city"];
        [request setPostValue:self.district forKey:@"district"];
     }
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request setTimeOutSeconds:20];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request startAsynchronous];

}
-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    NSLog(@"loginjson===%@",loginJson);
    NSString *result = [loginJson objectForKey:@"result"];
    if([result isEqualToString:@"success"]){
        [tooles MsgBox:@"商机提交成功！"];
        TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"myProcessList"];
        NSURL *myurl = [NSURL URLWithString:urlstr];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
        
        [request setPostValue:@"IOS" forKey:@"phoneType"];
        [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
        [request setPostValue:@"SCHEDULE" forKey:@"orderStatus"];
        [request setPostValue:@"1" forKey:@"page"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(GetResultt:)];
        [request setDidFailSelector:@selector(GetErrt:)];
        [request startAsynchronous];
        request = nil;

        //[self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"result===%@",result);
        [tooles MsgBox:@"提交不成功，请重新提交！"];
    }
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    TLRecallTableViewController *recall =[storyboard instantiateViewControllerWithIdentifier:@"recall"];
//    [recall setList:loginJson];
//    [self.navigationController pushViewController:recall animated:YES];
}
-(void)GetResultt:(ASIHTTPRequest *)request{
    //接受字符串集
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *map = [[all objectForKey:@"loginJson"] objectAtIndex:0];
    NSString *total = [map objectForKey:@"totalrecords"];
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    //删除最后一个，也就是自己
    [array removeObjectAtIndex:array.count-1];
    
    UIStoryboard *storyboard=nil;
    storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    TLChanceListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"chanceList" ];
    [viewController setBusinessList:[map objectForKey:@"content"]];
    [viewController setTotalRecords:[total integerValue]];
    [viewController setImageName:@"成排2.png"];
    [viewController setOrderStatus:@"SCHEDULE"];
    [array addObject:viewController];
    [self.navigationController setViewControllers:array animated:YES];
}

- (void) GetErrt:(ASIHTTPRequest *)request{
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
-(IBAction)license_click:(id)sender{
    //尚未拍照,调用系统相机拍照
    if(self.tag1 == 0){
        [self setTag:1];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        picker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:picker animated:YES completion:nil];
        

    }
    //照片已拍
    else{
        UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
        TLShowImageViewController *show = [storyboard instantiateViewControllerWithIdentifier:@"showImage" ];
        [show setImageName:@"license"];
        [self.navigationController pushViewController:show animated:YES];
    }
}
-(IBAction)head_click:(id)sender{
    //尚未拍照,调用系统相机拍照
    if(self.tag2 == 0){
        [self setTag:2];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        picker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }
    //照片已拍
    else{
        UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
        TLShowImageViewController *show = [storyboard instantiateViewControllerWithIdentifier:@"showImage" ];
        [show setImageName:@"head"];
        [self.navigationController pushViewController:show animated:YES];
    }
}
-(IBAction)locale_click:(id)sender{
    //尚未拍照,调用系统相机拍照
    if(self.tag3 == 0){
        [self setTag:3];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        picker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }
    //照片已拍
    else{
        UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
        TLShowImageViewController *show = [storyboard instantiateViewControllerWithIdentifier:@"showImage" ];
        [show setImageName:@"locale"];
        [self.navigationController pushViewController:show animated:YES];
 
    }
}
//完成拍照响应事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self synchro:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//拍照完成同步到系统
-(void)synchro:(UIImage *)myImage{
    
    //转换成缩略图，减少内存压力
//    UIImage *nn;
//    CGSize asize = CGSizeMake(68,57);
//    UIGraphicsBeginImageContext(asize);
//    [myImage drawInRect:CGRectMake(0,0,68,57)];
//    nn=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //营业执照
    if(self.tag == 1){
        [self.license setBackgroundImage:[UIImage imageNamed:@"拍照完成.png"] forState:UIControlStateNormal];
        NSString *path = [NSString stringWithFormat:@"%@/%@",documentDirectory,@"opportunity"];
        TLImage *image = [[TLImage alloc]initWithPath:path];
        [image saveToFile:myImage ImageName:@"license" photoType:@"license"];
        //保存至所有照片，方便提交上传
        [self.allPhoto setObject:path forKey:@"license"];
        [self setTag1:1];
    }
    //门头
    if(self.tag == 2){
        [self.head setBackgroundImage:[UIImage imageNamed:@"拍照完成.png"] forState:UIControlStateNormal];
        NSString *path = [NSString stringWithFormat:@"%@/%@",documentDirectory,@"opportunity"];
        TLImage *image = [[TLImage alloc]initWithPath:path];
        [image saveToFile:myImage ImageName:@"head" photoType:@"head"];
        //保存至所有照片，方便提交上传
        [self.allPhoto setObject:path forKey:@"head"];
        [self setTag2:1];
    }
    //营业场所
    if(self.tag == 3){
        [self setTag3:1];
        [self.locale setBackgroundImage:[UIImage imageNamed:@"拍照完成.png"] forState:UIControlStateNormal];
        NSString *path = [NSString stringWithFormat:@"%@/%@",documentDirectory,@"opportunity"];
        TLImage *image = [[TLImage alloc]initWithPath:path];
        [image saveToFile:myImage ImageName:@"locale" photoType:@"locale"];
        //保存至所有照片，方便提交上传
        [self.allPhoto setObject:path forKey:@"locale"];
    }
    [self setTag:0];
}
-(IBAction)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
