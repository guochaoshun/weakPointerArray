//
//  ULPointerDictionary.m
//  weakPointerArray
//
//  Created by 郭朝顺 on 2021/10/25.
//

#import "ULPointerDictionary.h"

@interface ULPointerDictionary ()

/// 锁
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
/// 弱引用集合
@property (nonatomic, strong) NSMapTable *weakPointerMapTable;

@end

@implementation ULPointerDictionary


+ (instancetype)strongToWeakObjectsDictionary {
    ULPointerDictionary *pointerDictionary = [[ULPointerDictionary alloc] init];
    return pointerDictionary;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.weakPointerMapTable = [NSMapTable strongToWeakObjectsMapTable];
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}


- (NSObject *)objectForKey:(NSString *)key {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSObject *obj = [self.weakPointerMapTable objectForKey:key];
    dispatch_semaphore_signal(self.semaphore);
    return obj;
}

- (void)setObject:(NSObject *)anObject forKey:(NSString *)aKey {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self.weakPointerMapTable setObject:anObject forKey:aKey];
    dispatch_semaphore_signal(self.semaphore);
}

- (void)removeObjectForKey:(NSString *)key {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self.weakPointerMapTable removeObjectForKey:key];
    dispatch_semaphore_signal(self.semaphore);
}

- (NSDictionary *)toDictionary {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSDictionary *dic = [self.weakPointerMapTable dictionaryRepresentation];
    dispatch_semaphore_signal(self.semaphore);
    return dic;
}

- (NSUInteger)count{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSUInteger count = self.weakPointerMapTable.count;
    dispatch_semaphore_signal(self.semaphore);
    return count;
}


@end
