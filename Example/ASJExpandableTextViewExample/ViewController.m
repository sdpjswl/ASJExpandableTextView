//
//  ViewController.m
//  ASJExpandableTextViewExample
//
//  Created by sudeep on 08/07/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ViewController.h"
#import "ASJExpandableTextView.h"

@interface ViewController () {
  IBOutlet ASJExpandableTextView *textView;
}

- (void)setup;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setup
{
  textView.isExpandable = YES;
  textView.maximumLineCount = 14;
  textView.shouldShowDoneButtonOverKeyboard = YES;
  textView.doneTappedBlock = ^(NSString *text) {
    NSLog(@"you typed: %@", text);
  };
}

@end
