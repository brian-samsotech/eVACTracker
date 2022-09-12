//
//  STDropMenuCell.m
//  operamobile
//
//  Created by SamsoDeveloper on 6/12/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import "STDropMenuCell.h"

@implementation STDropMenuCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateText:(NSString*)textValue
{
    [self.contentLabel setText:textValue];
}

@end
