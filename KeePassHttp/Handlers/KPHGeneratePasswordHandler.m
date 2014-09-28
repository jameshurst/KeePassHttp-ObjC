//
//  KPHGeneratePasswordHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-25.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHGeneratePasswordHandler.h"

@implementation KPHGeneratePasswordHandler

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server
{
    [super handle:request response:response server:server];
    
    if (![self verifyRequest:request])
        return;
    
    NSString *key = [self delegateKeyForLabel:request.Id];
    if (!key)
        return;
    
    NSString *password = [self delegateGeneratePassword];
    
    response.Id = request.Id;
    [self setResponseVerifier:response];
    
    if (password)
    {
        KPHAESConfig *aes = [KPHAESConfig aesWithKey:key base64key:YES IV:response.Nonce base64IV:YES];
        response.Entries = [KPHUtils encryptEntries:@[[KPHResponseEntry entryWithUrl:nil name:@"generate-password" login:@"" password:password uuid:@"generate-password" stringFields:nil]] withAES:aes];
        response.Count = 1;
        response.Success = YES;
    }
    
    return;
}


@end
