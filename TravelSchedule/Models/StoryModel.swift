import SwiftUI

struct Story: Identifiable {
    let id: Int
    let backgroundColor: Color
    let title: String
    let description: String
    let imageName: String
    var isViewed: Bool = false

    static let story1 = Story(
        id: 0,
        backgroundColor: .story1Background,
        title: "🎉 ⭐️ ❤️",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        imageName: "st_1"
    )

    static let story2 = Story(
        id: 1,
        backgroundColor: .story2Background,
        title: "😍 🌸 🥬",
        description: "Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 Text2 ",
        imageName: "st_2"
    )

    static let story3 = Story(
        id: 2,
        backgroundColor: .story3Background,
        title: "🧀 🥑 🥚",
        description: "Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 Text3 ",
        imageName: "st_3"
    )
    
    static let story4 = Story(
        id: 3,
        backgroundColor: .story1Background,
        title: "🥚 🥬 ⭐️",
        description: "Text4 Text4 Text4 Text4 Text4 Text4 Text4 Text4 ",
        imageName: "st_4"
    )
    
    static let story5 = Story(
        id: 4,
        backgroundColor: .story2Background,
        title: "🥑 ❤️ 😍",
        description: "Text5 Text5 ",
        imageName: "st_5"
    )
}
