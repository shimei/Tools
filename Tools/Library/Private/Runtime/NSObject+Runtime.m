//
//  NSObject+Runtime.m
//  Tools
//
//  Created by 吴双 on 15/11/3.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "NSObject+Runtime.h"
#import "NSProperty.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

+ (void)swapInstanceSourceMethod:(SEL)sourceMethod withTargetMethod:(SEL)targetMethod {
    method_exchangeImplementations(class_getInstanceMethod(self, sourceMethod), class_getInstanceMethod(self, targetMethod));
}

+ (void)swapClassSourceMethod:(SEL)sourceMethod withTargetMethod:(SEL)targetMethod {
    method_exchangeImplementations(class_getClassMethod(self, sourceMethod), class_getClassMethod(self, targetMethod));
}

- (void)setAssociatedObject:(id)object forKey:(NSString *)key withAssociationMode:(NSObjectAssociationMode)mode {
    [self willChangeValueForKey:key];
    const void *k = [self.class keyWithString:key];
    objc_setAssociatedObject(self, k, object, (objc_AssociationPolicy)mode);
    [self didChangeValueForKey:key];
}

- (id)associatedObjectForKey:(NSString *)key {
    const void *k = [self.class keyWithString:key];
    return objc_getAssociatedObject(self, k);
}

+ (NSArray *)propertyList {
    NSMutableArray *propertyList = [NSMutableArray array];
    unsigned outCount;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        const char *char_t = property_getAttributes(properties[i]);
        const char *char_n = property_getName(properties[i]);
        NSProperty *property = [NSProperty propertyWithPropertyName:char_n andPropertyAttributes:char_t];
        NSLog(@"%@", property.baseType ? @"yes" : @"no");
        [propertyList addObject:property];
    }
    return [propertyList copy];
}

static const char keyForKeys = '\0';
+ (void)setKeys:(NSMutableDictionary *)keys {
    objc_setAssociatedObject(self, &keyForKeys, keys, OBJC_ASSOCIATION_RETAIN);
}

+ (NSMutableDictionary<NSString *,NSValue *> *)keys {
    NSMutableDictionary *keys = objc_getAssociatedObject(self, &keyForKeys);
    if (!keys) {
        keys = [NSMutableDictionary dictionary];
        [self setKeys:keys];
    }
    return keys;
}

+ (const void *)keyWithString:(NSString *)string {
    NSMutableDictionary *keys = [self keys];
    const void *k = [keys[string] pointerValue];
    if (!k) {
        k = string.UTF8String;
        keys[string] = [NSValue valueWithPointer:k];
    }
    return k;
}

@end

