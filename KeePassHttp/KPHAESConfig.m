//
//  KPHAESConfig.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHAESConfig.h"

@implementation KPHAESConfig

- (instancetype)init
{
    if (self = [super init])
    {
        [self generateIV];
    }
    return self;
}

+ (instancetype)aesWithKey:(NSString *)key base64key:(BOOL)base64key
{
    KPHAESConfig *aes = [KPHAESConfig new];
    aes.key = (base64key) ? [[NSData alloc] initWithBase64EncodedString:key options:0] : [key dataUsingEncoding:NSUTF8StringEncoding];
    [aes generateIV];
    return aes;
}

+ (instancetype)aesWithKey:(NSString *)key base64key:(BOOL)base64key IV:(NSString *)IV base64IV:(BOOL)base64IV
{
    KPHAESConfig *aes = [KPHAESConfig new];
    aes.key = (base64key) ? [[NSData alloc] initWithBase64EncodedString:key options:0] : [key dataUsingEncoding:NSUTF8StringEncoding];
    aes.IV = (base64IV) ? [[NSData alloc] initWithBase64EncodedString:IV options:0] : [IV dataUsingEncoding:NSUTF8StringEncoding];
    return aes;
}

- (void)generateIV
{
    static NSString *const charset = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *string = [NSMutableString stringWithCapacity:16];
    
    for (NSUInteger i = 0; i < 16; i++)
        [string appendFormat: @"%C", [charset characterAtIndex: arc4random_uniform((unsigned int)charset.length) % charset.length]];
    
    _IV = [string dataUsingEncoding:NSUTF8StringEncoding];
}

@end
