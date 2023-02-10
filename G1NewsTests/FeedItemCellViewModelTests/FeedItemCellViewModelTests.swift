import XCTest
@testable import G1News

final class FeedItemCellViewModelTests: XCTestCase {
    typealias Sut = FeedItemCellViewModel
 
    func test_TitleText_ShouldReturnTitleText() {
        let title = ""
        
        let sut = Sut(model: .fixture(content: .fixture(title: title)))

        XCTAssertEqual(sut.titleText(), title)
    }
    
    func test_SummaryText_ShouldReturn_SummaryText() {
        let summary = ""
        
        let sut = Sut(model: .fixture(content: .fixture(summary: summary)))

        XCTAssertEqual(sut.summaryText(), summary)
    }

    func test_HatText_ShouldReturn_HatText() {
        let hatLabel = ""
        
        let sut = Sut(model: .fixture(content: .fixture(chapeu: .fixture(label: hatLabel))))

        XCTAssertEqual(sut.hatText(), hatLabel)
    }
    
    func test_Age_ShouldReturn_Age() {
        let age = 0
        let str = " atrás."
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .month, .hour, .minute]
        formatter.unitsStyle = .brief
        
        let sut = Sut(model: .fixture(age: age))
        guard let expected = formatter.string(from: TimeInterval(age)) else { return }

        XCTAssertEqual(sut.formatAge(), expected + str)
    }

    func test_GetImage_ShouldReturnImage_BasedOnURL() {
        let image = ""
        
        let str = URL(string: image)
        
        let sut = Sut(model: .fixture(content: .fixture(image: .fixture(url: image))))

        XCTAssertEqual(sut.getIcon(), str)
    }
}

extension Item {
    static func fixture(content: Content = .fixture(), age: Int = 0) -> Item {
        Item(content: content, age: age)
    }
}

extension Content {
    static func fixture(chapeu: Hat? = nil, summary: String = "", title: String = "", image: Icon? = nil, url: String? = nil) -> Content {
        Content(chapeu: chapeu, summary: summary, title: title, image: image, url: url)
    }
}

extension Hat {
    static func fixture(label: String? = nil) -> Hat {
        Hat(label: label)
    }
}

extension Icon {
    static func fixture(url: String? = nil) -> Icon {
        Icon(url: url)
    }
}
