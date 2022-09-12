//
//  NSString+Validation.h
//  EasyCheckout
//
//  Created by SamsoDeveloper on 8/18/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

+ (NSString*)nullCheck:(NSString*)stringValue;
- (BOOL)isValidEmail;
- (BOOL)isValidUrl;
- (BOOL)isValidRoomNumber;
- (BOOL)isValidName;
- (BOOL)isValidNumber;
- (BOOL)isValidInteger;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidDocumentNumber;
- (BOOL)isValidAddress;
- (BOOL)isAlphaNumeric;
- (BOOL)isAlphaNumericNoSpace;
- (BOOL)isAlphaSpace;

@end
