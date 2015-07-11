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

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  textView.doneTappedBlock = ^(NSString *text) {
    NSLog(@"you typed: %@", text);
  };
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
