//
//  KPHAssociateHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHAssociateHandler.h"

@implementation KPHAssociateHandler

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server
{
    [super handle:request response:response server:server];
    
    if (![self verifyRequest:request withKey:request.Key])
        return;
    
    NSString *label = [self delegateLabelForKey:request.Key];
    if (label)
    {
        response.Id = label;
        response.Success = YES;
        
        [self setResponseVerifier:response];
    }
    
    return;
}

@end
