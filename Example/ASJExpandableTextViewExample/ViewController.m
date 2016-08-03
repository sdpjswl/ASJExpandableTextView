//
//  ViewController.m
//  ASJExpandableTextViewExample
//
//  Created by sudeep on 08/07/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ViewController.h"
#import "ASJExpandableTextView.h"

@interface ViewController () <UITextViewDelegate>
{
  IBOutlet ASJExpandableTextView *textView;
}

- (void)setup;
- (IBAction)copyTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
}

#pragma mark - Setup

- (void)setup
{
  textView.placeholder = @"Type something here...";
  textView.isExpandable = YES;
  textView.maximumLineCount = 14;
  textView.lineSpacing = 1.5f;
  textView.shouldShowDoneButtonOverKeyboard = YES;
  [textView setDoneTappedBlock:^(NSString * _Nonnull text)
   {
     NSLog(@"you typed: %@", text);
   }];
}

- (IBAction)copyTapped:(id)sender
{
  [UIPasteboard generalPasteboard].string = @"'Cause this music can put a human being in a trance like state and deprive it for the sneaking feeling of existing. 'Cause music is bigger than words and wider than pictures. If someone said that Mogwai are the stars I would not object. If the stars had a sound it would sound like this. The punishment for these solemn words can be hard. Can blood boil like this at the sound of a noisy tape that I've heard. I know one thing. On Saturday, the sky will crumble together (or something) with a huge bang to fit into the cave.";
}

@end
