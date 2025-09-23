import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Ensure the app uses a regular activation policy and comes to foreground
    NSApp.setActivationPolicy(.regular)
    NSApp.activate(ignoringOtherApps: true)
    super.applicationDidFinishLaunching(notification)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // Keep running (e.g., for tray) even if all windows are closed
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // When the user clicks the Dock icon while the app is running but no window
  // is visible, bring the Flutter window to front.
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      NSApp.activate(ignoringOtherApps: true)
      for window in NSApp.windows {
        window.makeKeyAndOrderFront(self)
      }
    }
    return true
  }
}
