//
//  ESSPhoneNumberField.m
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSPhoneNumberField.h"
#import "ESSCountryChooser.h"

#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"

@interface ESSPhoneNumberField ()

/**
 * A button designed to present a modal ESSCountryChooser when tapped. Displays
 * ::countryCode. Recommended use: present a modal country chooser on touch up
 * inside this button, and set the phone number field as its delegate.
 */
@property (readwrite, nonatomic) UIButton *countryCodeButton;
/**
 * A text field where the user enters the national portion of the phone number,
 * ::nationalPhoneNumber.
 */
@property (readwrite, nonatomic) UITextField *nationalPhoneNumberField;

@end

@implementation ESSPhoneNumberField
#warning TODO: #8 optionally validate number as you type
#pragma mark - Constants

NSString * const kESSPhoneNumberFieldDefaultPlaceholder = @"Phone number";
NSString * const kESSPhoneNumberFieldMaxWidthString = @" +888 ";
CGFloat const kESSPhoneNumberFieldLeftPadding = 8.0f;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

/** Universal initializer - called by ::initWithFrame and ::initWithCoder. */
- (void)initialize
{
    [self setUpSubviews];
}

#pragma mark - Properties

- (NSString *)phoneNumberE164
{
    if ([self.nationalPhoneNumber isEqualToString:@""]) {
        return @"";
    }
    
    return [self phoneNumberWithFormat:NBEPhoneNumberFormatE164];
}

- (NSString *)nationalPhoneNumberFormatted
{
    NSString *phoneNumber = [self phoneNumberWithFormat:NBEPhoneNumberFormatINTERNATIONAL];
    
    NSUInteger countryCodeEndIndex = self.countryCode.length + 2; // extra chars for + and space
    if (phoneNumber.length >= countryCodeEndIndex &&
        [[phoneNumber substringToIndex:countryCodeEndIndex] isEqualToString:[NSString stringWithFormat:@"+%@ ", self.countryCode]]) {
        
        phoneNumber = [phoneNumber substringFromIndex:countryCodeEndIndex];
    }
    
    return phoneNumber;
}

- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    [self.countryCodeButton setTitle:([_countryCode isEqualToString:@""] ?
                                      @"" :
                                      [NSString stringWithFormat:@"+%@", _countryCode])
                            forState:UIControlStateNormal];
}

- (void)setNationalPhoneNumber:(NSString *)nationalPhoneNumber
{
    _nationalPhoneNumber = nationalPhoneNumber;
    
    if ([nationalPhoneNumber isEqualToString:@""]) {
        self.nationalPhoneNumberField.text = @"";
    } else {
        self.nationalPhoneNumberField.text = [self nationalPhoneNumberFormatted];
    }
}

/** Helper to return formatted versions of the phone number. */
- (NSString *)phoneNumberWithFormat:(NBEPhoneNumberFormat)format
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NBPhoneNumber *phoneNumber = [[NBPhoneNumber alloc] init];
    phoneNumber.countryCode = [formatter numberFromString:self.countryCode];
    phoneNumber.nationalNumber = [formatter numberFromString:self.nationalPhoneNumber];
    
    return [[NBPhoneNumberUtil sharedInstance] format:phoneNumber numberFormat:format error:nil];
}

/** Returns only the decimal digit characters from the string argument. */
- (NSString *)numberCharactersFromString:(NSString *)string
{
    return [[string componentsSeparatedByCharactersInSet:
             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
}

#pragma mark - Subviews

/** Allocates and initializes subviews. */
- (void)setUpSubviews
{
    self.countryCodeButton = [[UIButton alloc] init];
    [self addSubview:self.countryCodeButton];
    
    self.nationalPhoneNumberField = [[UITextField alloc] init];
    self.nationalPhoneNumberField.delegate = self;
    self.nationalPhoneNumberField.placeholder = kESSPhoneNumberFieldDefaultPlaceholder;
    self.nationalPhoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.nationalPhoneNumberField];
    
    [self setUpAutolayout];
    [self styleSubviews];
}

/** Sets up layout constraints for subviews. */
- (void)setUpAutolayout
{
    self.countryCodeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.nationalPhoneNumberField.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = nil;
    NSString *visualFormat = @"";
    NSLayoutFormatOptions options = 0;
    NSDictionary *metrics = @{};
    NSDictionary *views = @{@"button" : self.countryCodeButton,
                            @"field"  : self.nationalPhoneNumberField};
    
    visualFormat = @"H:|[button][field]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:options
                                                          metrics:metrics
                                                            views:views];
    [self addConstraints:constraints];
    
    visualFormat = @"V:|[button]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:options
                                                          metrics:metrics
                                                            views:views];
    [self addConstraints:constraints];
    
    visualFormat = @"V:|[field]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:options
                                                          metrics:metrics
                                                            views:views];
    [self addConstraints:constraints];
    
    UIFont *font = self.countryCodeButton.titleLabel.font;
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize textSize = [kESSPhoneNumberFieldMaxWidthString sizeWithAttributes:attributes];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.countryCodeButton
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:textSize.width];
    [self addConstraint:constraint];
}

- (void)styleSubviews
{
    self.countryCodeButton.backgroundColor = [UIColor grayColor];
    self.countryCodeButton.titleLabel.textColor = [UIColor whiteColor];
    
    self.nationalPhoneNumberField.backgroundColor = [UIColor lightGrayColor];
    self.nationalPhoneNumberField.textColor = [UIColor whiteColor];
    self.nationalPhoneNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.nationalPhoneNumberField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kESSPhoneNumberFieldLeftPadding, 0)];
    self.nationalPhoneNumberField.leftView = paddingView;
    self.nationalPhoneNumberField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - Control events

- (UIControlEvents)allControlEvents
{
    return UIControlEventEditingChanged;
}

#pragma mark - ESSCountryChooserDelegate

- (void)countryChooser:(ESSCountryChooser *)countryChooser didSelectCountry:(ESSCountry *)country;
{
    self.countryCode = country.callingCode;
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if (textField != self.nationalPhoneNumberField) {
        return YES;
    }
    
    #warning TODO: #7 limit insertion to 15 characters, including country code
    
    // Replace the characters
    NSString *substringBeforeRange = [textField.text substringToIndex:range.location];
    NSString *digitsBeforeRange = [self numberCharactersFromString:substringBeforeRange];
    
    NSString *substringInRange = [textField.text substringWithRange:range];
    NSString *digitsInRange = [self numberCharactersFromString:substringInRange];
    
    NSString *substringAfterRange = [textField.text substringFromIndex:(range.location + range.length)];
    NSString *digitsAfterRange = [self numberCharactersFromString:substringAfterRange];
    
    NSString *replacementDigits = [self numberCharactersFromString:replacementString];
    
    if (digitsInRange.length == 0 && substringInRange.length > 0 &&
        replacementDigits.length == 0 && replacementString.length == 0) {
        // Trying to delete only formatting characters
        // Instead, delete exactly one digit
        if (digitsBeforeRange.length > 0) {
            digitsBeforeRange = [digitsBeforeRange substringToIndex:digitsBeforeRange.length - 1];
        }
    }
    
    self.nationalPhoneNumber = [NSString stringWithFormat:@"%@%@%@", digitsBeforeRange, replacementDigits, digitsAfterRange];
    
    // Put the cursor back where it belongs
    NSUInteger cursorIndex = [self string:self.nationalPhoneNumberField.text indexAfterNthDigit:digitsBeforeRange.length] + replacementDigits.length;
    UITextPosition *cursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorIndex];
    UITextRange *cursorRange = [textField textRangeFromPosition:cursorPosition toPosition:cursorPosition];
    textField.selectedTextRange = cursorRange;
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

/**
 * Returns the index one greater than that of the n-th numerical character in
 * string. If string contains less than n numerical characters, 
 * 
 * Example: string:@"(323) 555-0123" indexAfterNthDigit:4 returns 7.
 */
- (NSUInteger)string:(NSString *)string indexAfterNthDigit:(NSUInteger)n
{
    if (n < 1) { return 0; }
    
    NSUInteger index = 0;
    NSUInteger numberCharacterCount = 0;
    
    NSUInteger length = string.length;
    unichar buffer[length + 1];
    [string getCharacters:buffer];
    
    for (int i = 0; i < length; i++) {
        if (isdigit(buffer[i])) {
            index = i + 1;
            numberCharacterCount++;
            
            if (numberCharacterCount == n) {
                break;
            }
        }
    }
    
    return index;
}

@end
