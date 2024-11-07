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
          showGenerator.toggle()
        }, label: { Label("Generate Image", systemImage: "wand.and.sparkles") }
      )
      .font(.headline)
      .foregroundColor(.white)
      .frame(width: 200, height: 50)
      .background(Color.blue)
      .cornerRadius(10)
      .padding()
    }.imagePlaygroundSheet(
      isPresented: $showGenerator, concept: "Japan", onCompletion: { self.imageURL = $0 })
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
