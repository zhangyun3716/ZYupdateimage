//  ViewController.m
//  InfraPhotoupload
//  Created by flexium on 2017/7/4.
//  Copyright © 2017年 FLEXium. All rights reserved.
//

#import "ViewController.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
- (IBAction)tackphoto:(id)sender;
- (IBAction)updatephoto:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *tackphoto;
@property (nonatomic, assign) int qinqiuleixing;/**< 请求类型 */
@property(nonatomic,strong)UIView *cameraview;//拍照的view
@property(nonatomic,strong)UIImagePickerController *imagePickerController ;

@property(nonatomic,strong)UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSString *devicename;/**< 设备名称 */
@property (nonatomic, strong) NSMutableArray *imagearray;/**< 图片数组 */
@property (nonatomic, strong) NSMutableArray *videoarray;/**< 视频数组 */
@property (nonatomic, assign) int tupianbiaoji;/**< 图片标记 */
@property (strong,nonatomic)UIActivityIndicatorView *testview;/**< 菊花界面 */
@property (strong, nonatomic) NSString *paths;/**< 图片地址 */
@property (strong, nonatomic) NSString *videopaths;/**< 视频地址 */
@property (strong, nonatomic) NSString *documentPath;/**< documentpath */

@property (strong, nonatomic)  NSFileManager *fileManage;

@property (nonatomic, assign) int imageorvideo;/**< 0图片或1视频 */

- (IBAction)tackvideo:(id)sender;

- (IBAction)updatevideo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shipinbutton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 获取沙盒主目录路径
    self.paths = [NSHomeDirectory() stringByAppendingString:@"/Documents/Photo/"];
    self.videopaths = [NSHomeDirectory() stringByAppendingString:@"/Documents/Video/"];
     self.documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];//doctoments文件夹路径
//    NSLog(@"%@",documentPath);
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    NSString *myDirectory = [self.documentPath stringByAppendingPathComponent:@"Photo"];
    
    [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    [fileManage createDirectoryAtPath:myDirectory attributes:nil];
   
    
    _imageorvideo=0;
    self.tackphoto.layer.borderWidth = 1.0;
    self.tackphoto.layer.borderColor = [UIColor grayColor].CGColor;
    self.tackphoto.layer.cornerRadius=18;
    self.tackphoto.layer.masksToBounds=YES;
    
    self.shipinbutton.layer.borderWidth = 1.0;
    self.shipinbutton.layer.borderColor = [UIColor grayColor].CGColor;
    self.shipinbutton.layer.cornerRadius=18;
    self.shipinbutton.layer.masksToBounds=YES;
    
    _qinqiuleixing=0;
    
    _tupianbiaoji=0;
    
    UIDevice *device = [[UIDevice alloc] init];
    
    _devicename = device.name;       //获取设备所有者的名称
    
    NSLog(@"设备名称:%@",_devicename);
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}
#pragma mark  拍照

- (IBAction)tackphoto:(id)sender {
    _qinqiuleixing=0;
    NSArray *file = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: _paths error:nil];
    if (file.count>50) {
        [self tixing:@"系统存储照片超过50张,请上传更新后拍照" type:@"NG"];
    }else{
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.sourceType=UIImagePickerControllerCameraCaptureModeVideo;
//        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.delegate = self;
        [self presentViewController:pick animated:YES completion:^{
            
        }];
    }
   

}
#pragma mark  重複拍照
-(void)takephotos{
    
    _qinqiuleixing=0;
    
    NSArray *file = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: _paths error:nil];
    if (file.count>50) {
        [self tixing:@"系统存储照片超过50张,请上传更新后拍照" type:@"NG"];
       
    }else{
        _qinqiuleixing=0;
        
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.delegate = self;
        [self presentViewController:pick animated:YES completion:^{
            
        }];
    }
    
}
#pragma mark - 照片选择代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSLog(@"picker:%@info:%@",picker,info);
    
    if (_qinqiuleixing==0) {
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSString *myDirectory = [self.documentPath stringByAppendingPathComponent:@"Photo"];
        
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *originImage = image;
        //    originImage=[self imageWithImage:originImage scaledToSize:CGSizeMake( 1632,1224)];
        
        NSString *name=[NSString stringWithFormat:@"%@%@.JPEG",self.paths,[self huoqudangqianshjian]];
        //        [UIImagePNGRepresentation(originImage)writeToFile: name atomically:YES];
        [UIImageJPEGRepresentation(originImage, 1.10)writeToFile: name atomically:YES];
        NSArray *file = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: _paths error:nil];
        NSMutableArray *imagearray=[[NSMutableArray alloc]init];
        for (int i=0; i<file.count; i++) {
            UIImage *imagess=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",_paths,file[i]]];
            [imagearray addObject:imagess];
        }
        //        NSLog(@"%@",imagearray);
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [picker dismissViewControllerAnimated:NO completion:nil];
        [self takephotos];

    }
    else{
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSString *myDirectory = [self.documentPath stringByAppendingPathComponent:@"Video"];
        
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];

        NSURL *newVideoUrl ; //一般.mp4
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/Video/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    }
    
}
- (IBAction)updatephoto:(id)sender {
  
    _tupianbiaoji=0;
    UIDevice *device = [[UIDevice alloc] init];
    _devicename = device.name;       //获取设备所有者的名称
    NSArray *file = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: _paths error:nil];
    if (file.count>=1) {
        _imagearray=[[NSMutableArray alloc]init];
        for (int i=0; i<file.count; i++) {
            UIImage *imagess=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",_paths,file[i]]];
            [_imagearray addObject:imagess];
        }
//        NSLog(@"%@",_imagearray);

        UIImage *originImage = _imagearray[0];
        NSData *data = UIImageJPEGRepresentation(originImage, 0.80f);
       
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self beginjuhua];
        [self websever:_devicename gogo:encodedImageStr];
    }
    else{
        [self tixing:@"照片存储为空请拍照后上传" type:@"NG"];
    }
}




#pragma mark 上傳照片存儲
-(void)websever:(NSString *)message gogo:(NSString *)image{
    
    NSString *urlStr = @"http://10.2.22.41:81/uplodeimage.asmx";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body>  <UploadPhoto xmlns='http://tempuri.org/'> <dizhi>%@</dizhi><imageBuffer>%@</imageBuffer>  <gg>%@</gg></UploadPhoto> </soap:Body></soap:Envelope>",message,image,[NSString stringWithFormat:@"%d",_tupianbiaoji]];
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"http://tempuri.org/UploadPhoto" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据出错!----%@",error.description);
            [self tixing:@"網絡錯誤" type:@"NG"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _tupianbiaoji=_tupianbiaoji+1;
                if (_tupianbiaoji==self.imagearray.count) {
                    [self endjuhua];
                    [self deletedocument];
                    [self tixing:@"图片上传成功" type:@"OK"];
                    }
                else{
                    
                    UIImage *originImage = _imagearray[_tupianbiaoji];

                    NSData *data = UIImageJPEGRepresentation(originImage, 0.80f);
                    
                    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    [self websever:_devicename gogo:encodedImageStr];
                }

                
            });
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
    
}


#pragma mark 上傳照片存儲
-(void)updatevideos:(NSString *)message gogo:(NSString *)image{
    
    NSString *urlStr = @"http://10.2.22.41:81/uplodeimage.asmx";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body>  <Uploadvideo xmlns='http://tempuri.org/'> <dizhi>%@</dizhi><imageBuffer>%@</imageBuffer><gg>%@</gg></Uploadvideo> </soap:Body></soap:Envelope>",message,image,[NSString stringWithFormat:@"%d",_tupianbiaoji]];
    NSString *dataStr = [NSString stringWithFormat:@"%@",str1];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"http://tempuri.org/Uploadvideo" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据出错!----%@",error.description);
            [self tixing:@"網絡錯誤" type:@"NG"];

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _tupianbiaoji=_tupianbiaoji+1;
                if (_tupianbiaoji==self.videoarray.count) {
                    [self endjuhua];
                    [self deletedocumentvideo];
                    [self tixing:@"视频上传成功" type:@"OK"];
                }
                else{
                    
                    NSData *data = _videoarray[0];
                    
                    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    
                    [self beginjuhua];
                    
                    
                    [self updatevideos:_devicename gogo:encodedImageStr];
                }
                
                
            });
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
    
}
#pragma mark 建立并开始菊花界面请求
-(void)beginjuhua{
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    [testActivityIndicator setFrame :CGRectMake(100, 200, 100, 100)];//不建议这样设置，因为
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor greenColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    self.testview=testActivityIndicator;
}
#pragma mark 结束并移除菊花界面
-(void)endjuhua{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_testview stopAnimating]; // 结束旋转
        [_testview removeFromSuperview]; //当旋转结束时移除
    });
}

#pragma mark 提醒界面的方法
-(void)tixing:(NSString *)str type:(NSString *)type{
    [self endjuhua];
    NSUInteger len = [str length];
    if (len<1){
        str=@"错误,且返回错误,请联系资讯解决";
        len=[str length];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
    if([type isEqualToString:@"OK"]){
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, len)];
    }else{
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, len)];
    }
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, len)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
}

-(NSString *)huoqudangqianshjian{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
-(void)deletedocument{
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Photo/"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

-(void)deletedocumentvideo{
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Video/"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

#pragma mark 图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark 拍视频
- (IBAction)tackvideo:(id)sender {
    self.qinqiuleixing=1;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 30.0f;//30秒
    ipc.delegate = self;//设置委托
}
#pragma mark 更新视频
- (IBAction)updatevideo:(id)sender {
    _qinqiuleixing=1;
    _tupianbiaoji=0;
    UIDevice *device = [[UIDevice alloc] init];
    _devicename = device.name;       //获取设备所有者的名称
    NSArray *file = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: _videopaths error:nil];
    NSLog(@"%lu",(unsigned long)file.count);
    if (file.count>=1) {
        _videoarray=[[NSMutableArray alloc]init];
        NSURL *newVideoUrl=nil;
        for (int i=0; i<file.count; i++) {
            NSString *urlstring=[NSString stringWithFormat:@"%@%@",_videopaths,file[i]];
            newVideoUrl = [NSURL fileURLWithPath:urlstring];
            
             NSData *data = [NSData dataWithContentsOfURL:newVideoUrl];
            
            [_videoarray addObject:data];
        
        }
//        NSLog(@"%@",_videoarray);
        
        NSData *data = _videoarray[0];
        
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [self beginjuhua];
        
      
        [self updatevideos:_devicename gogo:encodedImageStr];
    }
    else{
        [self tixing:@"視頻存储为空请拍照后上传" type:@"NG"];
    }
    
}

- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。

- (CGFloat) getVideoLength:(NSURL *)URL
{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second; 
}//此方法可以获取视频文件的时长。

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
   
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    // NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4; //转换的格式
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
     }]; 
}

-(void)twogogo{
    
}


@end
