//
//  KPHResponse.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHResponse.h"

@implementation KPHResponseStringField

+ (instancetype)stringFieldWithKey:(NSString *)key value:(NSString *)value
{
    KPHResponseStringField *stringField = [KPHResponseStringField new];
    stringField.Key = key;
    stringField.Value = value;
    return stringField;
}

@end

@implementation KPHResponseEntry

+ (instancetype)entryWithUrl:(NSString *)url name:(NSString *)name login:(NSString *)login password:(NSString *)password uuid:(NSString *)uuid stringFields:(NSArray<KPHResponseStringField, Optional> *)stringFields
{
    KPHResponseEntry *entry = [KPHResponseEntry new];
    entry.url = url;
    entry.Name = name;
    entry.Login = login;
    entry.Password = password;
    entry.Uuid = uuid;
    entry.StringFields = stringFields;
    return entry;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"sortValue"])
        return YES;
    
    return NO;
}

@end

@implementation KPHResponse

- (instancetype)init
{
    if (self = [super init])
    {
        _Success = NO;
        _Version = @"KeePassHttp-ObjC";
    }
    return self;
}

+ (instancetype)responseWithRequestType:(NSString *)requestType hash:(NSString *)hash
{
    KPHResponse *response = [KPHResponse new];
    response.RequestType = requestType;
    response.Hash = hash;
    return response;
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:@"Count"])
        return YES;
    
    return NO;
}

@end
