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
@property (nonatomic) UIButton *countryCodeButton;
/**
 * A text field where the user enters the national portion of the phone number,
 * ::nationalPhoneNumber.
 */
@property (nonatomic) UITextField *nationalPhoneNumberField;

@end

@implementation ESSPhoneNumberField

#pragma mark - Constants

static NSString * const kESSPhoneNumberFieldMaxWidthString = @"+888";

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    self.countryCodeButton = [[UIButton alloc] init];
    [self addSubview:self.countryCodeButton];
    
    #warning TODO: format phone numbers as-you-type
    self.nationalPhoneNumberField = [[UITextField alloc] init];
    self.nationalPhoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.nationalPhoneNumberField];
    
    [self setUpAutolayout];
    [self resetVisualAttributes];
}

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

- (void)resetVisualAttributes
{
    self.countryCodeButton.backgroundColor = [UIColor grayColor];
    self.countryCodeButton.titleLabel.textColor = [UIColor whiteColor];
    self.nationalPhoneNumberField.backgroundColor = [UIColor lightGrayColor];
    
    #warning TODO: phone number field border
    #warning TODO: margins on button and text field
}

#pragma mark - Properties

- (NSString *)phoneNumber
{
    #warning TODO: send phone number field edit events
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NBPhoneNumber *phoneNumber = [[NBPhoneNumber alloc] init];
    phoneNumber.countryCode = [formatter numberFromString:self.countryCode];
    phoneNumber.nationalNumber = [formatter numberFromString:self.nationalPhoneNumber];
    
    return [[NBPhoneNumberUtil sharedInstance] format:phoneNumber numberFormat:NBEPhoneNumberFormatE164 error:nil];
}

- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    [self.countryCodeButton setTitle:[NSString stringWithFormat:@"+%@", _countryCode] forState:UIControlStateNormal];
}

- (void)setNationalPhoneNumber:(NSString *)nationalPhoneNumber
{
    _nationalPhoneNumber = nationalPhoneNumber;
    self.nationalPhoneNumberField.text = _nationalPhoneNumber;
}

#pragma mark - ESSCountryChooserDelegate

- (void)countryChooser:(ESSCountryChooser *)countryChooser didSelectCountry:(ESSCountry *)country;
{
    self.countryCode = country.callingCode;
}

@end
