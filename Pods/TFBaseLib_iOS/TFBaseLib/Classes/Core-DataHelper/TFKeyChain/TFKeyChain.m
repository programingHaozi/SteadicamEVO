//
//  TFKeyChain.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFKeyChain.h"
#import <objc/runtime.h>
#import "SSKeychain.h"

NSString * const TFKEYCHAIN_SERVICE = @"com.TFBaseLib.TFKeyChain";

@interface TFKeyChain ()
@property (strong, nonatomic) NSMutableDictionary *mapping;
@end

@implementation TFKeyChain

enum TypeEncodings {
    Char                = 'c',
    Bool                = 'B',
    Short               = 's',
    Int                 = 'i',
    Long                = 'l',
    LongLong            = 'q',
    UnsignedChar        = 'C',
    UnsignedShort       = 'S',
    UnsignedInt         = 'I',
    UnsignedLong        = 'L',
    UnsignedLongLong    = 'Q',
    Float               = 'f',
    Double              = 'd',
    Object              = '@'
};

- (NSString *)defaultsKeyForPropertyNamed:(char const *)propertyName {
    NSString *key = [NSString stringWithFormat:@"%s", propertyName];
    return [self _transformKey:key];
}

- (NSString *)defaultsKeyForSelector:(SEL)selector {
    return [self.mapping objectForKey:NSStringFromSelector(selector)];
}

static long long longLongGetter(TFKeyChain *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[SSKeychain passwordForService:TFKEYCHAIN_SERVICE account:key]longLongValue];
}

static void longLongSetter(TFKeyChain *self, SEL _cmd, long long value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [SSKeychain setPassword:[NSString stringWithFormat:@"%lld",value] forService:TFKEYCHAIN_SERVICE account:key];
}

static bool boolGetter(TFKeyChain *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[SSKeychain passwordForService:TFKEYCHAIN_SERVICE account:key]boolValue];
}

static void boolSetter(TFKeyChain *self, SEL _cmd, bool value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [SSKeychain setPassword:[NSString stringWithFormat:@"%d",value] forService:TFKEYCHAIN_SERVICE account:key];
}

static int integerGetter(TFKeyChain *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[SSKeychain passwordForService:TFKEYCHAIN_SERVICE account:key]intValue];
}

static void integerSetter(TFKeyChain *self, SEL _cmd, int value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [SSKeychain setPassword:[NSString stringWithFormat:@"%d",value] forService:TFKEYCHAIN_SERVICE account:key];
}

static float floatGetter(TFKeyChain *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[SSKeychain passwordForService:TFKEYCHAIN_SERVICE account:key]floatValue];
}

static void floatSetter(TFKeyChain *self, SEL _cmd, float value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [SSKeychain setPassword:[NSString stringWithFormat:@"%f",value] forService:TFKEYCHAIN_SERVICE account:key];
}

static double doubleGetter(TFKeyChain *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[SSKeychain passwordForService:TFKEYCHAIN_SERVICE account:key]doubleValue];
}

static void doubleSetter(TFKeyChain *self, SEL _cmd, double value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [SSKeychain setPassword:[NSString stringWithFormat:@"%f",value] forService:TFKEYCHAIN_SERVICE account:key];
}

static id objectGetter(TFKeyChain *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [SSKeychain passwordForService:TFKEYCHAIN_SERVICE account:key];
}

static void objectSetter(TFKeyChain *self, SEL _cmd, id object) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    if (object) {
        [SSKeychain setPassword:[NSString stringWithFormat:@"%@",object] forService:TFKEYCHAIN_SERVICE account:key];
    } else {
        [SSKeychain deletePasswordForService:TFKEYCHAIN_SERVICE account:key];
    }
}

#pragma mark - Begin

+ (instancetype)standardKeyChain {
    static dispatch_once_t pred;
    static TFKeyChain *sharedInstance = nil;
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (instancetype)init {
    self = [super init];
    if (self) {
        [self generateAccessorMethods];
    }
    
    return self;
}

- (NSString *)_transformKey:(NSString *)key {
    if ([self respondsToSelector:@selector(transformKey:)]) {
        return [self performSelector:@selector(transformKey:) withObject:key];
    }
    
    return key;
}

- (NSString *)_suiteName {
    // Backwards compatibility (v 1.0.0)
    if ([self respondsToSelector:@selector(suitName)]) {
        return [self performSelector:@selector(suitName)];
    }
    
    if ([self respondsToSelector:@selector(suiteName)]) {
        return [self performSelector:@selector(suiteName)];
    }
    
    return nil;
}

#pragma GCC diagnostic pop

- (void)generateAccessorMethods {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    self.mapping = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < count; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *attributes = property_getAttributes(property);
        
        char *getter = strstr(attributes, ",G");
        if (getter) {
            getter = strdup(getter + 2);
            getter = strsep(&getter, ",");
        } else {
            getter = strdup(name);
        }
        SEL getterSel = sel_registerName(getter);
        free(getter);
        
        char *setter = strstr(attributes, ",S");
        if (setter) {
            setter = strdup(setter + 2);
            setter = strsep(&setter, ",");
        } else {
            asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
        }
        SEL setterSel = sel_registerName(setter);
        free(setter);
        
        NSString *key = [self defaultsKeyForPropertyNamed:name];
        [self.mapping setValue:key forKey:NSStringFromSelector(getterSel)];
        [self.mapping setValue:key forKey:NSStringFromSelector(setterSel)];
        
        IMP getterImp = NULL;
        IMP setterImp = NULL;
        char type = attributes[1];
        switch (type) {
            case Short:
            case Long:
            case LongLong:
            case UnsignedChar:
            case UnsignedShort:
            case UnsignedInt:
            case UnsignedLong:
            case UnsignedLongLong:
                getterImp = (IMP)longLongGetter;
                setterImp = (IMP)longLongSetter;
                break;
                
            case Bool:
            case Char:
                getterImp = (IMP)boolGetter;
                setterImp = (IMP)boolSetter;
                break;
                
            case Int:
                getterImp = (IMP)integerGetter;
                setterImp = (IMP)integerSetter;
                break;
                
            case Float:
                getterImp = (IMP)floatGetter;
                setterImp = (IMP)floatSetter;
                break;
                
            case Double:
                getterImp = (IMP)doubleGetter;
                setterImp = (IMP)doubleSetter;
                break;
                
            case Object:
                getterImp = (IMP)objectGetter;
                setterImp = (IMP)objectSetter;
                break;
                
            default:
                free(properties);
                [NSException raise:NSInternalInconsistencyException format:@"Unsupported type of property \"%s\" in class %@", name, self];
                break;
        }
        
        char types[5];
        
        snprintf(types, 4, "%c@:", type);
        class_addMethod([self class], getterSel, getterImp, types);
        
        snprintf(types, 5, "v@:%c", type);
        class_addMethod([self class], setterSel, setterImp, types);
    }
    
    free(properties);
}

@end

