import ExpoModulesCore
import ImagePlayground
import SwiftUI

@available(iOS 18.1, *)
struct ContentView: View {
  @State var showGenerator = true
  @State var imageURL: URL? = nil

  var body: some View {
    VStack {
      if let imageURL {
        AsyncImage(url: imageURL) { phase in
          switch phase {
          case .empty:
            ProgressView()
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          case .failure:
            Image(systemName: "photo")
          @unknown default:
            EmptyView()
          }
        }
      }
      Button(
        action: {
          generate()
        }, label: { Label("Generate Image", systemImage: "wand.and.sparkles") }
      )
      .font(.headline)
      .foregroundColor(.white)
      .frame(width: 200, height: 50)
      .background(Color.blue)
      .cornerRadius(10)
      .padding()
    }
    .sheet(isPresented: $showGenerator) {
      ImagePlaygroundScreen { image in
        showGenerator = false
        self.imageURL = image
      }
      .ignoresSafeArea()
    }
  }

  func generate() {
    showGenerator.toggle()
  }
}

@available(iOS 18.1, *)
struct ImagePlaygroundScreen: UIViewControllerRepresentable {
  var onFinish: (URL?) -> Void

  func makeUIViewController(context: Context) -> ImagePlaygroundViewController {
    let controller = ImagePlaygroundViewController()
    controller.delegate = context.coordinator
    controller.modalPresentationStyle = .fullScreen
    return controller
  }

  func updateUIViewController(_ uiViewController: ImagePlaygroundViewController, context: Context) {
    uiViewController.delegate = context.coordinator
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(onFinish: onFinish)
  }

  class Coordinator: NSObject, ImagePlaygroundViewController.Delegate {
    var onFinish: (URL?) -> Void

    init(onFinish: @escaping (URL?) -> Void) {
      self.onFinish = onFinish
    }

    func imagePlaygroundViewController(
      _ controller: ImagePlaygroundViewController, didCreateImageAt imageURL: URL
    ) {
      onFinish(imageURL)
    }

    func imagePlaygroundViewControllerDidCancel(
      _ imagePlaygroundViewController: ImagePlaygroundViewController
    ) {
      onFinish(nil)
    }
  }
}

@available(iOS 18.1, *)
class ReactNativeImagePlaygroundView: ExpoView {
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)

    let contentView = ContentView()
    let hostingController = UIHostingController(rootView: contentView)
    hostingController.view.backgroundColor = .clear

    addSubview(hostingController.view)
    hostingController.view.frame = bounds
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
