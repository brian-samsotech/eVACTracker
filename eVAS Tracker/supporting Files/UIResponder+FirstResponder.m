//
//  UIResponder+FirstResponder.m
//  operamobile
//
//  Created by SamsoDeveloper on 2/28/19.
//  Copyright © 2019 samsotech. All rights reserved.
//

// source: https://stackoverflow.com/a/14135456/10063126

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+(id)currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}

@end
