import ExpoModulesCore
import ImagePlayground

@available(iOS 18.1, *)
public class ReactNativeImagePlaygroundModule: Module {
  private var completionHandler: (([String: Any]) -> Void)?

  public func definition() -> ModuleDefinition {
    Name("ReactNativeImagePlayground")

    View(ReactNativeImagePlaygroundView.self) {
    }

    AsyncFunction("launchImagePlaygroundAsync") { () -> Void in
      self.launchImagePlayground()
    }.runOnQueue(DispatchQueue.main)
  }

  private func launchImagePlayground() {
    // メインスレッドでViewControllerの初期化を行う
    let controller = ImagePlaygroundViewController()
    controller.modalPresentationStyle = .automatic

    // ViewControllerの初期化を完了させる
    controller.loadViewIfNeeded()
    controller.view.layoutIfNeeded()

    // 少し遅延させてモーダル表示を行う
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let currentViewController = self?.appContext?.utilities?.currentViewController() else {
        return
      }
      currentViewController.present(controller, animated: true)
    }
  }
}
