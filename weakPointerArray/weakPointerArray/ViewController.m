//
//  ViewController.m
//  weakPointerArray
//
//  Created by 郭朝顺 on 2021/10/25.
//

#import "ViewController.h"
#import "ULPointerArray.h"
#import "ULPointerSet.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self lockArrayTest];

}

- (void)lockSetTest {

    ULPointerSet *pointerSet = [ULPointerSet weakPointerSet];

    // 加锁有必要的,NSHashTable不是线程安全的
    // 100000 加信号量 需要13s
    // 100000 不加信号量, crash
    NSLog(@"开始");
    for (NSInteger i = 0; i<100000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSObject *obj = [NSObject new];
            [pointerSet addObject:obj];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [pointerSet removeObject:obj];
            });
        });
    }
    NSLog(@"结束");
}


- (void)lockArrayTest {

    ULPointerArray *pointerArray = [ULPointerArray weakPointerArray];

    // 加锁有必要的,NSPointerArray不是线程安全的
    // 100000 加信号量 需要13s
    // 100000 不加信号量, crash
    NSLog(@"开始");
    for (NSInteger i = 0; i<100000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSObject *obj = [NSObject new];
            [pointerArray addObject:obj];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [pointerArray removeObject:obj];
            });
        });
    }
    NSLog(@"结束");
}

/// 封装弱引用delegate集合更推荐使用NSHashTable, 不需要考虑顺序
- (void)pointerSetTest {

    ULPointerSet *pointerSet = [ULPointerSet weakPointerSet];
    NSObject *obj = [NSObject new];
    NSObject *objCopy = obj;

    [pointerSet addObject:nil];
    [pointerSet addObject:nil];
    [pointerSet addObject:@"1"];
    [pointerSet addObject:@"2"];
    [pointerSet addObject:@"3"];


    [pointerSet addObject:obj];
    [pointerSet addObject:obj];
    [pointerSet addObject:obj];
    [pointerSet addObject:obj];

    NSLog(@"11 -- %@",pointerSet.allObject);

    for (NSObject *obj in pointerSet.weakPointerSet) {
        NSLog(@"11集合中 -- %@",obj);
    }
    NSLog(@"11containsObject -- %d",[pointerSet containsObject:objCopy]);

    [pointerSet removeObject:objCopy];
    NSLog(@"22 -- %@",pointerSet.allObject);
    NSLog(@"22containsObject -- %d",[pointerSet containsObject:objCopy]);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"33 -- %@",pointerSet.allObject);
    });
}

- (void)pointerArrayTest {

    ULPointerArray *pointerArray = [ULPointerArray weakPointerArray];
    NSObject *obj = [NSObject new];
    NSObject *objCopy = obj;

    [pointerArray addObject:obj];
    [pointerArray addObject:obj];
    [pointerArray addObject:obj];
    [pointerArray addObject:obj];

    NSLog(@"11 -- %@",pointerArray.allObject);
    NSLog(@"containsObject %d",[pointerArray containsObject:objCopy]);
    [pointerArray removeObject:obj];

    NSLog(@"containsObject %d",[pointerArray containsObject:objCopy]);
    NSLog(@"22 -- %@",pointerArray.allObject);

}


@end
