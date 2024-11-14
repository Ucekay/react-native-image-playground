import ExpoModulesCore
import ImagePlayground
import SwiftUICore

protocol ImagePlaygroundHandler {
  func launch(params: [String: Any]?) async throws -> [String: Any]
}

enum ImageConceptType {
  case text(String)
  case extractedWithTitle(text: String, title: String?)
  case extracted(String)
}

public class ReactNativeImagePlaygroundModule: Module {
  private var handler: ImagePlaygroundHandler?

  public func definition() -> ModuleDefinition {
    Name("ReactNativeImagePlayground")

    AsyncFunction("launchImagePlaygroundAsync") { (params: [String: Any]?) -> [String: Any] in
      if #available(iOS 18.1, *) {
        self.handler = SupportedImagePlaygroundHandler(appContext: self.appContext)
      } else {
        self.handler = UnsupportedImagePlaygroundHandler(appContext: self.appContext)
      }
      return try await self.handler?.launch(params: params) ?? [:]
    }
  }
}

class UnsupportedImagePlaygroundHandler: ImagePlaygroundHandler {
  private weak var appContext: AppContext?

  init(appContext: AppContext?) {
    self.appContext = appContext
  }

  func launch(params: [String: Any]?) async throws -> [String: Any] {
    return try await withCheckedThrowingContinuation { continuation in
      Task { @MainActor in
        guard let currentViewController = self.appContext?.utilities?.currentViewController() else {
          continuation.resume(throwing: NSError(domain: "ReactNativeImagePlayground", code: -1))
          return
        }

        let alert = UIAlertController(
          title: "Image Playground is not available",
          message:
            "Your device does not support Image Playground, or you don't have access to it.",
          preferredStyle: .alert
        )
        alert.addAction(
          UIAlertAction(title: "OK", style: .default) { _ in
            continuation.resume(returning: [:])
          })

        currentViewController.present(alert, animated: true)
      }
    }
  }
}

@available(iOS 18.1, *)
class SupportedImagePlaygroundHandler: ImagePlaygroundHandler {
  private weak var appContext: AppContext?
  private var delegate: ImagePlaygroundDelegate?
  @Environment(\.supportsImagePlayground) private var supportsImagePlayground

  init(appContext: AppContext?) {
    self.appContext = appContext
  }

  private func loadImage(from urlString: String) async throws -> UIImage? {
    guard let url = URL(string: urlString) else { return nil }

    if url.scheme == "file" {
      throw NSError(
        domain: "ReactNativeImagePlayground",
        code: -2,
        userInfo: [
          NSLocalizedDescriptionKey:
            "Local images are not supported. Please use remote images (http:// or https:// URLs) only."
        ]
      )
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return UIImage(data: data)
  }

  func launch(params: [String: Any]?) async throws -> [String: Any] {
    guard supportsImagePlayground else {
      return try await UnsupportedImagePlaygroundHandler(appContext: appContext).launch(
        params: params)
    }

    return try await withCheckedThrowingContinuation { continuation in
      Task { @MainActor in
        let controller = ImagePlaygroundViewController()
        controller.modalPresentationStyle = .pageSheet
        controller.isModalInPresentation = false

        if let source = params?["source"] as? String {
          if let image = try? await loadImage(from: source) {
            controller.sourceImage = image
          }
        }

        if let options = params?["concepts"] as? [String: Any] {
          controller.concepts = createConcepts(from: options)
        }

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

  private func createConcepts(from options: [String: Any]?) -> [ImagePlaygroundConcept] {
    guard let options = options else { return [] }

    if let text = options["text"] {
      if let stringArray = text as? [String] {
        return stringArray.map { .text($0) }
      } else if let singleString = text as? String {
        return [.text(singleString)]
      }
    }

    if let content = options["content"] as? String {
      let title = options["title"] as? String
      return [.extracted(from: content, title: title)]
    }

    return []
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
      completion(.success([:]))
    }
  }
}
