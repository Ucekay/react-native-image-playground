import ExpoModulesCore
import ImagePlayground
import SwiftUICore

protocol ImagePlaygroundHandler {
  func launch() async throws -> [String: Any]
}

public class ReactNativeImagePlaygroundModule: Module {
  private var handler: ImagePlaygroundHandler?

  public func definition() -> ModuleDefinition {
    Name("ReactNativeImagePlayground")

    AsyncFunction("launchImagePlaygroundAsync") { () -> [String: Any] in
      if #available(iOS 18.1, *) {
        self.handler = ImagePlayground18Handler(appContext: self.appContext)
      } else {
        self.handler = UnsupportedImagePlaygroundHandler(appContext: self.appContext)
      }
      return try await self.handler?.launch() ?? [:]
    }
  }
}

class UnsupportedImagePlaygroundHandler: ImagePlaygroundHandler {
  private weak var appContext: AppContext?

  init(appContext: AppContext?) {
    self.appContext = appContext
  }

  func launch() async throws -> [String: Any] {
    return try await withCheckedThrowingContinuation { continuation in
      Task { @MainActor in
        guard let currentViewController = self.appContext?.utilities?.currentViewController() else {
          continuation.resume(throwing: NSError(domain: "ReactNativeImagePlayground", code: -1))
          return
        }

        let alert = UIAlertController(
          title: "サポート対象外",
          message: "Image Playgroundはこのデバイスではサポートされていません",
          preferredStyle: .alert
        )
        alert.addAction(
          UIAlertAction(title: "OK", style: .default) { _ in
            continuation.resume(throwing: NSError(domain: "ReactNativeImagePlayground", code: -3))
          })

        currentViewController.present(alert, animated: true)
      }
    }
  }
}

@available(iOS 18.1, *)
class ImagePlayground18Handler: ImagePlaygroundHandler {
  private weak var appContext: AppContext?
  private var delegate: ImagePlaygroundDelegate?
  @Environment(\.supportsImagePlayground) private var supportsImagePlayground

  init(appContext: AppContext?) {
    self.appContext = appContext
  }

  func launch() async throws -> [String: Any] {
    guard supportsImagePlayground else {
      return try await UnsupportedImagePlaygroundHandler(appContext: appContext).launch()
    }

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
      _ imagePlaygroundViewController: ImagePlaygroundViewController,
      didCreateImageAt imageURL: URL
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
