//
//  KPHTestAssociateHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHTestAssociateHandler.h"

@implementation KPHTestAssociateHandler

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server
{
    [super handle:request response:response server:server];
    
    if (![self verifyRequest:request])
        return;
    
    response.Id = request.Id;
    response.Success = YES;
    
    [self setResponseVerifier:response];
    
    return;
}

@end
