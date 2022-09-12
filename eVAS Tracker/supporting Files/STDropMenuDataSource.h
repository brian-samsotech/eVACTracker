//
//  STDropMenuDataSource.h
//  operamobile
//
//  Created by SamsoDeveloper on 6/12/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface STDropMenuDataSource : NSObject <UITableViewDataSource>

- (void)reloadWithData:(NSArray*)data;
- (NSString*)getValueAtIndex:(NSUInteger)index;

@end
