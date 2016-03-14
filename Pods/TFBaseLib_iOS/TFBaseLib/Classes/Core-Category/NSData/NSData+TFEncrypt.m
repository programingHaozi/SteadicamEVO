//
//  NSData+TFEncrypt.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSData+TFEncrypt.h"
#import "NSError+Category.h"

@implementation NSData (TFEncrypt)

- (NSData *)MD2 {
    unsigned char hash[CC_MD2_DIGEST_LENGTH];
    (void) CC_MD2( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_MD2_DIGEST_LENGTH] );
}

- (NSData *)MD4 {
    unsigned char hash[CC_MD4_DIGEST_LENGTH];
    (void) CC_MD4( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_MD4_DIGEST_LENGTH] );
}

- (NSData *)MD5 {
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    (void) CC_MD5( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_MD5_DIGEST_LENGTH] );
}

- (NSData *)SHA1 {
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}

- (NSData *)SHA224 {
    unsigned char hash[CC_SHA224_DIGEST_LENGTH];
    (void) CC_SHA224( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_SHA224_DIGEST_LENGTH] );
}

- (NSData *)SHA256 {
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

- (NSData *)SHA384 {
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    (void) CC_SHA384( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_SHA384_DIGEST_LENGTH] );
}

- (NSData *)SHA512 {
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [self bytes], (CC_LONG)[self length], hash );
    
    return ( [NSData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

- (NSData *)AES256EncryptedUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmAES128
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)AES256DecryptedUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmAES128
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)DESEncryptedUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmDES
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)DESDecryptedUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmDES
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)CASTEncryptedUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmCAST
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)CASTDecryptedUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmCAST
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                  error:(CCCryptorStatus *)error {
    return ( [self dataEncryptedUsingAlgorithm: algorithm
                                           key: key
                          initializationVector: nil
                                       options: 0
                                         error: error] );
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                options:(CCOptions) options
                                  error:(CCCryptorStatus *) error {
    return ( [self dataEncryptedUsingAlgorithm: algorithm
                                           key: key
                          initializationVector: nil
                                       options: options
                                         error: error] );
}


static void FixKeyLengths( CCAlgorithm algorithm, NSMutableData * keyData, NSMutableData * ivData ) {
    NSUInteger keyLength = [keyData length];
    switch ( algorithm )
    {
        case kCCAlgorithmAES128:
        {
            if ( keyLength < 16 )
            {
                [keyData setLength: 16];
            }
            else if ( keyLength < 24 )
            {
                [keyData setLength: 24];
            }
            else
            {
                [keyData setLength: 32];
            }
            
            break;
        }
            
        case kCCAlgorithmDES:
        {
            [keyData setLength: 8];
            break;
        }
            
        case kCCAlgorithm3DES:
        {
            [keyData setLength: 24];
            break;
        }
            
        case kCCAlgorithmCAST:
        {
            if ( keyLength < 5 )
            {
                [keyData setLength: 5];
            }
            else if ( keyLength > 16 )
            {
                [keyData setLength: 16];
            }
            
            break;
        }
            
        case kCCAlgorithmRC4:
        {
            if ( keyLength > 512 )
                [keyData setLength: 512];
            break;
        }
            
        default:
            break;
    }
    
    [ivData setLength: [keyData length]];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm) algorithm
                                    key:(id)key		// data or string
                   initializationVector:(id)iv		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);
    
    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ( [iv isKindOfClass: [NSString class]] )
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];	// data or nil
    
    // ensure correct lengths for key and iv data, based on algorithms
    FixKeyLengths( algorithm, keyData, ivData );
    
    status = CCCryptorCreate( kCCEncrypt, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor );
    
    if ( status != kCCSuccess )
    {
        if ( error != NULL )
            *error = status;
        return ( nil );
    }
    
    NSData * result = [self _runCryptor: cryptor result: &status];
    if ( (result == nil) && (error != NULL) )
        *error = status;
    
    CCCryptorRelease( cryptor );
    
    return ( result );
}

- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                  error:(CCCryptorStatus *)error {
    return ( [self decryptedDataUsingAlgorithm: algorithm
                                           key: key
                          initializationVector: nil
                                       options: 0
                                         error: error] );}

- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error {
    return ( [self decryptedDataUsingAlgorithm: algorithm
                                           key: key
                          initializationVector: nil
                                       options: options
                                         error: error] );
}

- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                   initializationVector:(id)iv		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);
    
    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ( [iv isKindOfClass: [NSString class]] )
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];	// data or nil
    
    // ensure correct lengths for key and iv data, based on algorithms
    FixKeyLengths( algorithm, keyData, ivData );
    
    status = CCCryptorCreate( kCCDecrypt, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor );
    
    if ( status != kCCSuccess ) {
        if ( error != NULL )
            *error = status;
        return ( nil );
    }
    
    NSData * result = [self _runCryptor: cryptor result: &status];
    if ( (result == nil) && (error != NULL) )
        *error = status;
    
    CCCryptorRelease( cryptor );
    
    return ( result );
}

#pragma mark - Private
- (NSData *)_runCryptor:(CCCryptorRef)cryptor result:(CCCryptorStatus *)status {
    size_t bufsize = CCCryptorGetOutputLength( cryptor, (size_t)[self length], true );
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate( cryptor, [self bytes], (size_t)[self length],
                              buf, bufsize, &bufused );
    if ( *status != kCCSuccess ) {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    // From Brent Royal-Gordon (Twitter: architechies):
    //  Need to update buf ptr past used bytes when calling CCCryptorFinal()
    *status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
    if ( *status != kCCSuccess )
    {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    return ( [NSData dataWithBytesNoCopy: buf length: bytesTotal] );
}

@end
