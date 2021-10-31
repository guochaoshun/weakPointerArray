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
    [self.weakPointerArray compact];
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
