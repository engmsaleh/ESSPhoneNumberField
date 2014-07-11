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

@end
