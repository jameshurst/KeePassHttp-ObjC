//
//  KPHGetLoginsCountHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-25.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHGetLoginsCountHandler.h"

@implementation KPHGetLoginsCountHandler

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
    if (url)
    {
        response.Count = [self entriesForURL:url].count;
        response.Success = YES;
    }
    
    response.Id = request.Id;
    [self setResponseVerifier:response];
}

@end
