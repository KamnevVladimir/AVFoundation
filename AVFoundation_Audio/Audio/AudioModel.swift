struct Audio {
    let author: String
    let name: String
    let bundleName: String
    let format: String
}

struct AudioModel {
    static var audios: [Audio] = [
        Audio(author: "Queen", name: "The Show Must Go On", bundleName: "Queen", format: "mp3"),
        Audio(author: "Би-2", name: "Пекло", bundleName: "Би-2 - Пекло", format: "mp3"),
        Audio(author: "AnnenMayKantereit", name: "Ich geh heut nicht mehr tanzen", bundleName: "AnnenMayKantereit - Ich geh heut nicht mehr tanzen", format: "mp3"),
        Audio(author: "TOMMY CASH feat. Bones", name: "Siri", bundleName: "TOMMY CASH feat. Bones - Siri", format: "mp3"),
        Audio(author: "Екатерина Яшникова", name: "Я останусь одна", bundleName: "Екатерина Яшникова - Я останусь одна", format: "mp3"),
        Audio(author: "БумБокс", name: "Та4то (Верся За туманом)", bundleName: "БумБокс - Та4то (Верся За туманом)", format: "mp3"),
    ]
    
    private init() {}
}
