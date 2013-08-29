XMate
==============

TextMate and Emacs goodies for Xcode.


## What is it?
It's a Xcode plugin provides some handy TextMate and Emacs actions.

###Selecting actions demo:

![image](http://i.minus.com/i9B2FwGwiUJ8F.gif)

###Emacs Ace Jump mode demo:

![image](http://i.minus.com/ibzQzA079MFYWc.gif)

## Requirement
Xcode5

## Installation

### Build It Yourself
1. No matter which Xcode5 developer preview you're using, rename it to `Xcode5.app`, make sure it's file path is `/Applications/Xcode5.app`, because some Xcode frameworks need to be linked from the Xcode app itself.
2. Clone this repo, build it, then restart Xcode. You can find XMate's actions under Xcode's Edit menu if it's loaded.

### Or Use My Build.
I'm working on my site, will provide it later.

## Usage

### Set Your Own Keyboard Shortcuts

All available actions are under Xcode's "Edit" menu. There aren't any keyboard shortcuts by default in case of conflicts. You can assign your favorite keyboard shortcuts in `System Preferences` -> `Keyboard`.

![image](http://i.minus.com/imGDxlIUWBuCr.png)

Here're all available actions, save you some typing.

XMate:Select Scope  
XMate:Select between Brackets  
XMate:Ace Jump

### Selecting Actions

Select scope action selects inside quotes, or dot notation, or part of method calls.
Keep activating the same action will extend the selection to a acceptable range. 
e.g inside quotes to including quotes.

Select brackets action is similar to select scope action, but it will only extend selection to paired square brackets, curly brackets and parentheses.

### Ace Jump

1. Press the ace jump menu item or the hotkey you assigned, A little text field will pop up at the lower left corner of your current active editing area.

2. Input the character you want to jump to (case sensitive, can be letters or symbols), all the same characters will be covered by a yellow label with a lowercased indicating letter.

3. Input the indicating letter, the caret will be moved to that location. 

4. If you input uppercased indicating letter, a selection from current caret location to the indicating letter's location will be made.

5. Sometimes there're too many same characters on the screen, 26 letters are not enough to represent all of them, you can push `tab` or `return` to switch to next group.

6. You can always push `esc` or the ace jump hotkey you assigned to quit ace jump mode.- 

## XVim Compatibility

They can work together without crashing each other. Ace Jump Mode works fine since it just moves the caret to another position. Selecting actions are a little bit tricky, I don't recommend using XMate's selecting actions if you're using XVim as well.

## License

XMate is available under the MIT license. See the LICENSE.txt file for more information.
