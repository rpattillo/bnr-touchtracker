//
//  DrawViewController.m
//  TouchTracker
//
//  Created by Ricky Pattillo on 12/28/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"

@implementation DrawViewController

#pragma mark - View life cycle

- (void)loadView
{
   self.view = [[DrawView alloc] initWithFrame:CGRectZero];
}

@end
