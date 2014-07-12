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
    [self setUpControlEvents];
}

#pragma mark - Properties

- (NSString *)phoneNumber
{
    if ([self.nationalPhoneNumber isEqualToString:@""]) {
        return @"";
    }
    
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
    [self.countryCodeButton setTitle:([_countryCode isEqualToString:@""] ?
                                      @"" :
                                      [NSString stringWithFormat:@"+%@", _countryCode])
                            forState:UIControlStateNormal];
}

- (void)setNationalPhoneNumber:(NSString *)nationalPhoneNumber
{
    _nationalPhoneNumber = nationalPhoneNumber;
    self.nationalPhoneNumberField.text = _nationalPhoneNumber;
}

#pragma mark - Subviews

/** Allocate and initialize subviews. */
- (void)setUpSubviews
{
    self.countryCodeButton = [[UIButton alloc] init];
    [self addSubview:self.countryCodeButton];
    
    #warning TODO: #5 format phone numbers as-you-type
    self.nationalPhoneNumberField = [[UITextField alloc] init];
    self.nationalPhoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.nationalPhoneNumberField];
    
    [self setUpAutolayout];
    [self resetVisualAttributes];
}

/** Set up layout constraints for subviews. */
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
    
    #warning TODO: #2 margins on button and text field
}

#pragma mark - Control events

/**
 * Register self for subviews' control events, to update properties as
 * necessary.
 */
- (void)setUpControlEvents
{
    [self.nationalPhoneNumberField addTarget:self
                                      action:@selector(textFieldDidChange:)
                            forControlEvents:UIControlEventEditingChanged];
}

/**
 * Update ::nationalPhoneNumber when nationalPhoneNumberField changes, and send
 * actions for UIControlEventEditingChanged.
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nationalPhoneNumberField) {
        // Set _nationalPhoneNumber to only the decimal characters from
        // nationalPhoneNumberField.text
        _nationalPhoneNumber = [[self.nationalPhoneNumberField.text componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""];
    }
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

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

@end
