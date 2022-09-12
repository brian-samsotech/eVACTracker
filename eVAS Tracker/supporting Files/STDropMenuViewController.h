//
//  STDropMenuViewController.h
//  operamobile
//
//  Created by SamsoDeveloper on 6/12/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STDropDownDelegate;

@interface STDropMenuViewController : UIViewController

@property (nonatomic, weak) id<STDropDownDelegate> delegate;
@property (nonatomic, copy, nullable) void (^onSelectFontFamily)(NSString* fontFamily);

+ (id)storyboardInstance;

- (void)hide;
- (void)attachToView:(UIView*)view withData:(NSArray*)data;
- (void)attachToViewTop:(UIView*)view withData:(NSArray*)data;
- (void)reloadWithData:(NSArray*)data;

@end

@protocol STDropDownDelegate <NSObject>

@optional
- (void)onCloseSTDropMenu;
- (void)onSTDropMenuSelectWithIndex:(NSUInteger)index andValue:(NSString*)value;

@end
