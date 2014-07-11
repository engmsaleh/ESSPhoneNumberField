//
//  ESSPhoneNumberField.h
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSCountryCodePicker.h"

@interface ESSPhoneNumberField : UIControl <ESSCountryCodePickerDelegate>

/**
 * A button designed to present a modal ESSCountryCodePicker when tapped.
 * Displays ::countryCode. Recommended use: present a modal country code picker
 * on touch up inside this button, and set the phone number field as its
 * delegate.
 */
@property (readonly, nonatomic) UIButton *countryCodeButton;
/**
 * A text field where the user enters the local portion of the phone number,
 * ::localPhoneNumber.
 */
@property (readonly, nonatomic) UITextField *localPhoneNumberField;

/** The phone number, in E.164 format, displayed in the phone number field. */
@property (readonly, nonatomic) NSString *phoneNumber;
/** The country calling code displayed in the phone number field. */
@property (readonly, nonatomic) NSString *countryCode;
/** The local portion of the phone number displayed in the phone number field. */
@property (readonly, nonatomic) NSString *localPhoneNumber;

/** Reset the phone number field's appearance to the default values. */
- (void)resetVisualAttributes;

@end
