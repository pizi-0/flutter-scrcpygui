import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    guard let window = mainFlutterWindow,
          let controller = window.contentViewController as? FlutterViewController else {
      return .terminateNow
    }

    let channel = FlutterMethodChannel(name: "app_lifecycle", binaryMessenger: controller.engine.binaryMessenger)
    channel.invokeMethod("quitRequested", arguments: nil)

    if !window.isVisible {
      window.makeKeyAndOrderFront(self)
    }

    return .terminateCancel
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
