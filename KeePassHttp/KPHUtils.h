//
//  KPHUtils.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "KPHAESConfig.h"
#import "KPHResponse.h"

@interface KPHUtils : NSObject

+ (NSString *)performOpertaion:(CCOperation)op withAES:(KPHAESConfig *)aes onString:(NSString *)input base64input:(BOOL)base64input base64output:(BOOL)base64output;
+ (NSString *)decryptString:(NSString *)input withAES:(KPHAESConfig *)aes;
+ (NSString *)encryptString:(NSString *)input withAES:(KPHAESConfig *)aes;
+ (NSArray<KPHResponseEntry, Optional> *)encryptEntries:(NSArray *)entries withAES:(KPHAESConfig *)aes;

+ (void)sortEntries:(NSArray *)entries withURL:(NSString *)url withSubmitURL:(NSString *)submitUrl;

@end
