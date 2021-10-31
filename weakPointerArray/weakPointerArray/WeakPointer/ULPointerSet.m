//
//  ULPointerSet.m
//  timerButton
//
//  Created by 郭朝顺 on 2021/10/25.
//

#import "ULPointerSet.h"

@interface ULPointerSet ()
/// 锁
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
/// 弱引用集合
@property (nonatomic, strong) NSHashTable *weakPointerSet;

@end

@implementation ULPointerSet

+ (instancetype)weakPointerSet {
    ULPointerSet *pointerSet = [[ULPointerSet alloc] init];
    return pointerSet;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.weakPointerSet = [NSHashTable weakObjectsHashTable];
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (BOOL)containsObject:(NSObject *)anObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    BOOL isContain = [self.weakPointerSet containsObject:anObject];
    dispatch_semaphore_signal(self.semaphore);
    return isContain;
}


- (void)addObject:(NSObject *)anObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self.weakPointerSet addObject:anObject];
    dispatch_semaphore_signal(self.semaphore);
}

- (void)removeObject:(NSObject *)anObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self.weakPointerSet removeObject:anObject];
    dispatch_semaphore_signal(self.semaphore);
}

- (NSArray *)allObject {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSArray *allObjects = [self.weakPointerSet allObjects];
    dispatch_semaphore_signal(self.semaphore);
    return allObjects;
}


- (NSUInteger)count{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSUInteger count = self.weakPointerSet.count;
    dispatch_semaphore_signal(self.semaphore);
    return count;
}


@end
