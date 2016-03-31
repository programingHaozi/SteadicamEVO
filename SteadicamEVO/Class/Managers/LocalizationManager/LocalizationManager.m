//
//  LocalizationManager.m
//  LocaliztionDemo
//
//  Created by 耗子 on 16/3/13.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "LocalizationManager.h"

#define kUserLanguage @"userLanguage"

#define kUserDefault [NSUserDefaults standardUserDefaults]

@interface LocalizationManager()

@property (nonatomic, strong) NSString *currentLanguage;

@end

@implementation LocalizationManager

+ (void)load
{
    [self shareInstance];
}

+ (LocalizationManager *)shareInstance
{
    static LocalizationManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[LocalizationManager alloc]init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initUserLanguage];
    }
    
    return self;
}

- (void)initUserLanguage
{
    NSString *userLanguage = [kUserDefault valueForKey:kUserLanguage];
    
    if (!userLanguage)
    {
        NSArray *languages = [kUserDefault objectForKey:@"AppleLanguages"];
        
        NSString *currentLanguage = [languages objectAtIndex:0];
        
        userLanguage = currentLanguage;
        
        _userLanguage = userLanguage;
    }
    
    NSString *languagePath = [[NSBundle mainBundle]pathForResource:userLanguage ofType:@"lproj"];
    
    _languageBundle = [NSBundle bundleWithPath:languagePath];
}

#pragma mark - Setter Getter -

-(void)setUserLanguage:(NSString *)userLanguage
{
    if (!userLanguage || userLanguage == _currentLanguage)
    {
        return;
    }
    _userLanguage    = userLanguage;
    self.currentLanguage = userLanguage;
    
    NSString *languagePath = [[NSBundle mainBundle]pathForResource:userLanguage ofType:@"lproj"];
    
    self.languageBundle = [NSBundle bundleWithPath:languagePath];
    
    [kUserDefault setValue:userLanguage forKey:kUserLanguage];
    
    [kUserDefault synchronize];
    
}

-(NSString *)localizedStringForKey:(NSString *)key
{
    // 默认为本地资源文件名 为Localizable.strings
    NSString *str = [_languageBundle localizedStringForKey:key
                                                     value:nil
                                                     table:@"Localizable"];
    
    return str;
}

- (UIImage *)localizedImageForKey:(NSString *)key
{
    NSString *suffix;
    
    if ([UIScreen mainScreen].nativeScale > 1.0)
    {
        suffix = [NSString stringWithFormat:@"@%dx",(int)[UIScreen mainScreen].nativeScale];
    }
    
    NSString *imageName = [key stringByAppendingString:suffix];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[_languageBundle pathForResource:imageName ofType:@"png"]];
    
    return image;
}

-(UIStoryboard *)localizedStoryboardWithName:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                storyboardName
                                                         bundle:_languageBundle];
    return storyboard ;
}

-(UINib *)localizedNibWithName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:_languageBundle];
    
    return nib;
}

@end
