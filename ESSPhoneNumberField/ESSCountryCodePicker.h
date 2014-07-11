//
//  ESSCountryCodePicker.h
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESSCountryCodePicker;


@protocol ESSCountryCodePickerDelegate <NSObject>

@required
- (void)countryCodePicker:(ESSCountryCodePicker *)countryCodePicker didSelectCountryWithCallingCode:(NSString *)callingCode;
@optional
- (void)countryCodePickerCanceled:(ESSCountryCodePicker *)countryCodePicker;

@end


@interface ESSCountryCodePicker : UITableViewController

@property (weak, nonatomic) id<ESSCountryCodePickerDelegate> delegate;

/**
 * The row containing the default locale, and its corresponding country code, is
 * displayed at the top of the list, and is selected by default. By default,
 * defaultLocale is set to the device's current locale. If nil, no row will be
 * displayed at the top or selected by default.
 */
@property (nonatomic) NSLocale *defaultLocale;


@end
