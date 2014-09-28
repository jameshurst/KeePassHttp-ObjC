//
//  KPHRequest.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHRequest.h"

@implementation KPHRequest

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:@"SortSelection"])
        return YES;
    
    return NO;
}

@end
