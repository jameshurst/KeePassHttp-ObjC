//
//  KPHGetAllLoginsHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-25.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHGetAllLoginsHandler.h"

@implementation KPHGetAllLoginsHandler

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server
{
    [super handle:request response:response server:server];
    
    if (![self verifyRequest:request])
        return;
    
    NSString *key = [self delegateKeyForLabel:request.Id];
    if (!key)
        return;
    
    KPHAESConfig *aes = [KPHAESConfig aesWithKey:key base64key:YES IV:request.Nonce base64IV:YES];
    NSURL *url = [NSURL URLWithString:[KPHUtils decryptString:request.Url withAES:aes]];
    if (!url)
        return;
    
    NSArray *entries = [self delegateAllEntries];
    
    response.Id = request.Id;
    [self setResponseVerifier:response];
    
    if (entries)
    {
        entries = [self copyEntries:entries];
        
        /* these should not be provided in get-all-logins */
        for (KPHResponseEntry __strong *entry in entries)
        {
            entry.Password = nil;
            entry.StringFields = nil;
        }
        
        aes = [KPHAESConfig aesWithKey:key base64key:YES IV:response.Nonce base64IV:YES];
        response.Entries = [KPHUtils encryptEntries:entries withAES:aes];
        
        response.Count = response.Entries.count;
        response.Success = YES;
    }
    
    return;
}

@end
