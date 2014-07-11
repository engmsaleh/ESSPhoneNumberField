//
//  ESSCountryChooser.m
//  ESSPhoneNumberFieldDemo
//
//  Created by Erik Strottmann on 7/11/14.
//  Copyright (c) 2014 Erik Strottmann. All rights reserved.
//

#import "ESSCountryChooser.h"

#import "CountryPicker.h"
#import "NBPhoneNumberUtil.h"

@interface ESSCountryChooser ()

/**
 * Mutable dictionary of NSArrays where keys are section titles and values are
 * NSArrays of ESSCountry objects corresponding to that section. Within a
 * section, countries are sorted alphabetically.
 */
@property (nonatomic) NSMutableDictionary *countries;
/** Equivalent to [countries allKeys]. The titles for section headers. */
@property (nonatomic) NSMutableArray *countrySectionTitles;
/** The titles for the section index (quick jump) on the right of the screen. */
@property (nonatomic) NSMutableArray *countryIndexTitles;

@end

@implementation ESSCountryChooser

#pragma mark - Constants

/** Default value for ::defaultSectionTitle. */
NSString * const kESSCountryChooserDefaultDefaultSectionTitle = @"Current Region";
/** Reuse identifier for table view cells. */
NSString * const kESSCountryChooserReuseIdentifier = @"kESSCountryChooserReuseIdentifier";

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initializeData];
//        [self.tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:kESSCountryChooserReuseIdentifier];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChooser)];
    }
    return self;
}

- (void)initializeData
{
    self.defaultLocale = [NSLocale currentLocale];
    self.selectedCountry = self.defaultCountry;
    self.defaultSectionTitle = kESSCountryChooserDefaultDefaultSectionTitle;
    
    #warning TODO: wean off CountryPicker
    
    self.countries = [NSMutableDictionary dictionary];
    for (NSString *regionCode in [CountryPicker countryCodes]) {
        NSString *name = [[CountryPicker countryNamesByCode] objectForKey:regionCode];
        NSString *callingCode = [[NBPhoneNumberUtil sharedInstance] countryCodeFromRegionCode:regionCode];
        
        if (callingCode) {
            ESSCountry *country = [ESSCountry countryWithRegionCode:regionCode name:name callingCode:callingCode];
            
            NSString *key = [country.name substringToIndex:1];
            NSMutableArray *array = self.countries[key] ? self.countries[key] : [NSMutableArray array];
            [array addObject:country];
            self.countries[key] = array;
        }
    }
    
    NSMutableArray *sectionTitles = [NSMutableArray arrayWithArray:[self.countries.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    self.countrySectionTitles = sectionTitles;
    [self reloadCountrySectionTitles]; // insert the default section title
    
    NSMutableArray *indexTitles = [NSMutableArray arrayWithArray:[self.countries.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [indexTitles insertObject:UITableViewIndexSearch atIndex:0];
    self.countryIndexTitles = indexTitles;
    
    [self reloadCountries]; // insert the default section
}

/**
 * Resets the object for key ::defaultSectionTitle in ::countries, as well as
 * the first section in ::countrySectionTitles, to reflect ::defaultCountry
 * when it changes (i.e. when defaultLocale changes).
 */
- (void)reloadCountries
{
    if (self.defaultCountry) {
        self.countries[self.defaultSectionTitle] = @[self.defaultCountry];
    } else {
        [self.countries removeObjectForKey:self.defaultSectionTitle];
    }
}

- (void)reloadCountrySectionTitles
{
    if (self.defaultCountry) {
        if (![self.countrySectionTitles containsObject:self.defaultSectionTitle]) {
            [self.countrySectionTitles insertObject:self.defaultSectionTitle atIndex:0];
        }
    } else {
        [self.countrySectionTitles removeObject:self.defaultSectionTitle];
    }
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
    [self reloadCountrySectionTitles];
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
    #warning TODO: custom table view cell
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kESSCountryChooserReuseIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kESSCountryChooserReuseIdentifier];
    
    ESSCountry *country = [self countryAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"+%@ %@", country.callingCode, country.name];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.countrySectionTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.countryIndexTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCountry = [self countryAtIndexPath:indexPath];
    [self.delegate countryChooser:self didSelectCountry:self.selectedCountry];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:@selector(dismissChooser) withObject:nil afterDelay:0.3f];
//    [self dismissChooser];
}

#pragma mark - Actions

- (void)dismissChooser
{
    [self.navigationController dismissViewControllerAnimated:self completion:nil];
}

- (void)cancelChooser
{
    if ([self.delegate respondsToSelector:@selector(countryChooserDidCancel:)]) {
        [self.delegate countryChooserDidCancel:self];
    }
    [self dismissChooser];
}

#pragma mark - Helpers

- (ESSCountry *)countryAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = self.countrySectionTitles[indexPath.section];
    NSArray *sectionCountries = self.countries[sectionTitle];
    return sectionCountries[indexPath.row];
}

@end
