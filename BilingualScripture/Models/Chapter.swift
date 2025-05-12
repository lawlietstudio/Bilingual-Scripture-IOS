import Foundation

struct Chapter: Identifiable, Decodable {
    var id: Int = 0
    var intro: [String: String?]
    var summary: [String: String?]
    var verses: [[String: String?]]
    
    private enum CodingKeys: String, CodingKey {
        case intro, summary, verses
    }
}

struct AnimeBook: Identifiable
{
    var id: String = UUID().uuidString
    var category: String
    var bookName: String
    var period: String
    
    var localizedBookName: String {
        "book_\(bookName)"
    }
}

// Book of Mormon
var categoryBOFM: [AnimeBook] = [
    .init(category: TabModel.Tab.bofm.short, bookName: "1-ne", period: "About 600 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "2-ne", period: "About 588–570 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "jacob", period: "About 544–421 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "enos", period: "About 420 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "jarom", period: "About 399–361 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "omni", period: "About 323–130 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "w-of-m", period: "About A.D. 385."),
    .init(category: TabModel.Tab.bofm.short, bookName: "mosiah", period: "About 130–124 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "alma", period: "About 91–88 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "hel", period: "About 52–50 B.C."),
    .init(category: TabModel.Tab.bofm.short, bookName: "3-ne", period: "About A.D. 1–4."),
    .init(category: TabModel.Tab.bofm.short, bookName: "4-ne", period: "About A.D. 35–321."),
    .init(category: TabModel.Tab.bofm.short, bookName: "morm", period: "About A.D. 321–26."),
    .init(category: TabModel.Tab.bofm.short, bookName: "ether", period: ""),
    .init(category: TabModel.Tab.bofm.short, bookName: "moro", period: "About A.D. 401–21.")
]

// Doctrine and Covenants
var categoryDC: [AnimeBook] = [
    .init(category: TabModel.Tab.dc.short, bookName: "dc", period: "")
]

// Pearl of Great Price
var categoryPGP: [AnimeBook] = [
    .init(category: TabModel.Tab.pgp.short, bookName: "moses", period: ""),
    .init(category: TabModel.Tab.pgp.short, bookName: "abr", period: ""),
    .init(category: TabModel.Tab.pgp.short, bookName: "js-m", period: ""),
    .init(category: TabModel.Tab.pgp.short, bookName: "js-h", period: ""),
    .init(category: TabModel.Tab.pgp.short, bookName: "a-of-f", period: "")
]

var booksOT: [AnimeBook] = [
    .init(category: TabModel.Tab.ot.short, bookName: "gen", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "ex", period: ""),
]

// Old Testament
var categoryOT: [AnimeBook] = [
    .init(category: TabModel.Tab.ot.short, bookName: "gen", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "ex", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "lev", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "num", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "deut", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "josh", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "judg", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "ruth", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "1-sam", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "2-sam", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "1-kgs", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "2-kgs", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "1-chr", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "2-chr", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "ezra", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "neh", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "esth", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "job", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "ps", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "prov", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "eccl", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "song", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "isa", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "jer", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "lam", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "ezek", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "dan", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "hosea", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "joel", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "amos", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "obad", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "jonah", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "micah", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "nahum", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "hab", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "zeph", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "hag", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "zech", period: ""),
    .init(category: TabModel.Tab.ot.short, bookName: "mal", period: "")
]

// New Testament
var categoryNT: [AnimeBook] = [
    .init(category: TabModel.Tab.nt.short, bookName: "matt", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "mark", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "luke", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "john", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "acts", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "rom", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "1-cor", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "2-cor", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "gal", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "eph", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "philip", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "col", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "1-thes", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "2-thes", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "1-tim", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "2-tim", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "titus", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "philem", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "heb", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "james", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "1-pet", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "2-pet", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "1-jn", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "2-jn", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "3-jn", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "jude", period: ""),
    .init(category: TabModel.Tab.nt.short, bookName: "rev", period: "")
]
