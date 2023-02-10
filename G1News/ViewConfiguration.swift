import UIKit

protocol ViewConfiguration: AnyObject {
    func buildHierarchyView()
    func activeConstraints()
    func configureUI()
    func buildSetup()
}

extension ViewConfiguration {
    func buildSetup() {
        buildHierarchyView()
        activeConstraints()
        configureUI()
    }
    
    func configureUI() {}
}
