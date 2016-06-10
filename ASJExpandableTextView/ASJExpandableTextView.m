//
// ASJExpandableTextView.m
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ASJExpandableTextView.h"

typedef void (^AccessoryViewDoneBlock)(void);

#define kDefaultPlaceholderTextColor [UIColor colorWithWhite:0.7f alpha:1.0f]
static CGFloat const kPadding = 1.05f;

@interface ASJInputAccessoryView : UIView

@property (copy) AccessoryViewDoneBlock doneTappedBlock;

@end

@implementation ASJInputAccessoryView

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender
{
  if (_doneTappedBlock) {
    _doneTappedBlock();
  }
}

@end

@interface ASJExpandableTextView () {
  NSInteger currentLine;
  CGFloat previousContentHeight, defaultTextViewHeight, defaultContentHeight;
  BOOL isPlaceholderVisible, areLayoutDefaultsSet;
}

@property (assign, nonatomic) CGFloat heightOfOneLine;
@property (assign, nonatomic) CGFloat currentContentHeight;
@property (assign, nonatomic) CGFloat currentTextViewHeight;
@property (assign, nonatomic) BOOL shouldShowPlaceholder;
@property (strong, nonatomic) ASJInputAccessoryView *asjInputAccessoryView;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

- (void)setup;
- (void)setLayoutDefaults;
- (void)setDefaults;
- (void)executeDefaultFontHack;
- (void)setPlaceholderLabel;
- (void)listenForContentSizeChanges;
- (void)listenForNotifications;
- (void)handleTextChange;
- (void)handleExpansion;
- (void)handleNextLine:(NSInteger)multiplier;
- (void)handlePreviousLine:(NSInteger)multiplier;
- (void)animateConstraintToHeight:(CGFloat)height;
- (void)animateFrameToHeight:(CGFloat)height;
- (void)scrollToBottom;
- (void)prepareInputAccessoryView;

@end

@implementation ASJExpandableTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
  self = [super initWithFrame:frame textContainer:textContainer];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if (!areLayoutDefaultsSet && _isExpandable)
  {
    [self setLayoutDefaults];
    areLayoutDefaultsSet = YES;
  }
  if (!_placeholderLabel) {
    [self setPlaceholderLabel];
  }
}

- (void)setLayoutDefaults
{
  currentLine = 1;
  defaultContentHeight = self.currentContentHeight;
  defaultTextViewHeight = self.frame.size.height;
  previousContentHeight = _currentContentHeight = defaultContentHeight;
}

#pragma mark - Accessory view

- (BOOL)becomeFirstResponder
{
  if (_shouldShowDoneButtonOverKeyboard) {
    [self prepareInputAccessoryView];
  }
  return [super becomeFirstResponder];
}

- (void)prepareInputAccessoryView
{
  ASJInputAccessoryView *inputAccessoryView = self.asjInputAccessoryView;
  inputAccessoryView.doneTappedBlock = ^{
    [self resignFirstResponder];
    if (_doneTappedBlock) {
      _doneTappedBlock(self.text);
    }
  };
  self.inputAccessoryView = inputAccessoryView;
}

- (ASJInputAccessoryView *)asjInputAccessoryView
{
  return (ASJInputAccessoryView *)[[NSBundle mainBundle] loadNibNamed:@"ASJInputAccessoryView" owner:self options:nil][0];
}

#pragma mark - Setup

- (void)setup
{
  [self setDefaults];
  [self executeDefaultFontHack];
  [self listenForContentSizeChanges];
  [self listenForNotifications];
}

- (void)setDefaults
{
  _isExpandable = NO;
  _maximumLineCount = 4;
  _placeholderTextColor = kDefaultPlaceholderTextColor;
  _shouldShowDoneButtonOverKeyboard = NO;
  self.shouldShowPlaceholder = NO;
}

- (void)executeDefaultFontHack
{
  /**
   Unless text is set, self.font is nil, it doesn't seem to initialise when the text view is created.
   */
  self.text = @"weirdness";
  self.text = nil;
}

- (void)setPlaceholderLabel
{
  CGFloat x = self.textContainer.lineFragmentPadding + self.textContainerInset.left;
  CGFloat y = self.textContainerInset.top;
  CGFloat width = self.frame.size.width - (2.0f * x);
  CGFloat height = 0.0f;
  
  _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
  _placeholderLabel.enabled = YES;
  _placeholderLabel.highlighted = NO;
  _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _placeholderLabel.numberOfLines = 0;
  _placeholderLabel.textColor = _placeholderTextColor;
  _placeholderLabel.text = self.placeholder;
  _placeholderLabel.font = self.font;
  _placeholderLabel.backgroundColor = [UIColor clearColor];
  
  [self addSubview:_placeholderLabel];
  [_placeholderLabel sizeToFit];
  
  if (self.text.length) {
    self.shouldShowPlaceholder = NO;
  }
}

#pragma mark - Content size change

- (void)listenForContentSizeChanges
{
  [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (![keyPath isEqualToString:@"contentSize"]) {
    return;
  }
  [self handleExpansion];
}

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"contentSize"];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Text change

- (void)listenForNotifications
{
  __weak typeof(self) weakSelf = self;
  
  [[NSNotificationCenter defaultCenter]
   addObserverForName:UITextViewTextDidBeginEditingNotification
   object:self queue:[NSOperationQueue mainQueue]
   usingBlock:^(NSNotification *note)
   {
     typeof(weakSelf) strongSelf = weakSelf;
     [strongSelf handleTextChange];
   }];
  
  [[NSNotificationCenter defaultCenter]
   addObserverForName:UITextViewTextDidChangeNotification
   object:self queue:[NSOperationQueue mainQueue]
   usingBlock:^(NSNotification *note)
   {
     typeof(weakSelf) strongSelf = weakSelf;
     [strongSelf handleTextChange];
     [strongSelf handleExpansion];
   }];
}

- (void)handleTextChange
{
  if (self.text.length) {
    self.shouldShowPlaceholder = NO;
    return;
  }
  if (!isPlaceholderVisible) {
    self.shouldShowPlaceholder = YES;;
  }
}

- (void)handleExpansion
{
  if (!self.isExpandable) {
    return;
  }
  
  BOOL isOnCurrentLine = (self.currentContentHeight == previousContentHeight) ? YES : NO;
  if (isOnCurrentLine) {
    return;
  }
  
  BOOL isOnNextLine = (self.currentContentHeight > previousContentHeight) ? YES : NO;
  NSInteger multiplier = @(ceil(self.currentContentHeight/self.heightOfOneLine)).integerValue;
  
  if (isOnNextLine)
  {
    previousContentHeight = self.currentContentHeight;
    [self handleNextLine:multiplier];
    return;
  }
  
  multiplier = @(ceil(previousContentHeight/self.heightOfOneLine)).integerValue;
  previousContentHeight = self.currentContentHeight;
  [self handlePreviousLine:multiplier];
}

- (CGFloat)currentContentHeight
{
  return self.contentSize.height;
}

#pragma mark - Next and previous lines

- (void)handleNextLine:(NSInteger)multiplier
{
  currentLine += multiplier;
  if (currentLine > _maximumLineCount) {
    currentLine = _maximumLineCount;
  }
  
  if (self.currentContentHeight <= self.currentTextViewHeight) {
    return;
  }
  CGFloat newHeight = round(self.heightOfOneLine) * currentLine;
  BOOL isHeightConstraintAvailable = self.heightConstraint ? YES : NO;
  if (isHeightConstraintAvailable) {
    [self animateConstraintToHeight:newHeight];
  }
  else {
    [self animateFrameToHeight:newHeight];
  }
}

- (void)handlePreviousLine:(NSInteger)multiplier
{
  currentLine -= multiplier;
  if (self.currentContentHeight >= self.currentTextViewHeight) {
    return;
  }
  if (self.currentTextViewHeight <= defaultTextViewHeight) {
    return;
  }
  CGFloat newHeight = newHeight = round(self.heightOfOneLine) * currentLine;
  if (newHeight < defaultTextViewHeight) {
    newHeight = defaultTextViewHeight;
  }
  
  BOOL isHeightConstraintAvailable = self.heightConstraint ? YES : NO;
  if (isHeightConstraintAvailable) {
    [self animateConstraintToHeight:newHeight];
  }
  else {
    [self animateFrameToHeight:newHeight];
  }
}

- (CGFloat)heightOfOneLine
{
  return self.font.lineHeight + kPadding;
}

- (void)animateConstraintToHeight:(CGFloat)height
{
  [self.superview layoutIfNeeded];
  self.heightConstraint.constant = height;
  [UIView animateWithDuration:0.30f
                        delay:0.0f
                      options:UIViewAnimationOptionLayoutSubviews
                   animations:^{
                     [self scrollToBottom];
                     [self.superview layoutIfNeeded];
                   } completion:nil];
  
  if (_heightChangedBlock) {
    _heightChangedBlock(height);
  }
}

- (void)animateFrameToHeight:(CGFloat)height
{
  if (_heightChangedBlock) {
    _heightChangedBlock(height);
  }
  
  [UIView animateWithDuration:0.30f
                        delay:0.0f
                      options:UIViewAnimationOptionLayoutSubviews
                   animations:^{
                     CGFloat x = self.frame.origin.x;
                     CGFloat y = self.frame.origin.y;
                     CGFloat width = self.frame.size.width;
                     self.frame = CGRectMake(x, y, width, height);
                   } completion:nil];
}

- (NSLayoutConstraint *)heightConstraint
{
  for (NSLayoutConstraint *constraint in self.constraints) {
    if (constraint.firstAttribute == NSLayoutAttributeHeight) {
      return constraint;
    }
  }
  return nil;
}

- (CGFloat)currentTextViewHeight
{
  return self.frame.size.height;
}

- (void)scrollToBottom
{
  NSRange range = NSMakeRange(self.text.length - 1, 1);
  [self scrollRangeToVisible:range];
}

#pragma mark - Property setter overrides

- (void)setPlaceholder:(NSString *)placeholder
{
  if (!placeholder.length) {
    return;
  }
  
  _placeholder = placeholder;
  _placeholderLabel.text = placeholder;
  [_placeholderLabel sizeToFit];
  self.shouldShowPlaceholder = YES;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
  if (!placeholderTextColor) {
    _placeholderTextColor = kDefaultPlaceholderTextColor;
  }
  else {
    _placeholderTextColor = placeholderTextColor;
  }
  
  _placeholderLabel.textColor = _placeholderTextColor;
}

- (void)setText:(NSString *)text
{
  [super setText:text];
  if (text && text.length) {
    self.shouldShowPlaceholder = NO;
    return;
  }
  self.shouldShowPlaceholder = YES;
}

- (void)setShouldShowPlaceholder:(BOOL)shouldShowPlaceholder
{
  _shouldShowPlaceholder = shouldShowPlaceholder;
  if (_shouldShowPlaceholder) {
    _placeholderLabel.alpha = 1.0f;
    isPlaceholderVisible = YES;
    return;
  }
  _placeholderLabel.alpha = 0.0f;
  isPlaceholderVisible = NO;
}

@end
