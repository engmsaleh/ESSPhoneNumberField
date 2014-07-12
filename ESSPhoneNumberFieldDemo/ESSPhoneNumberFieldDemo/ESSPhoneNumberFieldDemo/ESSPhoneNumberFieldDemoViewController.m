//
//  ESSPhoneNumberFieldDemoViewController.m
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSPhoneNumberFieldDemoViewController.h"
#import "ESSPhoneNumberField.h"

@interface ESSPhoneNumberFieldDemoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet ESSPhoneNumberField *phoneNumberField;
@property (nonatomic) UINavigationController *modalNavigationController;
@property (nonatomic) ESSCountryChooser *countryCodePicker;

@end

@implementation ESSPhoneNumberFieldDemoViewController

static NSString * const kESSPhoneNumberFieldDemoDefaultLabelText = @"Enter a phone number above.";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.text = kESSPhoneNumberFieldDemoDefaultLabelText;
    
    self.countryCodePicker = [[ESSCountryChooser alloc] initWithStyle:UITableViewStylePlain];
    self.countryCodePicker.delegate = self.phoneNumberField;
    
    self.modalNavigationController = [[UINavigationController alloc] initWithRootViewController:self.countryCodePicker];
    
    self.phoneNumberField.countryCode = self.countryCodePicker.selectedCountry.callingCode;
    [self.phoneNumberField.countryCodeButton addTarget:self
                                                action:@selector(showCountryCodePicker)
                                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.phoneNumberField addTarget:self
                              action:@selector(updateLabel)
                    forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Actions
     
- (void)showCountryCodePicker
{
    [self.navigationController presentViewController:self.modalNavigationController animated:YES completion:nil];
}

- (void)updateLabel
{
    self.label.text = self.phoneNumberField.phoneNumberE164 && ![self.phoneNumberField.phoneNumberE164 isEqualToString:@""] ?
                      [NSString stringWithFormat:@"Entered: %@", self.phoneNumberField.nationalPhoneNumberFormatted] :
                      kESSPhoneNumberFieldDemoDefaultLabelText;
}

@end
