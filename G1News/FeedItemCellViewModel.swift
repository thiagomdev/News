import UIKit

final class FeedItemCellViewModel {
    private var model: Item
    
    init(model: Item) {
        self.model = model
    }
    
    func formatAge() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .month, .hour, .minute]
        formatter.unitsStyle = .brief
        guard let expected = formatter.string(from: TimeInterval(model.age)) else { return String() }
        return expected + " atrás."
    }
    
    func titleText() -> String {
        return model.content.title
    }
    
    func summaryText() -> String {
        guard let sumary = model.content.summary else { return String() }
        return sumary
    }
    
    func hatText() -> String {
        guard let hatLabel = model.content.chapeu?.label else { return String() }
        return hatLabel
    }

    func getIcon() -> URL? {
        guard let url = model.content.image?.url else { return URL(string: String()) }
        return url.isEmpty ? nil : URL(string: url)
    }
}
