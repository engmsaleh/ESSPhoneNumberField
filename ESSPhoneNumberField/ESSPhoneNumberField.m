//
//  ESSPhoneNumberField.m
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSPhoneNumberField.h"
#import "ESSCountryCodePicker.h"

@interface ESSPhoneNumberField ()

/**
 * A button designed to present a modal ESSCountryCodePicker when tapped.
 * Displays ::countryCode. Recommended use: present a modal country code picker
 * on touch up inside this button, and set the phone number field as its
 * delegate.
 */
@property (nonatomic) UIButton *countryCodeButton;
/**
 * A text field where the user enters the local portion of the phone number,
 * ::localPhoneNumber.
 */
@property (nonatomic) UITextField *localPhoneNumberField;

/** The country calling code displayed in the phone number field. */
@property (nonatomic) NSString *countryCode;
/** The local portion of the phone number displayed in the phone number field. */
@property (nonatomic) NSString *localPhoneNumber;

@end

@implementation ESSPhoneNumberField

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    self.countryCodeButton = [[UIButton alloc] init];
    self.localPhoneNumberField = [[UITextField alloc] init];
    
    [self setUpAutolayout];
    [self resetVisualAttributes];
}

- (void)setUpAutolayout
{
    #warning TODO: set up autolayout
}

- (void)resetVisualAttributes
{
    #warning TODO: reset visual attributes
}

#pragma mark - Properties

- (NSString *)phoneNumber
{
    #warning TODO: use libPhoneNumber to format phoneNumber
    return [NSString stringWithFormat:@"+%@%@", self.countryCode, self.localPhoneNumber];
}

- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    self.countryCodeButton.titleLabel.text = [NSString stringWithFormat:@"+%@", _countryCode];
}

- (void)setLocalPhoneNumber:(NSString *)localPhoneNumber
{
    _localPhoneNumber = localPhoneNumber;
    self.localPhoneNumberField.text = _localPhoneNumber;
}

#pragma mark - ESSCountryCodePickerDelegate

- (void)countryCodePicker:(ESSCountryCodePicker *)countryCodePicker didSelectCountryWithCallingCode:(NSString *)callingCode
{
    self.countryCode = callingCode;
}

@end
