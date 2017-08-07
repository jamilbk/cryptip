# Pre-work - *CrypTip*

**CrypTip** is a tip calculator application for iOS with Tip Splitting and Bitcoin Payment support.

Submitted by: **Jamil Bou Kheir**

Time spent: **8** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [ ] UI animations
* [ ] Remembering the bill amount across app restarts (if <10mins)
* [ ] Using locale-specific currency and currency thousands separators.
* [ ] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

* [x] Party size feature that splits the tip based on X people
* [x] Generate a Bitcoin receive QR code when calculating split. This conforms to the [BIP21 standard](https://github.com/bitcoin/bips/blob/master/bip-0021.mediawiki) and allows anyone with a Bitcoin wallet or QR scanner to send the CrypTip user Bitcoin in the amount of the split bill. The Bitcoin exchange rate is hardcoded to $3,300 -- I didn't have time to play with fetching and parsing this, but looked into Foundation's JSON parsing support which seemed to do the trick.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/k6KoBAq.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** I haven't used an IDE since college, opting instead for the simplicity of a Terminal-based environment. With tmux, vim, and the Unix shell I've built up a flexible workflow using simple and reliable tools to develop for nearly any platform. All this has come at a steep learning curve, however. XCode automates and streamlines many aspects of the workflow which I'd imagine to require more tedium and documentation reference otherwise. It's very quick to pick up. I really like the intelligence of the near-realtime Swift compile errors/warnings. However, there are a couple annoyances I discovered in the short time I've used it: 1. Xcode crashed on me when trying to rename the project, and 2. Renaming a project is near-impossible -- I wanted to change the project name (and all references to this) but even with a `grep -r "OldName" .` in the project root returning no hits, the project ended up with an irrecoverable Build error (codesigning something blah). I'd much prefer sticking to my usual vim workflow if Apple offered a better way to build iOS apps from the CLI only. Also the git integration feels weird (I think Xcode tries to magically deduce certain things from the git status/history?) coming from command-line git.

To a Ruby developer, Outlets are like `attr_accessible` -- they essentially define getters and setters for your UI objects. And to a web developer, Actions are basically JS event handlers.  

I remember using Interface Builder back in the day and sometimes having to tweak the generated NIBs -- it looks like an XML file that declaratively maps view Objects to Class variables and view Actions to Class instance functions.

**Question 2**: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** Strong reference cycles are bad because they mean the reference count never reaches 0, and thus the memory held by an instance of a Class will never be released, causing a memory leak. Because closures are a *referenced* type, like classes, references to `self` within the body of a closure will, by default, prevent the reference count from reaching 0 even when the instance that `self` refers to is deinitialized. This is (just a guess from my understanding thus far) because closures encapsulate their own scope, and so the `self` reference does not necessarily always refer to the instance of the class it's defined on. To remedy this, the closure capture list must define problematic references as either `weak` or `unowned`, similar to the method used to solve strong reference cycles between classes.


## License

    Copyright [2017] [Jamil Bou Kheir]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
