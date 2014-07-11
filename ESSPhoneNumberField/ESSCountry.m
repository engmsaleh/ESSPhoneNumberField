//
//  ESSCountry.m
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSCountry.h"

@implementation ESSCountry

+ (instancetype)countryWithRegionCode:(NSString *)regionCode
                                 name:(NSString *)name
                          callingCode:(NSString *)callingCode
{
    ESSCountry *country = [[self alloc] init];
    if (country) {
        country.regionCode = regionCode;
        country.name = name;
        country.callingCode = callingCode;
    }
    return country;
}

@end
