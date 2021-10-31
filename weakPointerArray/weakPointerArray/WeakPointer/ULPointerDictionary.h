//
//  ULPointerDictionary.h
//  weakPointerArray
//
//  Created by 郭朝顺 on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULPointerDictionary : NSObject

+ (instancetype)strongToWeakObjectsDictionary;

@property (readonly) NSUInteger count;

- (NSObject *)objectForKey:(NSString *)key;

- (void)setObject:(NSObject *)anObject forKey:(NSString *)aKey;

- (void)removeObjectForKey:(NSString *)key;

- (NSDictionary *)toDictionary;


@end

NS_ASSUME_NONNULL_END
