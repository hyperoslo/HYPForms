//
//  REMAInputValidator.m
//
//  Created by Christoffer Winterkvist on 22/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAInputValidator.h"
#import "REMANumberInputValidator.h"
#import "NSString+ZENInflections.h"

static NSString * const REMAInputValidatorClass = @"REMA%@InputValidator";

@implementation REMAInputValidator

+ (Class)validatorClass:(NSString *)string
{
    NSString *classString = [NSString stringWithFormat:REMAInputValidatorClass, [string zen_upperCamelCase]];
    return NSClassFromString(classString);
}

- (BOOL)validateReplacementString:(NSString *)string withText:(NSString *)text
{
    if (!self.validations) return YES;

    NSUInteger textLength = [text length];
    if (string.length > 0) {
        textLength++;
    }

    BOOL valid = (self.validations[@"required"] != nil);

    if (valid && self.validations[@"max_length"]) {
        valid = (textLength <= [self.validations[@"max_length"] unsignedIntegerValue]);
    }

    return valid;
}

- (BOOL)validateText:(NSString *)text
{
    return [self validateReplacementString:nil withText:text];
}

- (BOOL)validateString:(NSString *)fieldValue withFormat:(NSString *)format
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.validations[@"format"] options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:fieldValue options:NSMatchingReportProgress range:NSMakeRange(0, fieldValue.length)];
    return (numberOfMatches > 0);
}

@end
