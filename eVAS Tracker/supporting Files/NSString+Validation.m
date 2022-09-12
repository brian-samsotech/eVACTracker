//
//  NSString+Validation.m
//  EasyCheckout
//
//  Created by SamsoDeveloper on 8/18/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#define ALPHA         @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC       @"1234567890"
#define ALPHA_NUMERIC ALPHA NUMERIC

#import "NSString+Validation.h"

@implementation NSString (Validation)

+ (NSString*)nullCheck:(NSString*)stringValue
{
    if(!stringValue || [stringValue isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", stringValue];
}

- (BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self] && ![self containsString:@" "];
}

- (BOOL)isValidUrl
{
    NSURL *url = [NSURL URLWithString:self];
    return (url && url.scheme && url.host);
}

- (BOOL)isValidRoomNumber
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA_NUMERIC] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isValidName
{
    NSString *alphaSpace = [NSString stringWithFormat:@"%@. ", ALPHA];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:alphaSpace] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isValidNumber
{
    NSString *str = [NSString stringWithFormat:@"%@.", NUMERIC];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isValidInteger
{
    NSString *str = [NSString stringWithFormat:@"%@", NUMERIC];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isValidPhoneNumber
{
    NSString *str = [NSString stringWithFormat:@"%@+ ", NUMERIC];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isValidDocumentNumber
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA_NUMERIC] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isValidAddress
{
    //#, _, &, :, .
    NSString *str = [NSString stringWithFormat:@"%@ #-_&:;,./\\", ALPHA_NUMERIC];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isAlphaNumeric
{
    NSString *str = [NSString stringWithFormat:@"%@ ", ALPHA_NUMERIC];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isAlphaNumericNoSpace
{
//    NSString *str = [NSString stringWithFormat:@"%@", ALPHA_NUMERIC];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA_NUMERIC] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)isAlphaSpace
{
    NSString *alphaSpace = [NSString stringWithFormat:@"%@ ", ALPHA];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:alphaSpace] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

@end
