/// Every method or variable must start with $ so that lldb gives them a global scope.
/// On extensions the $ is not required at the moment.

/// po $helloWorld()
func $welcome() {
  print("UIKit helpers loaded")
}

$welcome()

extension UIView {
  /// Example: call someView.nudge(0, 30)
  func nudge(_ dx: CGFloat, _ dy: CGFloat) {
    self.frame = self.frame.offsetBy(dx: dx, dy: dy)
    CATransaction.flush()
  }
}

extension UIView {
  /// Example: po UIView.root
  static var root: UIView {
    return UIApplication.shared.keyWindow!.rootViewController!.view
  }
}

//extension UIViewController {
//    /// Example: po UIViewController.current
//    static var current: UIViewController {
//        var controller = UIApplication.shared.keyWindow!.rootViewController!
//        if let child = (controller as? UINavigationController)?.topViewController {
//            controller = child
//        }
//        if let container = (controller as? UITabBarController)?.selectedViewController {
//            controller = child
//        }
//        return controller
//    }
//}
//
//extension UIView {
//    /// Example: po UIView.current
//    static var current: UIView {
//        return UIViewController.current.view
//    }
//}

extension UIView {
  /// Utility used by others helpers.
  func tree() -> UnfoldSequence<UIView, [UIView]> {
    return sequence(state: [self]) { state in
      guard let view = state.popLast() else { return nil }
      state.append(contentsOf: view.subviews.reversed())
      return view
    }
  }
}

extension UIView {
  func grep(_ pattern: String) -> [UILabel] {
    return self.tree()
      .compactMap { $0 as? UILabel }
      .filter { $0.text?.range(of: pattern) != nil }
  }
}

extension UIView {
  /// Example: po UIButton.first(in: someView)
  static func first(in root: UIView) -> Self? {
    return root.first { _ in true }
  }

  /// Example: po UIView.current.first { (b: UIButton) in b.currentTitle == "Tap Me" }
  func first<T: UIView>(where match: (T) -> Bool) -> T? {
    return self.tree()
      .lazy
      .compactMap { $0 as? T }
      .filter(match)
      .first
  }
}

extension UIView {
  func fillText(_ text: String) {
    if let textField = UITextField.first(in: self) {
      textField.text = text
      CATransaction.flush()
    }
  }
}

extension UIView {
  // Example: po someView.screenshot("Users/CURRENT_USER/Desktop/image.png")
  // Example: shell open /some/path.png
  func screenshot(_ path: String) {
    let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
    let png = renderer.pngData { _ in
      self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
    }
    do {
      try png.write(to: URL(fileURLWithPath: path))
    } catch let e {
      print("Failed to write \(path): \(e)")
    }
  }
}

//// Example: someButton.sendActions(for: $touchUpInside)
//let $touchUpInside = UIControl.Event(rawValue: 64)
