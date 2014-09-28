//
//  KPHRequest.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


static NSString *const kKPHRequestGetLogins = @"get-logins";
static NSString *const kKPHRequestGetLoginsCount = @"get-logins-count";
static NSString *const kKPHRequestGetAllLogins = @"get-all-logins";
static NSString *const kKPHRequestSetLogin = @"set-login";
static NSString *const kKPHRequestAssociate = @"associate";
static NSString *const kKPHRequestTestAssociate = @"test-associate";
static NSString *const kKPHRequestGeneratePassword = @"generate-password";

@interface KPHRequest : JSONModel

@property (nonatomic, strong) NSString *RequestType;

/// Sort selection by best URL matching for given hosts
@property (nonatomic, assign) BOOL SortSelection;

/// Trigger unlock of database even if feature is disabled in KPH (because of user interaction to fill-in)
@property (nonatomic, strong) NSString<Optional> *TriggerUnlock;

/// Always encrypted, used with set-login, uuid is set
/// if modifying an existing login
@property (nonatomic, strong) NSString<Optional> *Login;
@property (nonatomic, strong) NSString<Optional> *Password;
@property (nonatomic, strong) NSString<Optional> *Uuid;

/// Always encrypted, used with get and set-login
@property (nonatomic, strong) NSString<Optional> *Url;

/// Always encrypted, used with get-login
@property (nonatomic, strong) NSString<Optional> *SubmitUrl;

/// Send the AES key ID with the 'associate' request
@property (nonatomic, strong) NSString<Optional> *Key;

/// Always required, an identifier given by the KeePass user
@property (nonatomic, strong) NSString<Optional> *Id;

/// A value used to ensure that the correct key has been chosen,
/// it is always the value of Nonce encrypted with Key
@property (nonatomic, strong) NSString<Optional> *Verifier;

/// Nonce value used in conjunction with all encrypted fields,
/// randomly generated for each request
@property (nonatomic, strong) NSString<Optional> *Nonce;

/// Realm value used for filtering results. Always encrypted.
@property (nonatomic, strong) NSString<Optional> *Realm;

@end