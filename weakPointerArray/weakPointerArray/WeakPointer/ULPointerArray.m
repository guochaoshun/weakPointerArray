//
//  ULPointerArray.m
//  UXLive
//
//  Created by liyazhu on 2021/10/24.
//  Copyright © 2021 UXIN CO. All rights reserved.
//

#import "ULPointerArray.h"

@interface ULPointerArray ()

/// 锁
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
/// 数组
@property (nonatomic, strong) NSPointerArray *weakPointerArray;

@end

@implementation ULPointerArray

+ (instancetype)weakPointerArray {
    ULPointerArray *pointerArray = [[ULPointerArray alloc] init];
    return pointerArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.weakPointerArray = [NSPointerArray weakObjectsPointerArray];
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (BOOL)containsObject:(NSObject *)anObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self removeNilPointerIfNeed];
    NSArray *allObjects = self.weakPointerArray.allObjects;
    BOOL isContain = [allObjects containsObject:anObject];
    dispatch_semaphore_signal(self.semaphore);
    return isContain;
}


- (void)addObject:(NSObject *)anObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self removeNilPointerIfNeed];
    if (anObject != nil) {
        [self.weakPointerArray addPointer:(__bridge void * _Nullable)(anObject)];
    }
    dispatch_semaphore_signal(self.semaphore);
}

- (void)removeObject:(NSObject *)anObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self p_removeAction:anObject];
    dispatch_semaphore_signal(self.semaphore);
}

- (NSArray *)allObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self removeNilPointerIfNeed];
    NSArray *result = self.weakPointerArray.allObjects;
    dispatch_semaphore_signal(self.semaphore);
    return result;
}

- (void)removeNilPointerIfNeed {
    // pointerArray有个bug,
//    如果不调用[pointerArray addPointer:nil],直接调用-compact,
//    不会移除pointerArray弱引用自动置nil的指针,导致pointerArray的下表和pointerArray下标不一致
//    pointerArray数组存在nil时，而allobject的值不包含nil
//    参考链接：https://stackoverflow.com/questions/31322290/nspointerarray-weird-compaction

    // 使用下面的写法, 可以保证把pointerArray中的所有nil移除掉
    // 方案1: 直接移除,O(n)复杂度
    [self.weakPointerArray addPointer:nil];
    [self.weakPointerArray compact];
    // 方案2: 比较导出数据的count和自身的count,不一致在做移除,
    // 导出这个数组需要O(n),移除操作需要O(n),总体是O(2*n)复杂度,还不如方案1的做法,不推荐
//    NSArray *result = self.weakPointerArray.allObjects;
//    if (self.count != result.count) {
//        [self.weakPointerArray addPointer:nil];
//        [self.weakPointerArray compact];
//    }
}


- (NSUInteger)count{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self removeNilPointerIfNeed];
    NSUInteger count = self.weakPointerArray.count;
    dispatch_semaphore_signal(self.semaphore);
    return count;
}

/// 倒序删除
- (void)p_removeAction:(NSObject *)anObject {
    [self removeNilPointerIfNeed];
    for (NSInteger i = self.weakPointerArray.count-1; i>=0; i--) {
        NSObject *obj = [self.weakPointerArray pointerAtIndex:i];
        if ([obj isEqual:anObject]) {
            [self.weakPointerArray removePointerAtIndex:i];
        }
    }
}

// 备选删除方案:通过数组删除, 只能删除一个,想要删除多个的话,会出现下标不匹配的问题
- (void)p_removeAction2:(NSObject *)anObject {
    [self removeNilPointerIfNeed];
    NSUInteger index = [self.weakPointerArray.allObjects indexOfObject:anObject];
    if (index != NSNotFound) {
        [self.weakPointerArray removePointerAtIndex:index];
    }

}

@end
