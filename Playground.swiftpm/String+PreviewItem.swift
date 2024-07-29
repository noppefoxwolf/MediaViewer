import UIKit
import MediaViewer
import SwiftUI

extension TextItem: PreviewItem {
    public func makeViewController() async -> UIViewController {
        try! await Task.sleep(for: .seconds(3))
        let vc = UIHostingController(rootView: Group {
            Text(text)
                .foregroundColor(.black)
                .background(.white)
        })
        vc.view.backgroundColor = .clear
        return vc
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        let vc = UIHostingController(rootView: Group {
            Text("Loading...")
                .foregroundColor(.gray)
                .background(.white)
        })
        vc.view.backgroundColor = .clear
        return vc
    }
    
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? {
        nil
    }
}
