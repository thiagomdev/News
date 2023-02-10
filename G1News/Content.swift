struct Content: Decodable, Equatable {
    let chapeu: Hat?
    let summary: String?
    let title: String
    let image: Icon?
    let url: String?
}

struct Icon: Decodable, Equatable {
    let url: String?
}
