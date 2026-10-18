# App Review notes

Things to consider before you ship system sounds in an App Store app.

## Overview

`AudioServicesPlaySystemSound` and `AudioServicesPlayAlertSound` are public APIs. The numeric
IDs and file names in this catalog are not documented by Apple, and Apple notes that
system-supplied alert and UI sounds are not available to iOS apps. Treat them as unofficial.

App Review Guidelines 2.5.1 (public APIs only) and 2.5.2 (apps may not read or write data
outside their container) apply. Playing a sound by ID with ``SystemSoundPlayer`` doesn't read
any files. ``FileSound`` with a system path and enumerating `/System/Library/Audio/UISounds` are
fine in developer tools, but avoid them in shipping apps.
