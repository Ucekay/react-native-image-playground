import ExpoModulesCore
import ImagePlayground
import SwiftUICore

protocol ImagePlaygroundHandler {
  func launch(
    conceptOptions: [String: Any],
    sourceImage: [String: Any]?
  ) async throws -> [String: Any]
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

    AsyncFunction("launchImagePlaygroundAsync") {
      (
        conceptOptions: [String: Any],
        sourceImage: [String: Any]?
      ) -> [String: Any] in
      if #available(iOS 18.1, *) {
        self.handler = SupportedImagePlaygroundHandler(appContext: self.appContext)
      } else {
        self.handler = UnsupportedImagePlaygroundHandler(appContext: self.appContext)
      }
      return try await self.handler?.launch(
        conceptOptions: conceptOptions,
        sourceImage: sourceImage
      ) ?? [:]
    }
  }
}

class UnsupportedImagePlaygroundHandler: ImagePlaygroundHandler {
  private weak var appContext: AppContext?

  init(appContext: AppContext?) {
    self.appContext = appContext
  }

  func launch(
    conceptOptions: [String: Any],
    sourceImage: [String: Any]?
  ) async throws -> [String: Any] {
    return try await withCheckedThrowingContinuation { continuation in
      Task { @MainActor in
        guard let currentViewController = self.appContext?.utilities?.currentViewController() else {
          continuation.resume(throwing: NSError(domain: "ReactNativeImagePlayground", code: -1))
          return
        }

        let alert = UIAlertController(
          title: "Image Playground is not available",
          message:
            "Image Playground is only available on iOS 18.1 and later, and is supported on iPhone 15 Pro, iPhone 15 Pro Max, and iPhone 16 series.",
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

    // ローカルファイルの場合
    if url.scheme == "file" {
      return UIImage(contentsOfFile: url.path)
    }

    // リモートURLの場合
    let (data, _) = try await URLSession.shared.data(from: url)
    return UIImage(data: data)
  }

  func launch(
    conceptOptions: [String: Any],
    sourceImage: [String: Any]?
  ) async throws -> [String: Any] {
    guard supportsImagePlayground else {
      return try await UnsupportedImagePlaygroundHandler(appContext: appContext).launch(
        conceptOptions: conceptOptions,
        sourceImage: sourceImage
      )
    }

    return try await withCheckedThrowingContinuation { continuation in
      Task { @MainActor in
        let controller = ImagePlaygroundViewController()
        controller.modalPresentationStyle = .automatic
        controller.isModalInPresentation = false

        // sourceImageの設定（非同期）
        if let uri = sourceImage?["uri"] as? String {
          if let image = try? await loadImage(from: uri) {
            controller.sourceImage = image
          }
        }

        // コンセプトの生成
        controller.concepts = createConcepts(from: conceptOptions)

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

  private func createConcepts(from options: [String: Any]) -> [ImagePlaygroundConcept] {
    guard let type = options["type"] as? String else {
      return []
    }

    switch type {
    case "text":
      if let content = options["content"] as? [String] {
        return content.map { .text($0) }
      } else if let content = options["content"] as? String {
        return [.text(content)]
      }
      return []
    case "extractedWithTitle":
      guard let content = options["content"] as? String else { return [] }
      let title = options["title"] as? String
      return [.extracted(from: content, title: title)]
    default:
      return []
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
      completion(.success([:]))
    }
  }
}
