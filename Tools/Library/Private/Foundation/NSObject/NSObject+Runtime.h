//
//  NSObject+Runtime.h
//  Tools
//
//  Created by 吴双 on 15/11/3.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSObjectAssociationMode) {
    NSObjectAssociationModeAssign = 0,
    NSObjectAssociationModeRetainNonatomic = 1,
    NSObjectAssociationModeCopyNonatomic = 3,
    NSObjectAssociationModeRetain = 01401,
    NSObjectAssociationModeCopy = 01403,
};




@interface NSObject (Runtime)

+ (void)swapInstanceSourceMethod:(SEL)sourceMethod withTargetMethod:(SEL)targetMethod;

+ (void)swapClassSourceMethod:(SEL)sourceMethod withTargetMethod:(SEL)targetMethod;

- (void)setAssociatedObject:(id)object forKey:(NSString *)key withAssociationMode:(NSObjectAssociationMode)mode;

- (id)associatedObjectForKey:(NSString *)key;

+ (NSDictionary<NSString *, Class> *)propertyList;

@end
