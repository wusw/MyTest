//
//  ViewController.m
//  WSW_test
//
//  Created by wsw on 16/4/18.
//  Copyright © 2016年 wsw. All rights reserved.
//

#import "ViewController.h"
#import "PanView.h"
#import "ZipArchive/ZipArchive.h"

@interface ViewController ()<PanViewDelegate>
@property (nonatomic, weak) UILabel *marLabel;
@property (nonatomic, assign) CGPoint oldPoint;
@property (nonatomic, weak) PanView *panView;
@property (nonatomic, assign) CGPoint beginPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self unzip:@"http://head.youximao.tv/2cd0fd1b-5855-45df-926d-b9774480c0d6.zip" fileName:@"2cd0fd1b-5855-45df-926d-b9774480c0d6.zip"];
    
    NSString *path = [self filePath:@"2cd0fd1b-5855-45df-926d-b9774480c0d6.zip"];
    NSLog(@"path : %@", path);
    
    //    PanView *pan = [[PanView alloc] initWithFrame:CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width*2, self.view.bounds.size.height)];
    //    pan.delegate = self;
    //    pan.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:pan];
    //    self.panView = pan;
    //
    //    UILabel *marLabel = [[UILabel alloc] initWithFrame:CGRectMake(150+self.view.bounds.size.width, 150, 100, 100)];
    //    marLabel.text = @"X1";
    //    //[marLabel sizeToFit];
    //    marLabel.backgroundColor = [UIColor orangeColor];
    //    marLabel.textColor = [UIColor redColor];
    //    marLabel.textAlignment = NSTextAlignmentCenter;
    //    marLabel.font = [UIFont boldSystemFontOfSize:20];
    //    [pan addSubview:marLabel];
    //    self.marLabel = marLabel;
    //    marLabel.hidden = YES;
    
    
    //    [UIView beginAnimations:@"marquee" context:NULL];
    //    [UIView setAnimationDuration:5];
    //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationRepeatAutoreverses:NO];
    //    [UIView setAnimationRepeatCount:100000];
    //
    //    CGRect rect = marLabel.frame;
    //    rect.origin.x = -rect.size.width;
    //    marLabel.frame = rect;
    //
    //    [UIView commitAnimations];
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setFrame:CGRectMake(150, 250, 60, 30)];
    //    [button setTitle:@"click" forState:UIControlStateNormal];
    //    button.backgroundColor = [UIColor orangeColor];
    //    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    //    [self.view addSubview:button];
}

- (void)unzip:(NSString *)giftUrl fileName:(NSString *)fileName
{
    [self DownloadTextFile:giftUrl fileName:fileName complete:^(NSString *filePath) {
        
        NSString *documentPath = [self documentPath];
        [self OpenZip:filePath unzipto:documentPath];
    }];
}

- (void)DownloadTextFile:(NSString *)fileUrl fileName:(NSString *)_fileName complete:(void(^)(NSString *fileName))complete
{
    //fileName就是保存文件的文件名
    NSString *FileName = [[self documentPath] stringByAppendingPathComponent:_fileName];;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Copy the database sql file from the resourcepath to the documentpath
    if ([fileManager fileExistsAtPath:FileName])
    {
        if (complete)
        {
            complete(FileName);
        }
    }
    else
    {
        NSURL *url = [NSURL URLWithString:fileUrl];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            [fileManager createFileAtPath:FileName contents:data attributes:nil];
            
            if (complete)
            {
                complete(FileName);
            }
        });
    }
};

- (void)OpenZip:(NSString *)zipPath unzipto:(NSString *)_unzipto
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:zipPath])
    {
        BOOL ret = [zip UnzipFileTo:_unzipto overWrite:YES];
        if( NO==ret )
        {
            NSLog(@"error");
        }
        [zip UnzipCloseFile];
    }
}

- (NSString *)documentPath
{
    //使用C函数NSSearchPathForDirectoriesInDomains来获得沙盒中目录的全路径。
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sandboxPath = [documentPaths objectAtIndex:0];
    //将Documents添加到sandbox路径上GiftAnimaZip.app
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"GiftAnimaZip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Copy the database sql file from the resourcepath to the documentpath
    if (![fileManager fileExistsAtPath:documentPath])
    {
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentPath;
}

- (NSString *)filePath:(NSString *)giftPath
{
    NSString *documentPath = [self documentPath];
    NSString *fileUrl = [documentPath stringByAppendingPathComponent:giftPath];
    return fileUrl;
}



- (void)swipeHandle:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:gesture.view];
    
    if (point.x < 60 )
    {
        CGRect rect = self.marLabel.frame;
        rect.origin.x = point.x;
        self.marLabel.frame = rect;
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.marLabel.transform = CGAffineTransformTranslate(self.marLabel.transform, self.view.bounds.size.width, 0);
        }];
    }
}

- (void)click
{
    self.marLabel.hidden = NO;
    [self shakeToShow:self.marLabel];
}

- (void) shakeToShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(8.0, 8.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
@end
