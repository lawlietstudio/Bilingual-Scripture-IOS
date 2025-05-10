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
    let summary: MultilingualText?
    let verses: [Verse]
}

struct Verse: Identifiable, Decodable {
    var id: String { key }
    let key: String
    let text: MultilingualText
}

struct MultilingualText: Decodable {
    let fr: String
    let en: String
    let zh: String
    let jp: String
    let kr: String
    
    func getText(lang: SpeechLang) -> String {
        switch lang {
        case .en:
            return en
        case .fr:
            return fr
        case .zh_Hans:
            return zh
        case .zh_Hant:
            return zh
        case .jp:
            return jp
        case .kr:
            return kr
        }
    }
}

struct AnimeBook: Identifiable
{
    var id: String = UUID().uuidString
    var scriptureName: String
    var bookName: String
    var period: String
    
    var localizedBookName: String {
        "book_\(bookName)"
    }
}

// Book of Mormon
var sampleBOFM: [AnimeBook] = [
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "1-ne", period: "About 600 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "2-ne", period: "About 588–570 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "jacob", period: "About 544–421 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "enos", period: "About 420 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "jarom", period: "About 399–361 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "omni", period: "About 323–130 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "w-of-m", period: "About A.D. 385."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "mosiah", period: "About 130–124 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "alma", period: "About 91–88 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "hel", period: "About 52–50 B.C."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "3-ne", period: "About A.D. 1–4."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "4-ne", period: "About A.D. 35–321."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "morm", period: "About A.D. 321–26."),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "ether", period: ""),
    .init(scriptureName: TabModel.Tab.bofm.short, bookName: "moro", period: "About A.D. 401–21.")
]

// Doctrine and Covenants
var sampleDC: [AnimeBook] = [
    .init(scriptureName: TabModel.Tab.dc.short, bookName: "dc", period: "")
]

// Pearl of Great Price
var samplePGP: [AnimeBook] = [
    .init(scriptureName: TabModel.Tab.pgp.short, bookName: "moses", period: ""),
    .init(scriptureName: TabModel.Tab.pgp.short, bookName: "abr", period: "")
]

// Old Testament
var sampleOT: [AnimeBook] = [
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "gen", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "ex", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "lev", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "num", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "deut", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "josh", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "judg", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "ruth", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "1-sam", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "2-sam", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "1-kgs", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "2-kgs", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "1-chr", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "2-chr", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "ezra", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "neh", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "esth", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "job", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "ps", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "prov", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "eccl", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "song", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "isa", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "jer", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "lam", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "ezek", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "dan", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "hosea", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "joel", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "amos", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "obad", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "jonah", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "micah", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "nahum", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "hab", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "zeph", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "hag", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "zech", period: ""),
    .init(scriptureName: TabModel.Tab.ot.short, bookName: "mal", period: "")
]

// New Testament
var sampleNT: [AnimeBook] = [
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "matt", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "mark", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "luke", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "john", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "acts", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "rom", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "1-cor", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "2-cor", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "gal", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "eph", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "philip", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "col", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "1-thes", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "2-thes", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "1-tim", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "2-tim", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "titus", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "philem", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "heb", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "james", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "1-pet", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "2-pet", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "1-jn", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "2-jn", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "3-jn", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "jude", period: ""),
    .init(scriptureName: TabModel.Tab.nt.short, bookName: "rev", period: "")
]
