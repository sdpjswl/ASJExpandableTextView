# ASJExpandableTextView
UITextView most obvious omission is placeholder text. This class adds the provision to set a placeholder and an option to make the text view expand and contract according to its content size.

Creating a text view is easy. It has a simple interface consisting of three properties which are IBInspectable. This means that they can be set using the interface builder of your choice; Xibs or Storyboards.

![alt tag](Images/IBInspectable.png)

You can create one using just the interface builder, drop in a UITextView and change the class to `ASJExpandableTextView`.

![alt tag](Images/CustomClass.png)

`@property (copy, nonatomic) IBInspectable NSString *placeholder;`

`@property (nonatomic) IBInspectable BOOL hasDynamicHeight;`

`@property (nonatomic) IBInspectable NSUInteger maximumLineCount;`

###To-do
- Add input accessory view to hide keyboard

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
