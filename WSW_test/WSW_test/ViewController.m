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
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self testMutableCopy];
    
    //[self testDictionaryParam:dict count:count array:array string:string];
    
    //[self testNSMutableArray];
    
    //[self dependency_method];
    
    //[self suspended_method];
    
    //[self operation_maxConcurrentOperation];
    
    //[self operation_method];
    
    //[self setUI_method];
    
    //[self gcd_method];
    
    //[self unzip_method];
    
    NSLog(@"---------");
    NSLog(@"---------");
    NSLog(@"---------");
    
    NSLog(@"---------");

}

- (void)testMutableCopy
{
//    NSArray *array = @[@"aaa"];
//    NSString *string = @"11111";
//    NSUInteger count = 100;
    NSDictionary *dict = @{@"test":@"123"};
    NSDictionary *mutableDict = [dict copy];
    NSLog(@"%@\n%@", [dict description], [mutableDict description]);
}

- (void)testDictionaryParam:(NSDictionary *)param count:(NSUInteger)count array:(NSArray *)array string:(NSString *)string
{
    NSString *copyString = [string mutableCopy];
    NSLog(@"%p  %p  %p  %p", copyString, [array copy], [param copy], &count);
}

- (void)testNSMutableArray
{
    NSArray *arrM_1 = [NSArray array];
    
    for (NSInteger i=0; i<10000; i++) {
        
        [NSThread sleepForTimeInterval:1];
        NSMutableArray *arrM_2 = [NSMutableArray array];
        for (NSUInteger j=0; j<100; j++)
        {
            [arrM_2 addObject:@"aaa_"];
        }
        NSLog(@"arrM_2 : %@", arrM_2);
        
        //[arrM_1 removeAllObjects];
        //[arrM_1 addObjectsFromArray:arrM_2];
        arrM_1 = [arrM_2 copy];
        NSLog(@"arrM_1 : %@, class : %@", arrM_1, [arrM_1 class]);
    }
}

- (void)dependency_method
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@"1"];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@"2"];
    
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@"3"];
    
    [op1 addDependency:op2];
    [op2 addDependency:op3];
    
    op1.completionBlock = ^{
         NSLog(@"op1----finish");
    };
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)run:(NSString *)obj
{
    NSLog(@"[current thread]==%@---obj===%@",[NSThread currentThread],obj);
}

- (void)suspended_method
{
    self.queue = [[NSOperationQueue alloc] init];
    
    self.queue.maxConcurrentOperationCount = 1;
    
    [self.queue addOperationWithBlock:^{
       
        [NSThread sleepForTimeInterval:2];
        NSLog(@"task1---%@",[NSThread currentThread]);
    }];
    
    [self.queue addOperationWithBlock:^{
       
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"task2---%@",[NSThread currentThread]);
    }];
    
    [self.queue addOperationWithBlock:^{
        
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"task3---%@",[NSThread currentThread]);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.queue.isSuspended) {
        self.queue.suspended = NO;
    }else{
        self.queue.suspended = YES;
    }
}

- (void)operation_maxConcurrentOperation
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 1;
    
    [queue addOperationWithBlock:^{
         NSLog(@"task1---%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"task2---%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"task3---%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"task4---%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"task5---%@",[NSThread currentThread]);
    }];
}

- (void)operation_method
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task3 ---- %@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
       NSLog(@"task4 ---- %@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
       NSLog(@"task5 ---- %@",[NSThread currentThread]);
    }];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)task1
{
    NSLog(@"task1------%@", [NSThread currentThread]);
}

- (void)task2
{
    NSLog(@"task2------%@", [NSThread currentThread]);
}

- (void)setUI_method
{
    PanView *pan = [[PanView alloc] initWithFrame:CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width*2, self.view.bounds.size.height)];
    pan.delegate = self;
    pan.backgroundColor = [UIColor redColor];
    [self.view addSubview:pan];
    self.panView = pan;

    UILabel *marLabel = [[UILabel alloc] initWithFrame:CGRectMake(150+self.view.bounds.size.width, 150, 100, 100)];
    marLabel.text = @"X1";
    //[marLabel sizeToFit];
    marLabel.backgroundColor = [UIColor orangeColor];
    marLabel.textColor = [UIColor redColor];
    marLabel.textAlignment = NSTextAlignmentCenter;
    marLabel.font = [UIFont boldSystemFontOfSize:20];
    [pan addSubview:marLabel];
    self.marLabel = marLabel;
    marLabel.hidden = YES;


    [UIView beginAnimations:@"marquee" context:NULL];
    [UIView setAnimationDuration:5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:100000];

    CGRect rect = marLabel.frame;
    rect.origin.x = -rect.size.width;
    marLabel.frame = rect;

    [UIView commitAnimations];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(150, 250, 60, 30)];
    [button setTitle:@"click" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

- (void)gcd_method
{
    // 1.创建一个并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 2.将任务添加到队列中
    dispatch_sync(queue, ^{
        NSLog(@"任务1  == %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2  == %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3  == %@", [NSThread currentThread]);
    });
}

- (void)unzip_method
{
    [self unzip:@"http://head.youximao.tv/2cd0fd1b-5855-45df-926d-b9774480c0d6.zip" fileName:@"2cd0fd1b-5855-45df-926d-b9774480c0d6.zip"];
    
    NSString *path = [self filePath:@"2cd0fd1b-5855-45df-926d-b9774480c0d6.zip"];
    NSLog(@"path : %@", path);
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
