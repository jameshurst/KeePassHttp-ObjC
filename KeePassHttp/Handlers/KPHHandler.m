//
//  KPHHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHHandler.h"
#import "KPHAESConfig.h"
#import "KPHUtils.h"
#import "NSData+Cryptor.h"

@implementation KPHHandler
{
    KPHServer *_server;
}

- (NSString *)delegateLabelForKey:(NSString *)key
{
    return [_server.delegate server:_server labelForKey:key];
}

- (NSString *)delegateKeyForLabel:(NSString *)label
{
    return [_server.delegate server:_server keyForLabel:label];
}

- (NSArray *)delegateEntriesForURL:(NSString *)url
{
    return [_server.delegate server:_server entriesForURL:url];
}

- (NSArray *)delegateAllEntries
{
    return [_server.delegate allEntriesForServer:_server];
}

- (void)delegateSetUsername:(NSString *)username andPassword:(NSString *)password forURL:(NSString *)url withUUID:(NSString *)uuid
{
    [_server.delegate server:_server setUsername:username andPassword:password forURL:url withUUID:uuid];
}

- (NSString *)delegateGeneratePassword
{
    return [_server.delegate generatePasswordForServer:_server];
}

- (BOOL)testRequestVerifier:(KPHRequest *)request withAES:(KPHAESConfig *)aes
{
    BOOL success = NO;
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreate(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, aes.key.bytes, aes.key.length, aes.IV.bytes, &cryptor);
    if (status == kCCSuccess)
    {
        NSData *encrypted = [[NSData alloc] initWithBase64EncodedString:request.Verifier options:0];
        NSData *decrypted = [encrypted runCryptor:cryptor];
        
        success = [[[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding] isEqualToString:request.Nonce];
        
        CCCryptorRelease(cryptor);
    }
    
    return success;
}

- (void)setResponseVerifier:(KPHResponse *)response
{
    KPHAESConfig *aes = [KPHAESConfig aesWithKey:[self delegateKeyForLabel:response.Id] base64key:YES];
    response.Nonce = [aes.IV base64EncodedStringWithOptions:0];
    response.Verifier = [KPHUtils performOpertaion:kCCEncrypt withAES:aes onString:response.Nonce base64input:NO base64output:YES];
}

- (BOOL)verifyRequest:(KPHRequest *)request
{
    return [self verifyRequest:request withKey:[self delegateKeyForLabel:request.Id]];
}

- (BOOL)verifyRequest:(KPHRequest *)request withKey:(NSString *)key
{
    if (!key)
        return NO;
    
    if (![self testRequestVerifier:request withAES:[KPHAESConfig aesWithKey:key base64key:YES IV:request.Nonce base64IV:YES]])
        return NO;
    
    return YES;
}

- (NSArray *)copyEntries:(NSArray *)entries
{
    NSArray *copies = [[NSArray alloc] initWithArray:entries copyItems:YES];
    
    for (NSUInteger i = 0; i < entries.count; i++)
        ((KPHResponseEntry *)copies[i]).url =  ((KPHResponseEntry *)entries[i]).url;
    
    return copies;
}

- (NSArray *)entriesForURL:(NSURL *)url
{
    NSString *search = url.host;
    NSArray *entries = nil;
    while (!entries || entries.count == 0)
    {
        entries = [self delegateEntriesForURL:search];
        NSRange dot = [search rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
        if (dot.location == NSNotFound || dot.location + 1 >= search.length)
            break;
        
        search = [search substringFromIndex:dot.location + 1];
    }
   
    return [self copyEntries:entries];
}

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server
{
    _server = server;
}

@end
