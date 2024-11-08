import ExpoModulesCore
import ImagePlayground

@available(iOS 18.1, *)
public class ReactNativeImagePlaygroundModule: Module {
  private var completionHandler: (([String: Any]) -> Void)?
  private var delegate: ImagePlaygroundDelegate?

  public func definition() -> ModuleDefinition {
    Name("ReactNativeImagePlayground")

    AsyncFunction("launchImagePlaygroundAsync") { () -> [String: Any] in
      return try await self.launchImagePlayground()
    }
  }

  private func launchImagePlayground() async throws -> [String: Any] {
    return try await withCheckedThrowingContinuation { continuation in
      Task { @MainActor in
        let controller = ImagePlaygroundViewController()
        controller.modalPresentationStyle = .automatic
        controller.isModalInPresentation = false
        self.delegate = ImagePlaygroundDelegate { result in
          continuation.resume(with: result)
        }
        controller.delegate = self.delegate

        guard let currentViewController = self.appContext?.utilities?.currentViewController() else {
          continuation.resume(throwing: NSError(domain: "ReactNativeImagePlayground", code: -1))
          return
        }

        currentViewController.present(controller, animated: true)
      }
    }
  }

  class ImagePlaygroundDelegate: NSObject, ImagePlaygroundViewController.Delegate {
    private let completion: (Result<[String: Any], Error>) -> Void

    init(completion: @escaping (Result<[String: Any], Error>) -> Void) {
      self.completion = completion
    }

    @MainActor
    func imagePlaygroundViewController(
      _ imagePlaygroundViewController: ImagePlaygroundViewController, didCreateImageAt imageURL: URL
    ) {
      imagePlaygroundViewController.dismiss(animated: true)
      completion(.success(["url": imageURL.absoluteString]))
    }

    @MainActor
    func imagePlaygroundViewControllerDidCancel(
      _ imagePlaygroundViewController: ImagePlaygroundViewController
    ) {
      imagePlaygroundViewController.dismiss(animated: true)
      completion(.failure(NSError(domain: "ReactNativeImagePlayground", code: -2)))
    }
  }
}
