//
//  NSString+Regular.m
//  TWApp
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSString+STRegex.h"

/*
 ‘*'，'+'和'?'这三个符号，表示一个或N个字符重复出现的次数。它们分别表示“没有或更多”（[0,+∞]取整），“一次或更多”（[1,+∞]取整），“没有或一次”（[0,1]取整）。
 “ab*”：表示一个字符串有一个a后面跟着零个或若干个b（”a”, “ab”, “abbb”,……）；
 　　“ab+”：表示一个字符串有一个a后面跟着至少一个b或者更多（ ”ab”, “abbb”,……）；
 　　“ab?”：表示一个字符串有一个a后面跟着零个或者一个b（ ”a”, “ab”）；
 　　“a?b+$”：表示在字符串的末尾有零个或一个a跟着一个或几个b（ ”b”, “ab”,”bb”,”abb”,……）。
 */
@implementation NSString (STRegex)

- (BOOL)isValidEnglish
{
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidChinese
{
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

//字母数字下划线，6－20位
- (BOOL)isValidPassword
{
    NSString *regex = @"^[A-Za-z0-9_]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidEmail
{
    return [NSString isValidEmail:self];
}

+ (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegEx =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:[email lowercaseString]];
}

- (BOOL)isValidPhone
{
    return [NSString isValidPhone:self];
}

+ (BOOL)isValidPhone:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     
     手机号码前三位列表：
     
     13(老)号段：130、131、132、133、134、135、136、137、138、139
     15(新)号段：150、151、152、153、154、155、156、157、158、159
     18(3G)号段：180、181、182、183、184、185、186、187、188、189
     
     13号段
     130：中国联通，GSM
     131：中国联通，GSM
     132：中国联通，GSM
     133：中国联通，后转给中国电信，CDMA
     134：中国移动，GSM
     135：中国移动，GSM
     136：中国移动，GSM
     137：中国移动，GSM
     138：中国移动，GSM
     139：中国移动，GSM
     
     14号段
     145：中国联通，上网卡
     147：中国移动，上网卡
     
     15(新)号段
     150：中国移动，GSM
     151：中国移动，GSM
     152：中国联通，网友反映实际是中国移动的
     153：中国联通，后转给中国电信，CDMA
     154：154号段暂时没有分配，估计是因为154的谐音是“要吾死”，这样的手机号码谁敢要啊？
     155：中国联通，GSM
     156：中国联通，GSM
     157：中国移动，GSM
     158：中国移动，GSM
     159：中国移动，GSM
     
     17(4G)号段
     170：虚拟运营商
     176：联通
     177：电信
     178：移动
     
     18(3G)号段
     180：中国电信，3G
     181：中国电信，3G
     182：中国移动，3G
     183：中国移动，3G
     184：中国移动，3G
     185：中国联通，3G
     186：中国联通，3G
     187：中国移动，3G
     188：中国移动，3G，TD-CDMA
     189：中国电信，3G，CDMA，天翼189，2008年底开始对外放号
     */
    
    //NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    //NSString *chinaMobile = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    //NSString * chinaUnicom = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,181,189
     */
    //NSString * chinaTelecom = @"^1((33|53|8[019]|77)[0-9]|349)\\d{7}$";
    
    /*
     13开头
     */
    NSString * mobile13 = @"^13[0-9]\\d{8}$";
    
    /*
     14开头
     联通的是145；移动的是147
     */
    NSString * mobile14 = @"^14(5|7)\\d{8}$";
    
    /*
     15开头
     */
    NSString * mobile15 = @"^15(0|1|2|3|5|6|7|8|9)\\d{8}$";
    
    /*
     17开头
     电信1700；联通1709；移动1705 177
     */
    NSString * mobile17 = @"^17[0-9]\\d{8}$";
    
    /*
     18开头
     */
    NSString * mobile18 = @"^18[0-9]\\d{8}$";
    
    
    // NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    // NSPredicate *cmPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaMobile];
    // NSPredicate *cuPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaUnicom];
    // NSPredicate *ctPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaTelecom];
    
    NSPredicate *mobile13Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile13];
    NSPredicate *mobile14Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile14];
    NSPredicate *mobile15Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile15];
    NSPredicate *mobile17Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile17];
    NSPredicate *mobile18Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile18];
    
    if ([mobile13Predicate evaluateWithObject:phone]
        || [mobile14Predicate evaluateWithObject:phone]
        || [mobile15Predicate evaluateWithObject:phone]
        || [mobile17Predicate evaluateWithObject:phone]
        || [mobile18Predicate evaluateWithObject:phone])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isValidTelNumber
{
    return [NSString isValidTelNumber:self];
}

+ (BOOL)isValidTelNumber:(NSString *)telNumber
{
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return [pred evaluateWithObject:telNumber];
}

- (BOOL)isValidPersonID
{
    return [NSString isValidPersonID:self];
}

/**
 可以参考 身份证验证 refer to http://blog.csdn.net/afyzgh/article/details/16965107
 */
+ (BOOL)isValidPersonID:(NSString *)PID
{
    // 判断位数
    if (PID.length != 15 && PID.length != 18)
    {
        return NO;
    }
    NSString *carid = PID;
    long lSumQT = 0;
    // 加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    // 校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    // 将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:PID];
    if (PID.length == 15)
    {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        
        for (int i = 0; i<= 16; i++)
        {
            p += (pid[i] - 48) * R[i];
        }
        
        int o = p % 11;
        NSString *string_content = [NSString stringWithFormat:@"%c", sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    // 判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self _areaCode:sProvince])
    {
        return NO;
    }
    
    // 判断年月日是否有效
    // 年份
    int strYear = [[self _substringWithString:carid begin:6 end:4] intValue];
    // 月份
    int strMonth = [[self _substringWithString:carid begin:10 end:2] intValue];
    // 日
    int strDay = [[self _substringWithString:carid begin:12 end:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",
                                                strYear, strMonth, strDay]];
    if (date == nil)
    {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    // 检验长度
    if(18 != strlen(PaperId)) return NO;
    // 校验数字
    for (int i = 0; i < 18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    
    // 验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    return YES;
}

- (BOOL)isOnlyLetters
{
    NSString *regex = @"^[A-Za-z\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isOnlyAlpha
{
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isOnlyNumbers
{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isLettersAndNum
{
    NSString *regex = @"^[0-9A-Za-z\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isAlphaAndNum
{
    NSString *regex = @"^[0-9A-Za-z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/** 工商税号 */
- (BOOL)isValidTaxNo
{
    NSString *emailRegex = @"[0-9]\\d{13}([0-9]|X)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidCarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:self];
}

/** 网址验证 */
- (BOOL)isValidUrl
{
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/** 邮政编码 */
- (BOOL)isValidPostalcode
{
    NSString *phoneRegex = @"^[0-8]\\d{5}(?!\\d)$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isValidIP;
{
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pre evaluateWithObject:self];
    
    if (rc)
    {
        NSArray *componds = [self componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds)
        {
            if (s.integerValue > 255)
            {
                v = NO;
                break;
            }
        }
        
        return v;
    }
    
    return NO;
}

#pragma mark - Private

+ (NSString *)_substringWithString:(NSString *)str begin:(NSInteger)begin end:(NSInteger )end
{
    return [str substringWithRange:NSMakeRange(begin, end)];
}

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+ (BOOL)_areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

@end
