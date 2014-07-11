//
//  ESSCountryCodePicker.m
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSCountryCodePicker.h"

#import "CountryPicker.h"
#import "NBPhoneNumberUtil.h"


#pragma mark - ESSCountry

@interface ESSCountry : NSObject

/** ISO two-letter country code */
@property (nonatomic) NSString *regionCode;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *callingCode;

+ (instancetype)countryWithRegionCode:(NSString *)regionCode
                           name:(NSString *)name
                    callingCode:(NSString *)callingCode;

@end

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

#pragma mark - ESSCountryCodePicker

@interface ESSCountryCodePicker ()

/**
 * Mutable dictionary of NSArrays where keys are section titles and values are
 * NSArrays of ESSCountry objects corresponding to that section. Within a
 * section, countries are sorted alphabetically.
 */
@property (nonatomic) NSMutableDictionary *countries;
/** Equivalent to [countries allKeys]. */
@property (nonatomic) NSArray *countrySectionTitles;

@end


@implementation ESSCountryCodePicker

#pragma mark - Constants

/** Reuse identifier for table view cells. */
static NSString * const kESSCountryCodePickerReuseIdentifier = @"kESSCountryCodePickerReuseIdentifier";

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initializeData];
//        [self.tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:kESSCountryCodePickerReuseIdentifier];
    }
    return self;
}

- (void)initializeData
{
    self.defaultLocale = [NSLocale currentLocale];
    
    self.countries = [NSMutableDictionary dictionary];
    for (NSString *regionCode in [CountryPicker countryCodes]) {
        NSString *name = [[CountryPicker countryNamesByCode] objectForKey:regionCode];
        NSString *callingCode = [[NBPhoneNumberUtil sharedInstance] countryCodeFromRegionCode:regionCode];
        ESSCountry *country = [ESSCountry countryWithRegionCode:regionCode name:name callingCode:callingCode];
        
        NSString *key = [country.name substringToIndex:1];
        NSMutableArray *array = self.countries[key] ? self.countries[key] : [NSMutableArray array];
        [array addObject:country];
        self.countries[key] = array;
    }
    
    NSMutableArray *titles = [NSMutableArray arrayWithArray:[self.countries.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [titles insertObject:UITableViewIndexSearch atIndex:0];
    self.countrySectionTitles = titles;
    
    [self reloadDefaultCountry];
}

/** Resets the first section of ::countries to reflect ::defaultLocale. */
- (void)reloadDefaultCountry
{
    NSString *regionCode = nil;
    NSString *name = nil;
    NSString *callingCode = nil;
    ESSCountry *defaultCountry = [ESSCountry countryWithRegionCode:regionCode name:name callingCode:callingCode];
    self.countries[UITableViewIndexSearch] = @[defaultCountry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (void)setDefaultLocale:(NSLocale *)defaultLocale
{
    _defaultLocale = defaultLocale;
    [self reloadDefaultCountry];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.countrySectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = self.countrySectionTitles[section];
    NSArray *sectionCountries = self.countries[sectionTitle];
    return sectionCountries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kESSCountryCodePickerReuseIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kESSCountryCodePickerReuseIdentifier];
    
    NSString *sectionTitle = self.countrySectionTitles[indexPath.section];
    NSArray *sectionCountries = self.countries[sectionTitle];
    ESSCountry *country = sectionCountries[indexPath.row];
    cell.textLabel.text = country.name;
    
    return cell;
}

@end
