//
//  STDropMenuDataSource.m
//  operamobile
//
//  Created by SamsoDeveloper on 6/12/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import "STDropMenuDataSource.h"
#import "STDropMenuCell.h"

// utilities
//#import "STAppStyleManager.h"

// models
//#import "STAppStyleModel.h"
//#import "STColorPaletteModel.h"
//#import "STFontStyleModel.h"
//#import "STShadowStyleModel.h"

// categories
//#import "UIColor+HexString.h"
//#import "UIfont+Helper.h"

@interface STDropMenuDataSource()
{
    NSArray *mData;
}

@end

@implementation STDropMenuDataSource

#pragma mark - Init
- (id)init
{
    if(self = [super init])
    {
        mData = [[NSArray alloc] init];
    }
    
    return self;
}

#pragma mark - Public Functions
- (void)reloadWithData:(NSArray*)data
{
    mData = data;
}

- (NSString*)getValueAtIndex:(NSUInteger)index
{
    return mData[index];
}

#pragma mark - Table Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!mData)
    {
        return 0;
    }
    
    return [mData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = NSStringFromClass([STDropMenuCell class]);
    STDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                           forIndexPath:indexPath];
    
//    [cell.contentLabel sizeToFit];
//    [cell.contentLabel setText:mData[indexPath.row]];
    [cell updateText:mData[indexPath.row]];
    
    return (UITableViewCell*)cell;
}

@end
