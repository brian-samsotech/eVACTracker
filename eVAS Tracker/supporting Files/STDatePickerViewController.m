//
//  UtilitiesViewController.m
//  operamobile
//
//  Created by SamsoDeveloper on 6/11/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import "STDatePickerViewController.h"

// utilities
#import "Constants.h"
#import "StoryboardIdentifiers.h"
#import "STDateHelper.h"
//#import "DefaultTheme.h"

@interface STDatePickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSUInteger _componentCount;
    
    NSArray *_months;
    NSArray *_days;
    NSArray *_years;
    NSArray *_dateComponents;
    
    NSArray *_hours;
    NSArray *_minutes;
    NSArray *_amPm;
    NSArray *_timeComponents;
    
    NSMutableArray *_selectedRows;
    
    UIFont *_pickerLabelFont;
    UIColor *_pickerLabelColor;
    UIColor *_pickerAltLabelColor;
    
    NSInteger _selectedDayIndex;
    NSInteger _selectedMonthIndex;
    NSInteger _selectedYearIndex;
    
    NSInteger _minDay;
    NSInteger _minMonth;
    NSInteger _minYear;
    
    NSInteger _maxDay;
    NSInteger _maxMonth;
    NSInteger _maxYear;
}

// custom date picker
@property (weak, nonatomic) IBOutlet UIView *customDatePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *customDatePicker;

// custom date picker constrataints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customDatePickerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customDatePickerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customDatePickerVAlignConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customDatePickerHAlignConstraint;

@end

@implementation STDatePickerViewController
#pragma mark - Constants
NSInteger  const DATE_PICKER_SPACE     = 2;
NSInteger  const DATE_PICKER_MARGIN    = 30;
NSUInteger const DATE_PICKER_HEIGHT    = 200;
NSUInteger const DATE_PICKER_MIN_WIDTH = 250;

NSUInteger const MAX_PICKER_ROW_COUNT = 100000;
NSUInteger const DEFAULT_MIN_YEAR = 1500;
NSUInteger const DEFAULT_MAX_YEAR = 4000;

#pragma mark - Init
+ (id)storyboardInstance
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:STORYBOARD_UTILITIES bundle:[NSBundle mainBundle]];
    return [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (id)initWithViewController:(UIViewController*)containerViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:STORYBOARD_UTILITIES bundle:[NSBundle mainBundle]];
    return [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadStyle];
    
    [self.customDatePicker setDelegate:self];
    [self.customDatePicker setDataSource:self];
    
    [self loadDatePickerComponents];
    [self loadTimePickerComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Actions
- (IBAction)onCancel:(id)sender
{
    [self hide];
}

- (IBAction)onClickClearButton:(UIButton *)sender
{
    if(self.delegate &&  [self.delegate respondsToSelector:@selector(onClickClearButton)])
    {
        [self.delegate onClickClearButton];
    }
}

- (IBAction)onClickSetDateButton:(UIButton *)sender
{
    if(self.delegate)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        switch (self.mode)
        {
            case UIDatePickerModeTime:
            {
                NSInteger rowIndexHour   = [self.customDatePicker selectedRowInComponent:0];
                NSInteger rowIndexMinute = [self.customDatePicker selectedRowInComponent:1];
                NSInteger rowIndexAmPm   = [self.customDatePicker selectedRowInComponent:2];
                
                NSInteger unitHour =  (rowIndexHour + 1) % _hours.count;
                unitHour += (rowIndexAmPm == 1) ? 12: 0;
                
                [components setMinute:(rowIndexMinute % _minutes.count)];
                [components setHour:unitHour];
                
                break;
            }
                
            default: //UIDatePickerModeDate
            {
                NSInteger rowIndexDay   = [self.customDatePicker selectedRowInComponent:0];
                NSInteger rowIndexMonth = [self.customDatePicker selectedRowInComponent:1];
                NSInteger rowIndexYear  = [self.customDatePicker selectedRowInComponent:2];
                
                [components setMonth:(rowIndexMonth % _months.count) + 1];
                [components setDay  :(rowIndexDay % _days.count) + 1];
                [components setYear :[[_years objectAtIndex:rowIndexYear] intValue]];
                
                break;
            }
        }
        
        NSString *defaultDateFormat = STDateFormatDateTime; //[[NSUserDefaults standardUserDefaults] stringForKey: str_Defaults_DateFormat];
        NSDate *date = [calendar dateFromComponents:components];
        STDateHelper *dateHelper = [[STDateHelper alloc] init];
        NSLog(@"selected date: %@", [dateHelper convertDate:date toFormat:defaultDateFormat]);
        
        if([self.delegate respondsToSelector:@selector(onUpdateDateValueWithString:)])
        {
            [self.delegate onUpdateDateValueWithString:[dateHelper convertDate:date toFormat:defaultDateFormat]];
        }
        
        if([self.delegate respondsToSelector:@selector(onUpdateValueWithDate:)])
        {
            [self.delegate onUpdateValueWithDate:date];
        }
    }
    
    [self hide];
}

#pragma mark - Private
- (void)loadStyle
{
    UIColor *colorBG   = UIColor.whiteColor; // [DefaultTheme contrastPrimaryColor];
    UIColor *colorBG2  = UIColor.whiteColor; //[DefaultTheme contrastPrimaryColor];
    UIColor *colorLine = UIColor.grayColor; //[DefaultTheme primaryColor];
    
    _pickerLabelFont = [UIFont boldSystemFontOfSize:16.0]; //[DefaultTheme bodyFont2];
    _pickerLabelColor = UIColor.blackColor; //[DefaultTheme black];
    _pickerAltLabelColor = UIColor.grayColor; //[DefaultTheme grey];
    
    [self.customDatePicker setBackgroundColor:colorBG2];
    [self.customDatePickerView setBackgroundColor:colorBG];
    [self.customDatePickerView.layer setBorderColor:colorLine.CGColor];
    [self.customDatePickerView.layer setBorderWidth:1];
    [self.customDatePickerView.layer setCornerRadius:5.0];
    [self.customDatePickerView.layer setMasksToBounds:YES];
}

- (void)loadDatePickerComponents
{
    _months = @[@"JAN",
                @"FEB",
                @"MAR",
                @"APR",
                @"MAY",
                @"JUN",
                @"JUL",
                @"AUG",
                @"SEP",
                @"OCT",
                @"NOV",
                @"DEC" ];
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    for(int i = 1; i <= 31; ++i)
    {
        [mutableArr addObject:[NSNumber numberWithInt:i]];
    }
    
    _days = mutableArr.copy;
    
    mutableArr = [[NSMutableArray alloc] init];
    for(int i = DEFAULT_MIN_YEAR; i <= DEFAULT_MAX_YEAR; ++i)
    {
        [mutableArr addObject:[NSNumber numberWithInt:i]];
    }
    
    _years = mutableArr.copy;
    
    _dateComponents = @[_days, _months, _years];
}

- (void)loadTimePickerComponents
{
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    for(int i = 1; i <= 12; ++i)
    {
        [mutableArr addObject:[NSNumber numberWithInt:i]];
    }
    
    _hours = mutableArr.copy;
    
    mutableArr = [[NSMutableArray alloc] init];
    for(int i = 0; i < 60; ++i)
    {
        [mutableArr addObject:[NSNumber numberWithInt:i]];
    }
    
    _minutes = mutableArr.copy;
    _amPm = @[@"AM", @"PM"];
    _timeComponents = @[_hours, _minutes, _amPm];
}

- (void)updateConstraintsForView:(UIView*)activeView
{
    [self.view layoutIfNeeded];
}

#pragma mark - Public
- (void)setMinDate:(NSDate*)date
{
    _minDate = date;
    
    if(date == nil)
    {
        _minDay = -1;
        _minMonth = -1;
        _minYear = -1;
        
        return;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear)
                                               fromDate:date];
    
    _minDay = components.day;
    _minMonth = components.month;
    _minYear = components.year;
}

- (void)setMaxDate:(NSDate*)date
{
    _maxDate = date;
    
    if(date == nil)
    {
        _maxDay = -1;
        _maxMonth = -1;
        _maxYear = -1;
        
        return;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear)
                                               fromDate:date];
    
    _maxDay = components.day;
    _maxMonth = components.month;
    _maxYear = components.year;
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                     animations:^{
        if(![self.customDatePickerView isHidden])
        {
            [self.customDatePickerHeightConstraint setConstant:0];
        }
        
        [self.view layoutIfNeeded];
        //NSLog(@"animating...");
    }
                     completion:^(BOOL finished) {
        //NSLog(@"done");
        [self.view setHidden:finished];
        if(finished && self.delegate
           && [self.delegate respondsToSelector:@selector(onDatePickerClose)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate onDatePickerClose];
            });
        }
    }];
}

- (void)showAndAttachToView:(UIView*)activeView
{
    [self updateConstraintsForView:activeView];
    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Property Setters
- (void)setMode:(UIDatePickerMode)mode
{
    _mode = mode;
}

#pragma mark - Custom DatePicker
- (void)showDate:(NSDate*)date
{
    if(!date)
    {
        date = [NSDate date];
    }
    
    if([date compare:self.minDate] == NSOrderedAscending)
    {
        date = self.minDate;
    }
    
    if([date compare:self.maxDate] == NSOrderedDescending)
    {
        date = self.maxDate;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear)
                                               fromDate:date];
    
    // to simulate circular selection
    _selectedDayIndex   = components.day   + (_days.count   * 300) - 1;
    _selectedMonthIndex = components.month + (_months.count * 300) - 1;
    _selectedYearIndex  = [_years indexOfObject:[NSNumber numberWithInteger:components.year]];
    
    [self.customDatePicker selectRow:_selectedDayIndex   inComponent:0 animated:YES];
    [self.customDatePicker selectRow:_selectedMonthIndex inComponent:1 animated:YES];
    [self.customDatePicker selectRow:_selectedYearIndex  inComponent:2 animated:YES];
    
    [self.customDatePicker reloadAllComponents];
}

- (void)showTime:(NSDate*)time
{
    if(!time)
    {
        time = [NSDate date];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute)
                                               fromDate:time];
    
    // to simulate circular selection
    NSInteger rowIndexHour   = (components.hour % _hours.count) + (_hours.count * 100) - 1;
    NSInteger rowIndexMinute = components.minute + (_minutes.count * 100);// - 1;
    NSInteger rowIndexAmPm   = (components.hour < 12)? 0: 1;
    
    [self.customDatePicker selectRow:rowIndexHour   inComponent:0 animated:YES];
    [self.customDatePicker selectRow:rowIndexMinute inComponent:1 animated:YES];
    [self.customDatePicker selectRow:rowIndexAmPm   inComponent:2 animated:YES];
    
    [self.customDatePicker reloadAllComponents];
}

- (void)attachCustomDatePickerToView:(UIView*)activeView
{
    // set constraints
    CGRect frame = [self.view frame];
    CGSize frameSize = frame.size;
    
    CGRect  viewRect   = [activeView.superview convertRect:activeView.frame toView:nil];
    CGSize  viewSize   = viewRect.size;
    CGPoint viewOrigin = viewRect.origin;
    float   width      = MAX(viewRect.size.width, DATE_PICKER_MIN_WIDTH);
    
    BOOL   willExceedBottomScreen = (viewOrigin.y + viewSize.height + DATE_PICKER_HEIGHT + DATE_PICKER_MARGIN) >= frameSize.height;
    BOOL   willExceedRightScreen  = (viewOrigin.x + width + DATE_PICKER_MARGIN) >= frameSize.width;
    
    [self.customDatePickerVAlignConstraint setActive:NO];
    [self.customDatePickerHAlignConstraint setActive:NO];
    
    if(willExceedBottomScreen)
    {
        self.customDatePickerVAlignConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.customDatePickerView
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:activeView
                                                 attribute:NSLayoutAttributeTop
                                                 multiplier:1.0
                                                 constant:DATE_PICKER_SPACE];
    }
    else
    {
        self.customDatePickerVAlignConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.customDatePickerView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:activeView
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                 constant:DATE_PICKER_SPACE];
    }
    
    if(willExceedRightScreen)
    {
        self.customDatePickerHAlignConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.customDatePickerView
                                                 attribute:NSLayoutAttributeTrailing
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:activeView
                                                 attribute:NSLayoutAttributeTrailing
                                                 multiplier:1.0
                                                 constant:0];
    }
    else
    {
        self.customDatePickerHAlignConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.customDatePickerView
                                                 attribute:NSLayoutAttributeLeading
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:activeView
                                                 attribute:NSLayoutAttributeLeading
                                                 multiplier:1.0
                                                 constant:0];
    }
    
    [NSLayoutConstraint activateConstraints:@[
        self.customDatePickerVAlignConstraint,
        self.customDatePickerHAlignConstraint
    ]];
    
    [self.customDatePickerWidthConstraint   setConstant:width];
    [self.customDatePickerHeightConstraint  setConstant:0];
    
    [self.view layoutIfNeeded];
    
    
    [self.view.superview bringSubviewToFront:self.view];
    [self.customDatePickerView setHidden:NO];
    
    switch (self.mode)
    {
        case UIDatePickerModeTime:
        {
            _componentCount = 3; // HH:mm a
            break;
        }
            
        default: // date
        {
            _componentCount = 3; // mm/dd/yyyy
            break;
        }
    }
    
    [self.customDatePicker reloadAllComponents];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.customDatePickerHeightConstraint setConstant:DATE_PICKER_HEIGHT];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Picker Setup Helpers
- (NSString*)stringValueForDateComponent:(NSInteger)componentIndex atRow:(NSInteger)rowIndex isDisabled:(nullable BOOL*)isDisabled
{
    NSArray *rows = [_dateComponents objectAtIndex:componentIndex];
    NSInteger rowCount = rows.count;
    NSString *strVal = [NSString stringWithFormat:@"%@", [rows objectAtIndex:rowIndex % rowCount]];
    
    if(componentIndex == 0)
    {
        *isDisabled = ![self validateSelectedDay:rowIndex resetToIndex:nil];
    }
    else if(componentIndex == 1)
    {
        *isDisabled = ![self validateSelectedMonth:rowIndex resetToIndex:nil];
    }
    else if(componentIndex == 2)
    {
        *isDisabled = ![self validateSelectedYear:rowIndex resetToIndex:nil];
    }
    
    return strVal;
}

- (BOOL)isLeapYear:(NSInteger)year
{
    return (year % 400 == 0 ||
            year % 100 == 0 ||
            year % 4   == 0);
}

- (NSInteger)maxDaysForMonth:(NSInteger)month andYear:(NSInteger)year
{
    if(month == 2)
    {
        return [self isLeapYear:year]? 29: 28;
    }
    
    if(month < 7 && month % 2 == 0)
    {
        return 30;
    }
    
    if(month > 7 && month % 2 != 0)
    {
        return 30;
    }
    
    return 31;
}

- (BOOL)validateSelectedDay:(NSInteger)rowIndex resetToIndex:(nullable NSInteger*)resetIndex
{
    BOOL isValid = YES;
    NSInteger day = (rowIndex % _days.count) + 1;
    NSInteger month = (_selectedMonthIndex % _months.count) + 1;
    NSInteger year = [_years[_selectedYearIndex] integerValue];
    NSInteger maxDayForMonthAndYear = [self maxDaysForMonth:month andYear:year];
    NSInteger diff = 0;
    
    if(_minYear >= 0 && year == _minYear &&
       _minMonth >= 0 && month == _minMonth &&
       _minDay >= 0 && day < _minDay)
    {
        diff = _minDay - day;
        isValid = NO;
    }
    else if(_maxYear >= 0 && year == _maxYear &&
            _maxMonth >= 0 && month == _maxMonth &&
            _maxDay >= 0 && day > _maxDay)
    {
        diff = _maxDay - day;
        isValid = NO;
    }
    else if(day > maxDayForMonthAndYear)
    {
        diff = maxDayForMonthAndYear - day;
        isValid = NO;
    }
    
    if(!isValid && resetIndex)
    {
        *resetIndex = rowIndex + diff;
    }
    
    return isValid;
}

- (BOOL)validateSelectedMonth:(NSInteger)rowIndex resetToIndex:(nullable NSInteger*)resetIndex
{
    NSInteger month = (rowIndex % _months.count) + 1;
    NSInteger year = [_years[_selectedYearIndex] integerValue];
    
    if(_minYear >= 0 && year == _minYear &&
       _minMonth >= 0 && month < _minMonth)
    {
        if(resetIndex)
        {
            NSInteger diff = _minMonth - month;
            *resetIndex = rowIndex + diff;
        }
        
        return NO;
    }
    
    if(_maxYear >= 0 && year == _maxYear &&
       _maxMonth >= 0 && month > _maxMonth)
    {
        if(resetIndex)
        {
            NSInteger diff = month - _maxMonth;
            *resetIndex = rowIndex - diff;
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)validateSelectedYear:(NSInteger)rowIndex resetToIndex:(nullable NSInteger*)resetIndex
{
    NSInteger index = rowIndex % _years.count;
    NSInteger year = [_years[index] integerValue];
    
    if(_minYear >= 0 && year < _minYear)
    {
        if(resetIndex)
        {
            *resetIndex = [_years indexOfObject:[NSNumber numberWithInteger:_minYear]];
        }
        
        return NO;
    }
    
    if(_maxYear >= 0 && year > _maxYear)
    {
        if(resetIndex)
        {
            *resetIndex = [_years indexOfObject:[NSNumber numberWithInteger:_maxYear]];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Picker Delegate & Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _componentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.mode)
    {
        case UIDatePickerModeTime:
        {
            if(component == 2) // AM PM
            {
                return [_timeComponents[component] count];
            }
            
            break;
        }
            
        default: // date
        {
            if(component == 2) // year
            {
                return DEFAULT_MAX_YEAR - DEFAULT_MIN_YEAR;
            }
            
            break;
        }
    }
    
    // set a large number to simulate circular/infinite scrolling
    return MAX_PICKER_ROW_COUNT;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    
    if (!retval)
    {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    
    retval.font = _pickerLabelFont;
    retval.textColor = _pickerLabelColor;
    retval.textAlignment = NSTextAlignmentCenter;
    
    switch (self.mode)
    {
        case UIDatePickerModeTime:
        {
            NSArray *rows = [_timeComponents objectAtIndex:component];
            NSInteger rowCount = rows.count;
            NSString *str;
            
            if(component == 1) // minutes
            {
                NSInteger minutes = [[rows objectAtIndex:row % rowCount] integerValue];
                str = [NSString stringWithFormat:@"%02li", (long)minutes];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@", [rows objectAtIndex:row % rowCount]];
            }
            
            [retval setText:str];
            
            break;
        }
            
        default: //UIDatePickerModeDate
        {
            BOOL isDisabled = NO;
            NSString *strVal = [self stringValueForDateComponent:component atRow:row isDisabled:&isDisabled];
            
            if(isDisabled)
            {
                retval.textColor = _pickerAltLabelColor;
            }
            
            [retval setText:strVal];
            
            break;
        }
    }
    
    return retval;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.customDatePickerWidthConstraint.constant / 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.mode != UIDatePickerModeDate)
    {
        return;
    }
    
    BOOL shouldResetYear = NO;
    BOOL shouldResetMonth = NO;
    BOOL shouldResetDay = NO;
    
    NSInteger newYearIndex = _selectedYearIndex;
    NSInteger newMonthIndex = _selectedMonthIndex;
    NSInteger newDayIndex = _selectedDayIndex;
    
    if(component == 0)
    {
        shouldResetDay = ![self validateSelectedDay:row resetToIndex:&newDayIndex];
        _selectedDayIndex = shouldResetDay? newDayIndex: row;
    }
    else if(component == 1)
    {
        shouldResetMonth = ![self validateSelectedMonth:row resetToIndex:&newMonthIndex];
        _selectedMonthIndex = shouldResetMonth? newMonthIndex: row;
        
        shouldResetDay = ![self validateSelectedDay:_selectedDayIndex
                                       resetToIndex:&newDayIndex];
    }
    else if(component == 2)
    {
        shouldResetYear = ![self validateSelectedYear:row resetToIndex:&newYearIndex];
        _selectedYearIndex = shouldResetYear? newYearIndex: row;
        
        shouldResetMonth = ![self validateSelectedMonth:_selectedMonthIndex
                                           resetToIndex:&newMonthIndex];
        _selectedMonthIndex = shouldResetMonth? newMonthIndex: _selectedMonthIndex;
        
        shouldResetDay = ![self validateSelectedDay:_selectedDayIndex
                                       resetToIndex:&newDayIndex];
    }
    
    if(shouldResetYear)
    {
        _selectedYearIndex = newYearIndex;
        [self.customDatePicker selectRow:_selectedYearIndex
                             inComponent:2 animated:YES];
    }
    
    if(shouldResetMonth)
    {
        _selectedMonthIndex = newMonthIndex;
        [self.customDatePicker selectRow:_selectedMonthIndex
                             inComponent:1 animated:YES];
    }
    
    if(shouldResetDay)
    {
        _selectedDayIndex = newDayIndex;
        [self.customDatePicker selectRow:_selectedDayIndex
                             inComponent:0 animated:YES];
    }
    
    [self.customDatePicker reloadAllComponents];
}

@end
