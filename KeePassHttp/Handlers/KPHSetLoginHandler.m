//
//  KPHSetLoginHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-25.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHSetLoginHandler.h"

@implementation KPHSetLoginHandler

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server
{
    [super handle:request response:response server:server];
    
    if (![self verifyRequest:request])
        return;
    
    NSString *key = [self delegateKeyForLabel:request.Id];
    if (!key)
        return;
    
    KPHAESConfig *aes = [KPHAESConfig aesWithKey:key base64key:YES IV:request.Nonce base64IV:YES];
    
    NSString *url = [KPHUtils decryptString:request.Url withAES:aes];
    NSString *username = [KPHUtils decryptString:request.Login withAES:aes];
    NSString *password = [KPHUtils decryptString:request.Password withAES:aes];
    NSString *uuid = (request.Uuid) ? [KPHUtils decryptString:request.Uuid withAES:aes] : nil;
    
    if (url && username && password)
    {
        [self delegateSetUsername:username andPassword:password forURL:url withUUID:uuid];
        response.Success = YES;
    }
    
    response.Id = request.Id;
    [self setResponseVerifier:response];
    
    return;
}

@end
