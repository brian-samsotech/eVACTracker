//
//  UIResponder+FirstResponder.h
//  operamobile
//
//  Created by SamsoDeveloper on 2/28/19.
//  Copyright © 2019 samsotech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (FirstResponder)

+(id)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END
