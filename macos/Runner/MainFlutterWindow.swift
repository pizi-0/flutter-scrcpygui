import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private let customTitleBarHeight: CGFloat = 45.0

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    self.collectionBehavior.remove(.fullScreenPrimary)
    self.collectionBehavior.remove(.fullScreenAuxiliary)
    self.collectionBehavior.insert(.fullScreenNone)
    self.collectionBehavior.insert(.fullScreenDisallowsTiling)
  }

  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    repositionTrafficLights()
  }

  private func repositionTrafficLights() {
    let xStart: CGFloat = 12.0
    let spacing: CGFloat = 20.0
    let buttonTypes: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]

    for (index, buttonType) in buttonTypes.enumerated() {
      guard let button = standardWindowButton(buttonType),
            let superview = button.superview else { continue }

      let superviewHeight = superview.frame.height
      let buttonHeight = button.frame.height

      let centerFromTop = customTitleBarHeight / 2.0
      let buttonTopFromTop = centerFromTop - buttonHeight / 2.0
      let newY = superviewHeight - buttonTopFromTop - buttonHeight
      let newX = xStart + CGFloat(index) * spacing

      button.setFrameOrigin(NSPoint(x: newX, y: newY))
    }
  }
}
