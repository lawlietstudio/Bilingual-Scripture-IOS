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
}

struct AnimeBook: Identifiable
{
    var id: String = UUID().uuidString
    var engTitle: String
    var zhoTitle: String
    var scriptureName: String
    var bookName: String
    var period: String
}

// Book of Mormon
var sampleBOFM: [AnimeBook] = [
    .init(engTitle: "THE FIRST BOOK OF NEPHI", zhoTitle: "尼腓一書", scriptureName: TabModel.Tab.bofm.short, bookName: "1-ne", period: "About 600 B.C."),
    .init(engTitle: "THE SECOND BOOK OF NEPHI", zhoTitle: "尼腓二書", scriptureName: TabModel.Tab.bofm.short, bookName: "2-ne", period: "About 588–570 B.C."),
    .init(engTitle: "THE BOOK OF JACOB", zhoTitle: "雅各書", scriptureName: TabModel.Tab.bofm.short, bookName: "jacob", period: "About 544–421 B.C."),
    .init(engTitle: "THE BOOK OF ENOS", zhoTitle: "以挪士書", scriptureName: TabModel.Tab.bofm.short, bookName: "enos", period: "About 420 B.C."),
    .init(engTitle: "THE BOOK OF JAROM", zhoTitle: "雅龍書", scriptureName: TabModel.Tab.bofm.short, bookName: "jarom", period: "About 399–361 B.C."),
    .init(engTitle: "THE BOOK OF OMNI", zhoTitle: "奧姆乃書", scriptureName: TabModel.Tab.bofm.short, bookName: "omni", period: "About 323–130 B.C."),
    .init(engTitle: "THE WORDS OF MORMON", zhoTitle: "摩爾門語", scriptureName: TabModel.Tab.bofm.short, bookName: "w-of-m", period: "About A.D. 385."),
    .init(engTitle: "THE BOOK OF MOSIAH", zhoTitle: "摩賽亞書", scriptureName: TabModel.Tab.bofm.short, bookName: "mosiah", period: "About 130–124 B.C."),
    .init(engTitle: "THE BOOK OF ALMA", zhoTitle: "阿爾瑪書", scriptureName: TabModel.Tab.bofm.short, bookName: "alma", period: "About 91–88 B.C."),
    .init(engTitle: "THE BOOK OF HELAMAN", zhoTitle: "希拉曼書", scriptureName: TabModel.Tab.bofm.short, bookName: "hel", period: "About 52–50 B.C."),
    .init(engTitle: "THIRD NEPHI", zhoTitle: "尼腓三書", scriptureName: TabModel.Tab.bofm.short, bookName: "3-ne", period: "About A.D. 1–4."),
    .init(engTitle: "FOURTH NEPHI", zhoTitle: "尼腓四書", scriptureName: TabModel.Tab.bofm.short, bookName: "4-ne", period: "About A.D. 35–321."),
    .init(engTitle: "THE BOOK OF MORMON", zhoTitle: "摩爾門書", scriptureName: TabModel.Tab.bofm.short, bookName: "morm", period: "About A.D. 321–26."),
    .init(engTitle: "THE BOOK OF ETHER", zhoTitle: "以帖書", scriptureName: TabModel.Tab.bofm.short, bookName: "ether", period: ""),
    .init(engTitle: "THE BOOK OF MORONI", zhoTitle: "摩羅乃書", scriptureName: TabModel.Tab.bofm.short, bookName: "moro", period: "About A.D. 401–21.")
]

// Doctrine and Covenants
var sampleDC: [AnimeBook] = [
    .init(engTitle: "THE DOCTRINE AND COVENANTS", zhoTitle: "教義和聖約", scriptureName: TabModel.Tab.dc.short, bookName: "dc", period: "")
]

// Pearl of Great Price
var samplePGP: [AnimeBook] = [
    .init(engTitle: "THe BOOK OF MOSES", zhoTitle: "摩西書", scriptureName: TabModel.Tab.pgp.short, bookName: "moses", period: ""),
    .init(engTitle: "THE BOOK OF ABRAHAM", zhoTitle: "亞伯拉罕書", scriptureName: TabModel.Tab.pgp.short, bookName: "abr", period: "")
]

// Old Testament
var sampleOT: [AnimeBook] = [
    .init(engTitle: "GENESIS", zhoTitle: "創世記", scriptureName: TabModel.Tab.ot.short, bookName: "gen", period: ""),
    .init(engTitle: "EXODUS", zhoTitle: "出埃及記", scriptureName: TabModel.Tab.ot.short, bookName: "ex", period: ""),
    .init(engTitle: "LEVITICUS", zhoTitle: "利未記", scriptureName: TabModel.Tab.ot.short, bookName: "lev", period: ""),
    .init(engTitle: "NUMBERS", zhoTitle: "民數記", scriptureName: TabModel.Tab.ot.short, bookName: "num", period: ""),
    .init(engTitle: "DEUTERONOMY", zhoTitle: "申命記", scriptureName: TabModel.Tab.ot.short, bookName: "deut", period: ""),
    .init(engTitle: "JOSHUA", zhoTitle: "約書亞記", scriptureName: TabModel.Tab.ot.short, bookName: "josh", period: ""),
    .init(engTitle: "JUDGES", zhoTitle: "士師記", scriptureName: TabModel.Tab.ot.short, bookName: "judg", period: ""),
    .init(engTitle: "RUTH", zhoTitle: "路得記", scriptureName: TabModel.Tab.ot.short, bookName: "ruth", period: ""),
    .init(engTitle: "1 SAMUEL", zhoTitle: "撒母耳記上", scriptureName: TabModel.Tab.ot.short, bookName: "1-sam", period: ""),
    .init(engTitle: "2 SAMUEL", zhoTitle: "撒母耳記下", scriptureName: TabModel.Tab.ot.short, bookName: "2-sam", period: ""),
    .init(engTitle: "1 KINGS", zhoTitle: "列王記上", scriptureName: TabModel.Tab.ot.short, bookName: "1-kgs", period: ""),
    .init(engTitle: "2 KINGS", zhoTitle: "列王記下", scriptureName: TabModel.Tab.ot.short, bookName: "2-kgs", period: ""),
    .init(engTitle: "1 CHRONICLES", zhoTitle: "歷代志上", scriptureName: TabModel.Tab.ot.short, bookName: "1-chr", period: ""),
    .init(engTitle: "2 CHRONICLES", zhoTitle: "歷代志下", scriptureName: TabModel.Tab.ot.short, bookName: "2-chr", period: ""),
    .init(engTitle: "EZRA", zhoTitle: "以斯拉記", scriptureName: TabModel.Tab.ot.short, bookName: "ezra", period: ""),
    .init(engTitle: "NEHEMIAH", zhoTitle: "尼希米記", scriptureName: TabModel.Tab.ot.short, bookName: "neh", period: ""),
    .init(engTitle: "ESTHER", zhoTitle: "以斯帖記", scriptureName: TabModel.Tab.ot.short, bookName: "esth", period: ""),
    .init(engTitle: "JOB", zhoTitle: "約伯記", scriptureName: TabModel.Tab.ot.short, bookName: "job", period: ""),
    .init(engTitle: "PSALMS", zhoTitle: "詩篇", scriptureName: TabModel.Tab.ot.short, bookName: "ps", period: ""),
    .init(engTitle: "PROVERBS", zhoTitle: "箴言", scriptureName: TabModel.Tab.ot.short, bookName: "prov", period: ""),
    .init(engTitle: "ECCLESIASTES", zhoTitle: "傳道書", scriptureName: TabModel.Tab.ot.short, bookName: "eccl", period: ""),
    .init(engTitle: "SONG OF SOLOMON", zhoTitle: "雅歌", scriptureName: TabModel.Tab.ot.short, bookName: "song", period: ""),
    .init(engTitle: "ISAIAH", zhoTitle: "以賽亞書", scriptureName: TabModel.Tab.ot.short, bookName: "isa", period: ""),
    .init(engTitle: "JEREMIAH", zhoTitle: "耶利米書", scriptureName: TabModel.Tab.ot.short, bookName: "jer", period: ""),
    .init(engTitle: "LAMENTATIONS", zhoTitle: "耶利米哀歌", scriptureName: TabModel.Tab.ot.short, bookName: "lam", period: ""),
    .init(engTitle: "EZEKIEL", zhoTitle: "以西結書", scriptureName: TabModel.Tab.ot.short, bookName: "ezek", period: ""),
    .init(engTitle: "DANIEL", zhoTitle: "但以理書", scriptureName: TabModel.Tab.ot.short, bookName: "dan", period: ""),
    .init(engTitle: "HOSEA", zhoTitle: "何西阿書", scriptureName: TabModel.Tab.ot.short, bookName: "hosea", period: ""),
    .init(engTitle: "JOEL", zhoTitle: "約珥書", scriptureName: TabModel.Tab.ot.short, bookName: "joel", period: ""),
    .init(engTitle: "AMOS", zhoTitle: "阿摩司書", scriptureName: TabModel.Tab.ot.short, bookName: "amos", period: ""),
    .init(engTitle: "OBADIAH", zhoTitle: "俄巴底亞書", scriptureName: TabModel.Tab.ot.short, bookName: "obad", period: ""),
    .init(engTitle: "JONAH", zhoTitle: "約拿書", scriptureName: TabModel.Tab.ot.short, bookName: "jonah", period: ""),
    .init(engTitle: "MICAH", zhoTitle: "彌迦書", scriptureName: TabModel.Tab.ot.short, bookName: "micah", period: ""),
    .init(engTitle: "NAHUM", zhoTitle: "那鴻書", scriptureName: TabModel.Tab.ot.short, bookName: "nahum", period: ""),
    .init(engTitle: "HABAKKUK", zhoTitle: "哈巴谷書", scriptureName: TabModel.Tab.ot.short, bookName: "hab", period: ""),
    .init(engTitle: "ZEPHANIAH", zhoTitle: "西番雅書", scriptureName: TabModel.Tab.ot.short, bookName: "zeph", period: ""),
    .init(engTitle: "HAGGAI", zhoTitle: "哈該書", scriptureName: TabModel.Tab.ot.short, bookName: "hag", period: ""),
    .init(engTitle: "ZECHARIAH", zhoTitle: "撒迦利亞書", scriptureName: TabModel.Tab.ot.short, bookName: "zech", period: ""),
    .init(engTitle: "MALACHI", zhoTitle: "瑪拉基書", scriptureName: TabModel.Tab.ot.short, bookName: "mal", period: "")
]

// New Testament
var sampleNT: [AnimeBook] = [
    .init(engTitle: "MATTHEW", zhoTitle: "馬太福音", scriptureName: TabModel.Tab.nt.short, bookName: "matt", period: ""),
    .init(engTitle: "MARK", zhoTitle: "馬可福音", scriptureName: TabModel.Tab.nt.short, bookName: "mark", period: ""),
    .init(engTitle: "LUKE", zhoTitle: "路加福音", scriptureName: TabModel.Tab.nt.short, bookName: "luke", period: ""),
    .init(engTitle: "JOHN", zhoTitle: "約翰福音", scriptureName: TabModel.Tab.nt.short, bookName: "john", period: ""),
    .init(engTitle: "ACTS", zhoTitle: "使徒行傳", scriptureName: TabModel.Tab.nt.short, bookName: "acts", period: ""),
    .init(engTitle: "ROMANS", zhoTitle: "羅馬書", scriptureName: TabModel.Tab.nt.short, bookName: "rom", period: ""),
    .init(engTitle: "1 CORINTHIANS", zhoTitle: "哥林多前書", scriptureName: TabModel.Tab.nt.short, bookName: "1-cor", period: ""),
    .init(engTitle: "2 CORINTHIANS", zhoTitle: "哥林多後書", scriptureName: TabModel.Tab.nt.short, bookName: "2-cor", period: ""),
    .init(engTitle: "GALATIANS", zhoTitle: "加拉太書", scriptureName: TabModel.Tab.nt.short, bookName: "gal", period: ""),
    .init(engTitle: "EPHESIANS", zhoTitle: "以弗所書", scriptureName: TabModel.Tab.nt.short, bookName: "eph", period: ""),
    .init(engTitle: "PHILIPPIANS", zhoTitle: "腓立比書", scriptureName: TabModel.Tab.nt.short, bookName: "philip", period: ""),
    .init(engTitle: "COLOSSIANS", zhoTitle: "歌羅西書", scriptureName: TabModel.Tab.nt.short, bookName: "col", period: ""),
    .init(engTitle: "1 THESSALONIANS", zhoTitle: "帖撒羅尼迦前書", scriptureName: TabModel.Tab.nt.short, bookName: "1-thes", period: ""),
    .init(engTitle: "2 THESSALONIANS", zhoTitle: "帖撒羅尼迦後書", scriptureName: TabModel.Tab.nt.short, bookName: "2-thes", period: ""),
    .init(engTitle: "1 TIMOTHY", zhoTitle: "提摩太前書", scriptureName: TabModel.Tab.nt.short, bookName: "1-tim", period: ""),
    .init(engTitle: "2 TIMOTHY", zhoTitle: "提摩太後書", scriptureName: TabModel.Tab.nt.short, bookName: "2-tim", period: ""),
    .init(engTitle: "TITUS", zhoTitle: "提多書", scriptureName: TabModel.Tab.nt.short, bookName: "titus", period: ""),
    .init(engTitle: "PHILEMON", zhoTitle: "腓利門書", scriptureName: TabModel.Tab.nt.short, bookName: "philem", period: ""),
    .init(engTitle: "HEBREWS", zhoTitle: "希伯來書", scriptureName: TabModel.Tab.nt.short, bookName: "heb", period: ""),
    .init(engTitle: "JAMES", zhoTitle: "雅各書", scriptureName: TabModel.Tab.nt.short, bookName: "james", period: ""),
    .init(engTitle: "1 PETER", zhoTitle: "彼得前書", scriptureName: TabModel.Tab.nt.short, bookName: "1-pet", period: ""),
    .init(engTitle: "2 PETER", zhoTitle: "彼得後書", scriptureName: TabModel.Tab.nt.short, bookName: "2-pet", period: ""),
    .init(engTitle: "1 JOHN", zhoTitle: "約翰一書", scriptureName: TabModel.Tab.nt.short, bookName: "1-jn", period: ""),
    .init(engTitle: "2 JOHN", zhoTitle: "約翰二書", scriptureName: TabModel.Tab.nt.short, bookName: "2-jn", period: ""),
    .init(engTitle: "3 JOHN", zhoTitle: "約翰三書", scriptureName: TabModel.Tab.nt.short, bookName: "3-jn", period: ""),
    .init(engTitle: "JUDE", zhoTitle: "猶大書", scriptureName: TabModel.Tab.nt.short, bookName: "jude", period: ""),
    .init(engTitle: "REVELATION", zhoTitle: "啟示錄", scriptureName: TabModel.Tab.nt.short, bookName: "rev", period: "")
]
