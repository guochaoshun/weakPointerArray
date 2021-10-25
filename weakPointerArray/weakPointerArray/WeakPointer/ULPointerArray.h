//
//  ULPointerArray.h
//  UXLive
//
//  Created by liyazhu on 2021/10/24.
//  Copyright © 2021 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULPointerArray : NSObject

+ (instancetype)weakPointerArray;

- (BOOL)containsObject:(NSObject *)anObject;

- (void)addObject:(NSObject *)anObject;

- (void)removeObject:(NSObject *)anObject;

- (NSArray *)allObject;

@end

NS_ASSUME_NONNULL_END
