//
//  RuntimeVC.m
//  WSW_test
//
//  Created by wsw on 16/6/27.
//  Copyright © 2016年 wsw. All rights reserved.
//

#import "RuntimeVC.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface RuntimeVC ()

@end

@implementation RuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ex_registerClassPair];
}

- (void)ex_registerClassPair
{
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass) withObject:nil];
}

- (void)testMetaClass
{
    NSLog(@"%s", __func__);
}

void TestMetaClass (id self, SEL _cmd)
{
    NSLog(@"This objct is %p", self);
    NSLog(@"Class is %@, super Class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i=0; i<4; i++)
    {
        NSLog(@"following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
        // TestClass,
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

@end
