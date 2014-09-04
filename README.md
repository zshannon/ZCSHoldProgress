ZCSHoldProgress
=================

*"Your users be pressin' long, but do they know how long they need to be pressin'?"*

ZCSHoldProgress is a UILongPressGestureRecognizer subclass with some nice (customizable) visual flair.

## Add to your Podfile

`pod 'ZCSHoldProgress', '~> 0.0.4'`

## Use in your project

### Setup

```obj-c
#import "ZCSHoldProgress.h"

ZCSHoldProgress *holdProgress = [[ZCSHoldProgress alloc] initWithTarget:self action:@selector(gestureRecogizerTarget:)];
holdProgress.minimumPressDuration = 3.0;
[self.view addGestureRecognizer:holdProgress];
	
```

### Target Action

```obj-c
- (void)gestureRecogizerTarget:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		// TODO: do something interesting
	} else if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
		// TODO: knock it off with the interesting stuff
	}
}
```

## Screenshots ##

![Example App](/../screenshots/one.png?raw=true "Example App")
![Example Showing Progress](/../screenshots/two.png?raw=true "Example Showing Progress")
![Example Showing Complete](/../screenshots/three.png?raw=true "Example Showing Complete")

## Contributing ##

Send me Pull Requests here, please.
