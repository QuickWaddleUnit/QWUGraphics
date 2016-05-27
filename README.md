# QWUGraphics

A graphics library for Linux in Swift.

This library currently only works on Mac computers until the GCD (Grand Central Dispatch) library is available on Swift for Linux. It will be included in Swift 3.0 release.

Windows are functional with keyboard and mouse click capabilities.

## Dependencies

This library was compiled using Swift 3.0 with the Xcode Swift Development Snapshot 2016-05-09 toolchain.

### Mac OSX

```bash
brew install cairo --with-x11
brew install glib
```
 