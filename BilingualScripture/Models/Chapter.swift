import Foundation

// Usage within Book or Scripture structure
struct Book: Decodable {
    let book: MultilingualText
    let theme: MultilingualText
    let introduction: MultilingualText
    let chapters: [Chapter]
}

struct Chapter: Identifiable, Decodable {
    var id: Int { number }
    let number: Int
    let introduction: MultilingualText
    let verses: [Verse]
}

struct Verse: Identifiable, Decodable {
    var id: String { key }
    let key: String
    let text: MultilingualText
}

struct MultilingualText: Decodable {
    let en: String
    let zh: String
}

struct AnimeBook: Identifiable
{
    var id: String = UUID().uuidString
    var engTitle: String
    var zhoTitle: String
    var imageName: String
    var period: String
}

var sampleBooks: [AnimeBook] = [
    .init(engTitle: "THE FIRST BOOK OF NEPHI", zhoTitle: "尼腓一書", imageName: "1-ne", period: "About 600 B.C."),
    .init(engTitle: "THE SECOND BOOK OF NEPHI", zhoTitle: "尼腓二書", imageName: "2-ne", period: "About 588–570 B.C."),
    .init(engTitle: "THE BOOK OF JACOB", zhoTitle: "雅各書", imageName: "jacob", period: "About 544–421 B.C."),
    .init(engTitle: "THE BOOK OF ENOS", zhoTitle: "以挪士書", imageName: "enos", period: "About 420 B.C."),
    .init(engTitle: "THE BOOK OF JAROM", zhoTitle: "雅龍書", imageName: "jarom", period: "About 399–361 B.C."),
    .init(engTitle: "THE BOOK OF OMNI", zhoTitle: "奧姆乃書", imageName: "omni", period: "About 323–130 B.C."),
    .init(engTitle: "THE WORDS OF MORMON", zhoTitle: "摩爾門語", imageName: "w-of-m", period: "About A.D. 385."),
    .init(engTitle: "THE BOOK OF MOSIAH", zhoTitle: "摩賽亞書", imageName: "mosiah", period: "About 130–124 B.C."),
    .init(engTitle: "THE BOOK OF ALMA", zhoTitle: "阿爾瑪書", imageName: "alma", period: "About 91–88 B.C."),
    .init(engTitle: "THE BOOK OF HELAMAN", zhoTitle: "希拉曼書", imageName: "hel", period: "About 52–50 B.C."),
    .init(engTitle: "THIRD NEPHI", zhoTitle: "尼腓三書", imageName: "3-ne", period: "About A.D. 1–4."),
    .init(engTitle: "FOURTH NEPHI", zhoTitle: "尼腓四書", imageName: "4-ne", period: "About A.D. 35–321."),
    .init(engTitle: "THE BOOK OF MORMON", zhoTitle: "摩爾門書", imageName: "morm", period: "About A.D. 321–26."),
    .init(engTitle: "THE BOOK OF ETHER", zhoTitle: "以帖書", imageName: "ether", period: ""),
    .init(engTitle: "THE BOOK OF MORONI", zhoTitle: "摩羅乃書", imageName: "moro", period: "About A.D. 401–21."),
    .init(engTitle: "THE DOCTRINE AND COVENANTS", zhoTitle: "教義和聖約", imageName: "dc", period: "")
]
