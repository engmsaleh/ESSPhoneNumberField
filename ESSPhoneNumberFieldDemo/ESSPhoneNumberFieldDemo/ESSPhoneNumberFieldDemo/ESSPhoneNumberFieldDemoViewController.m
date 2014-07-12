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
@property (nonatomic) ESSCountryChooser *countryChooser;

@end

@implementation ESSPhoneNumberFieldDemoViewController

static NSString * const kESSPhoneNumberFieldDemoDefaultLabelText = @"Enter a phone number above.";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.text = kESSPhoneNumberFieldDemoDefaultLabelText;
    
    self.countryChooser = [[ESSCountryChooser alloc] initWithStyle:UITableViewStylePlain];
    self.countryChooser.delegate = self.phoneNumberField;
    self.countryChooser.defaultLocale = [NSLocale localeWithLocaleIdentifier:@"es_AR"];
    
    self.modalNavigationController = [[UINavigationController alloc] initWithRootViewController:self.countryChooser];
    
    self.phoneNumberField.countryCode = self.countryChooser.selectedCountry.callingCode;
    [self.phoneNumberField.countryCodeButton addTarget:self
                                                action:@selector(showCountryCodePicker)
                                      forControlEvents:UIControlEventTouchUpInside];
    [self.phoneNumberField countryChooser:self.countryChooser didSelectCountry:self.countryChooser.defaultCountry];
    
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
    self.label.text = self.phoneNumberField.phoneNumberE164 && self.phoneNumberField.nationalPhoneNumber ?
                      [NSString stringWithFormat:@"Entered (E.164): %@", self.phoneNumberField.phoneNumberE164] :
                      kESSPhoneNumberFieldDemoDefaultLabelText;
}

@end
