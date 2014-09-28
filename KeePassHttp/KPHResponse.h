//
//  KPHResponse.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"

@protocol KPHResponseStringField
@end

@interface KPHResponseStringField : JSONModel

@property (nonatomic, strong) NSString *Key;
@property (nonatomic, strong) NSString *Value;

+ (instancetype)stringFieldWithKey:(NSString *)key value:(NSString *)value;

@end

@protocol KPHResponseEntry
@end

@interface KPHResponseEntry : JSONModel

@property (nonatomic, strong) NSString<Ignore> *url;
@property (nonatomic, assign) NSUInteger sortValue;

@property (nonatomic, strong) NSString *Login;
@property (nonatomic, strong) NSString<Optional> *Password;
@property (nonatomic, strong) NSString *Uuid;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSArray<KPHResponseStringField, Optional> *StringFields;

+ (instancetype)entryWithUrl:(NSString *)url name:(NSString *)name login:(NSString *)login password:(NSString *)password uuid:(NSString *)uuid stringFields:(NSArray *)stringFields;

@end

@interface KPHResponse : JSONModel

/// Mirrors the request type of KeePassRequest
@property (nonatomic, strong) NSString *RequestType;

@property (nonatomic, strong) NSString<Optional> *Error;

@property (nonatomic, assign) BOOL Success;

/// The user selected string as a result of 'associate',
/// always returned on every request
@property (nonatomic, strong) NSString<Optional> *Id;

/// response to get-logins-count, number of entries for requested Url
@property (nonatomic, assign) NSUInteger Count;

/// response the current version of KeePassHttp
@property (nonatomic, strong) NSString *Version;

/// response an unique hash of the database composed of RootGroup UUid and RecycleBin UUid
@property (nonatomic, strong) NSString *Hash;

/// The resulting entries for a get-login request
@property (nonatomic, strong) NSArray<KPHResponseEntry, Optional> *Entries;

/// Nonce value used in conjunction with all encrypted fields,
/// randomly generated for each request
@property (nonatomic, strong) NSString<Optional> *Nonce;

/// Same purpose as Request.Verifier, but a new value
@property (nonatomic, strong) NSString<Optional> *Verifier;

+ (instancetype)responseWithRequestType:(NSString *)requestType hash:(NSString *)hash;

@end
