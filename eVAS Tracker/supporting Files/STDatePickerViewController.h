//
//  UtilitiesViewController.h
//  operamobile
//
//  Created by SamsoDeveloper on 6/11/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STDatePickerDelegate;

/* interface
 */
@interface STDatePickerViewController : UIViewController

@property (nonatomic, weak) id<STDatePickerDelegate> delegate;
@property (nonatomic) UIDatePickerMode mode;

@property (nonatomic) NSDate *minDate;
@property (nonatomic) NSDate *maxDate;

+ (id)storyboardInstance;
- (id)initWithViewController:(UIViewController*)containerViewController;

- (void)showAndAttachToView:(UIView*)view;
- (void)hide;
- (void)setMinDate:(NSDate*)date;
- (void)setMaxDate:(NSDate*)date;

// -- custom date picker
- (void)showDate:(NSDate*)date;
- (void)showTime:(NSDate*)time;
- (void)attachCustomDatePickerToView:(UIView*)view;

@end


/* protocol definition
 */
@protocol STDatePickerDelegate <NSObject>

@optional
- (void)onClickClearButton;
- (void)onDatePickerClose;
- (void)onUpdateDateValueWithString:(NSString*)dateString;
- (void)onUpdateValueWithDate:(NSDate*)date;

@end
