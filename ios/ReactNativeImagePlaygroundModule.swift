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
        // iOS 13以降に対応した方法でウィンドウを取得
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        guard let window = scene?.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let controller = ImagePlaygroundViewController()
        controller.modalPresentationStyle = .fullScreen
        
        // 現在表示されている最前面のViewControllerを取得
        var topViewController = window.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        topViewController?.present(controller, animated: true)
    }
}
