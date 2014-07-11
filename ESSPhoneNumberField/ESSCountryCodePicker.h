//
//  ESSCountryCodePicker.h
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSCountry.h"

#import <UIKit/UIKit.h>

@class ESSCountryCodePicker;

#pragma mark - ESSCountryCodePickerDelegate

@protocol ESSCountryCodePickerDelegate <NSObject>

@required
- (void)countryCodePicker:(ESSCountryCodePicker *)countryCodePicker didSelectCountry:(ESSCountry *)country;
@optional
- (void)countryCodePickerDidCancel:(ESSCountryCodePicker *)countryCodePicker;

@end

#pragma mark - ESSCountryCodePicker

@interface ESSCountryCodePicker : UITableViewController

@property (weak, nonatomic) id<ESSCountryCodePickerDelegate> delegate;

/**
 * The row containing the default locale, and its corresponding country code, is
 * displayed at the top of the list, and is selected by default. By default,
 * defaultLocale is set to the device's current locale. If nil, no row will be
 * displayed at the top or selected by default.
 */
@property (nonatomic) NSLocale *defaultLocale;
/** To set, use ::defaultLocale. */
@property (readonly, nonatomic) ESSCountry *defaultCountry;
@property (nonatomic) ESSCountry *selectedCountry;

/** Cancels the picker without changing ::selectedCountry. */
- (void)cancelPicker;

@end
