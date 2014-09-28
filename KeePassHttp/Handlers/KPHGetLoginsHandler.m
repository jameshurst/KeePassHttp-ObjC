//
//  KPHGetLoginsHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHGetLoginsHandler.h"

@implementation KPHGetLoginsHandler

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
    
    NSArray *entries = [self entriesForURL:url];
    
    response.Id = request.Id;
    [self setResponseVerifier:response];
    
    if (entries)
    {
        if (request.SortSelection)
        {
            [KPHUtils sortEntries:entries
                      withURL:[KPHUtils decryptString:request.Url withAES:aes]
                withSubmitURL:[KPHUtils decryptString:request.SubmitUrl withAES:aes]];
        }
        
        
        aes = [KPHAESConfig aesWithKey:key base64key:YES IV:response.Nonce base64IV:YES];
        response.Entries = [KPHUtils encryptEntries:entries withAES:aes];
        
        response.Count = response.Entries.count;
        response.Success = YES;
    }
    
    return;
}

@end
