# ASJExpandableTextView
UITextView most obvious omission is placeholder text. This class adds the provision to set a placeholder and an option to make the text view expand and contract according to its content size.

Creating a text view is easy. It has a simple interface consisting of four properties which are IBInspectable. This means that they can be set using the interface builder of your choice; Xibs or Storyboards.

```
@property (copy, nonatomic) IBInspectable NSString *placeholder;
```
Sets the placeholder. Visible when there is nothing typed in the text view.

```
@property (nonatomic) IBInspectable BOOL hasDynamicHeight;
```
Set this to make the text view expand and contract according to its content.

```
@property (nonatomic) IBInspectable NSUInteger maximumLineCount;
```
You can set the number of visible lines of the text view. Default is 4. To use this property, `hasDynamicHeight` must be set to `YES`.

```
@property (nonatomic) IBInspectable BOOL shouldShowDoneButtonOverKeyboard;
```
The "return" key on the keyboard for a `UITextView` brings a new line, unlike a `UITextField` where the keyboard gets hidden. Set this property to show a "Done" button over the keyboard which can hide the keyboard.

```
@property (copy) DoneTappedBlock doneTappedBlock;
```
You can handle the event of the keyboard getting hidden using this block. To use this property, `shouldShowDoneButtonOverKeyboard` must be set to `YES`.

![alt tag](Images/IBInspectable.png)

You can create one using just the interface builder, drop in a UITextView and change the class to `ASJExpandableTextView`.

![alt tag](Images/CustomClass.png)

###Thanks

- To [Abhijit Kayande](https://github.com/Abhijit-Kayande) for fixing the choppy animation

# License

```
 Copyright (c) 2015 Sudeep Jaiswal

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
```
