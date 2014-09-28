//
//  NSData+Cryptor.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSData (Cryptor)

- (NSData *)runCryptor:(CCCryptorRef)cryptor;

@end
