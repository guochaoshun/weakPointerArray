//
//  ULPointerSet.h
//  timerButton
//
//  Created by 郭朝顺 on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULPointerSet : NSObject

+ (instancetype)weakPointerSet;

@property (readonly) NSUInteger count;

@property (nonatomic, strong, readonly) NSHashTable *weakPointerSet;

- (BOOL)containsObject:(NSObject *)anObject;

- (void)addObject:(NSObject *)anObject;

- (void)removeObject:(NSObject *)anObject;

- (NSArray *)allObject;

@end

NS_ASSUME_NONNULL_END
