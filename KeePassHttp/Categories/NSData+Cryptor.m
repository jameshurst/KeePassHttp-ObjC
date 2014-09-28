//
//  NSData+Cryptor.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "NSData+Cryptor.h"

@implementation NSData (Cryptor)

- (NSData *)runCryptor:(CCCryptorRef)cryptor
{
    CCCryptorStatus status;
    
    size_t total_bytes = 0;
    size_t bytes_used = 0;
    size_t bufsize = CCCryptorGetOutputLength(cryptor, self.length, true);
    char *buf = malloc(bufsize);
    
    if (buf == NULL)
        return nil;
    
    NSData *output = nil;
    
    do {
        if ((status = CCCryptorUpdate(cryptor, self.bytes, self.length, buf, bufsize, &bytes_used)) != kCCSuccess)
            break;
        
        total_bytes += bytes_used;
        
        if ((status = CCCryptorFinal(cryptor, buf + bytes_used, bufsize - bytes_used, &bytes_used)) != kCCSuccess)
            break;
        
        total_bytes += bytes_used;
        
        output = [NSData dataWithBytes:buf length:total_bytes];
    } while (0);
    
    free(buf);
    
    return output;
}

@end
