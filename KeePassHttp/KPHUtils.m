//
//  KPHUtils.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHUtils.h"
#import "NSData+Cryptor.h"
#import "KPHResponse.h"

@implementation KPHUtils

+ (NSString *)performOpertaion:(CCOperation)op withAES:(KPHAESConfig *)aes onString:(NSString *)input base64input:(BOOL)base64input base64output:(BOOL)base64output
{
    NSString *output = nil;
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreate(op, kCCAlgorithmAES, kCCOptionPKCS7Padding, aes.key.bytes, aes.key.length, aes.IV.bytes, &cryptor);
    if (status == kCCSuccess)
    {
        NSData *inputData = (base64input) ? [[NSData alloc] initWithBase64EncodedString:input options:0] : [input dataUsingEncoding:NSUTF8StringEncoding];
        NSData *outputData = [inputData runCryptor:cryptor];
        output = (base64output) ? [outputData base64EncodedStringWithOptions:0] : [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        CCCryptorRelease(cryptor);
    }
    
    return output;
}

+ (NSString *)decryptString:(NSString *)input withAES:(KPHAESConfig *)aes
{
    return [KPHUtils performOpertaion:kCCDecrypt withAES:aes onString:input base64input:YES base64output:NO];
}

+ (NSString *)encryptString:(NSString *)input withAES:(KPHAESConfig *)aes
{
    return [KPHUtils performOpertaion:kCCEncrypt withAES:aes onString:input base64input:NO base64output:YES];
}

+ (NSArray<KPHResponseEntry, Optional> *)encryptEntries:(NSArray *)entries withAES:(KPHAESConfig *)aes
{
    NSMutableArray<KPHResponseEntry, Optional> *encryptedEntries = entries.mutableCopy;
    
    for (KPHResponseEntry __strong *entry in encryptedEntries)
    {
        entry.Name = [KPHUtils encryptString:entry.Name withAES:aes];
        entry.Login = [KPHUtils encryptString:entry.Login withAES:aes];
        entry.Password = [KPHUtils encryptString:entry.Password withAES:aes];
        entry.Uuid = [KPHUtils encryptString:entry.Uuid withAES:aes];
        
        for (KPHResponseStringField __strong *stringField in entry.StringFields)
        {
            stringField.Key = [KPHUtils encryptString:stringField.Key withAES:aes];
            stringField.Value = [KPHUtils encryptString:stringField.Value withAES:aes];
        }
    }
    
    return encryptedEntries;
}

+ (NSString *)prepareURL:(NSString *)url
{
    if (!url || url.length == 0)
        return nil;
    
    NSString *prepared = [[NSString alloc] initWithString:url];
    
    // remove trailing '/'
    unichar lastChar = [url characterAtIndex:url.length - 1];
    if ([[NSCharacterSet characterSetWithCharactersInString:@"/"] characterIsMember:lastChar])
        prepared = [prepared substringToIndex:url.length - 1];
    
    // add http:// if no scheme is present
    if ([prepared rangeOfString:@"://"].location == NSNotFound)
        prepared = [@"http://" stringByAppendingString:prepared];
    
    return prepared;
}

+ (void)sortEntries:(NSArray *)entries withURL:(NSString *)url withSubmitURL:(NSString *)submitUrl
{
    NSString *cleanUrl = [KPHUtils prepareURL:url];
    NSString *cleanSubmitUrl = (submitUrl) ? [KPHUtils prepareURL:submitUrl] : cleanUrl;
    
    NSURL *_url = [NSURL URLWithString:cleanUrl];
    NSURL *_submitUrl = [NSURL URLWithString:cleanSubmitUrl];
    
    if (!_url || !_submitUrl)
        return;
    
    NSString *baseSubmitUrl = [NSString stringWithFormat:@"%@://%@", _submitUrl.scheme, _submitUrl.host].lowercaseString;
    
    for (KPHResponseEntry *entry in entries)
    {
        NSString *cleanEntryUrl = [KPHUtils prepareURL:entry.url];
        if (!cleanEntryUrl)
        {
            entry.sortValue = 0;
            continue;
        }
        
        NSURL *_entryUrl = [NSURL URLWithString:cleanEntryUrl];
        NSString *baseEntryUrl = [NSString stringWithFormat:@"%@://%@", _entryUrl.scheme, _entryUrl.host].lowercaseString;
        
        if ([cleanSubmitUrl isEqualToString:cleanEntryUrl])
            entry.sortValue = 100;
        else if ([cleanSubmitUrl hasPrefix:cleanEntryUrl] && ![cleanUrl isEqualToString:cleanEntryUrl] && ![baseSubmitUrl isEqualToString:cleanEntryUrl])
            entry.sortValue = 90;
        else if ([cleanSubmitUrl hasPrefix:baseEntryUrl] && ![cleanUrl isEqualToString:baseEntryUrl] && ![baseSubmitUrl isEqualToString:baseEntryUrl])
            entry.sortValue = 80;
        else if ([cleanUrl isEqualToString:cleanEntryUrl])
            entry.sortValue = 70;
        else if ([baseSubmitUrl isEqualToString:cleanEntryUrl])
            entry.sortValue = 60;
        else if ([cleanEntryUrl hasPrefix:cleanSubmitUrl])
            entry.sortValue = 50;
        else if ([cleanEntryUrl hasPrefix:baseSubmitUrl] && ![baseSubmitUrl isEqualToString:cleanUrl])
            entry.sortValue = 40;
        else if ([cleanSubmitUrl hasPrefix:cleanEntryUrl])
            entry.sortValue = 30;
        else if ([cleanSubmitUrl hasPrefix:baseEntryUrl])
            entry.sortValue = 20;
        else if ([cleanEntryUrl hasPrefix:cleanUrl])
            entry.sortValue = 10;
        else if ([cleanUrl hasPrefix:cleanEntryUrl])
            entry.sortValue = 5;
        else
            entry.sortValue = 0;
    }
    
    NSMutableArray *sortedEntries = entries.mutableCopy;
    [sortedEntries sortUsingComparator:^NSComparisonResult(KPHResponseEntry *obj1, KPHResponseEntry *obj2) {
        return [@(obj2.sortValue) compare:@(obj1.sortValue)];
    }];
}

@end
