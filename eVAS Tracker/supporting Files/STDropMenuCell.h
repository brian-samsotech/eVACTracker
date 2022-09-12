//
//  STDropMenuCell.h
//  operamobile
//
//  Created by SamsoDeveloper on 6/12/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STDropMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)updateText:(NSString*)textValue;

@end
