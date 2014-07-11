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
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPicker)];
    }
    return self;
}

- (void)initializeData
{
    self.defaultLocale = [NSLocale currentLocale];
    self.selectedCountry = self.defaultCountry;
    
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
    
    [self reloadCountries];
}

/** Resets the first section of ::countries to reflect ::defaultLocale. */
- (void)reloadCountries
{
    self.countries[UITableViewIndexSearch] = @[self.defaultCountry];
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
    [self reloadCountries];
}

- (ESSCountry *)defaultCountry
{
    NSString *regionCode = [self.defaultLocale objectForKey:NSLocaleCountryCode];
    NSString *name = [[CountryPicker countryNamesByCode] objectForKey:regionCode];
    NSString *callingCode = [[NBPhoneNumberUtil sharedInstance] countryCodeFromRegionCode:regionCode];
    return [ESSCountry countryWithRegionCode:regionCode name:name callingCode:callingCode];
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
    cell.textLabel.text = [NSString stringWithFormat:@"+%@ %@", country.callingCode, country.name];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.countrySectionTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.countrySectionTitles;
}

#pragma mark - Actions

- (void)cancelPicker
{
    if ([self.delegate respondsToSelector:@selector(countryCodePickerDidCancel:)]) {
        [self.delegate countryCodePickerDidCancel:self];
    }
    [self.navigationController dismissViewControllerAnimated:self completion:nil];
}

@end
