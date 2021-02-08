//
//  ControlBar.swift
//  Mobile
//
//  Created by Angel Landoni on 31/1/21.
//

import ShinyUI

func ControlBar<I1: View, C1: View>(_ i1: I1, _ c1: C1) -> some View {
    ControlBar1(item: i1, content: c1)
}

func ControlBar<I1: View, I2: View, C1: View, C2: View>(_ i1: I1,
                                                        _ i2: I2,
                                                        _ c1: C1,
                                                        _ c2: C2) -> some View {
    ControlBar2(item1: i1, item2: i2, content1: c1, content2: c2)
}

func ControlBar<I1: View, I2: View, I3: View,
                C1: View, C2: View, C3: View>(_ i1: I1,
                                              _ i2: I2,
                                              _ i3: I3,
                                              _ c1: C1,
                                              _ c2: C2,
                                              _ c3: C3) -> some View {
    ControlBar3(item1: i1, item2: i2, item3: i3,
                content1: c1, content2: c2, content3: c3)
}

func ControlBar<I1: View, I2: View, I3: View, I4: View,
                C1: View, C2: View, C3: View, C4: View>(_ i1: I1,
                                              _ i2: I2,
                                              _ i3: I3,
                                              _ i4: I4,
                                              _ c1: C1,
                                              _ c2: C2,
                                              _ c3: C3,
                                              _ c4: C4) -> some View {
    ControlBar4(item1: i1, item2: i2, item3: i3, item4: i4,
                content1: c1, content2: c2, content3: c3, content4: c4)
}

func ControlBar<I1: View, I2: View, I3: View, I4: View, I5: View,
                C1: View, C2: View, C3: View, C4: View, C5: View>(_ i1: I1,
                                              _ i2: I2,
                                              _ i3: I3,
                                              _ i4: I4,
                                              _ i5: I5,
                                              _ c1: C1,
                                              _ c2: C2,
                                              _ c3: C3,
                                              _ c4: C4,
                                              _ c5: C5) -> some View {
    ControlBar5(item1: i1, item2: i2, item3: i3, item4: i4, item5: i5,
                content1: c1, content2: c2, content3: c3,
                content4: c4, content5: c5)
}

@available(iOS, unavailable, message: "iOS does not support more than 5 items")
func ControlBar<I1: View, I2: View, I3: View, I4: View, I5: View, I6: View,
                C1: View, C2: View, C3: View,
                C4: View, C5: View, C6: View>(_ i1: I1,
                                              _ i2: I2,
                                              _ i3: I3,
                                              _ i4: I4,
                                              _ i5: I5,
                                              _ i6: I6,
                                              _ c1: C1,
                                              _ c2: C2,
                                              _ c3: C3,
                                              _ c4: C4,
                                              _ c5: C5,
                                              _ c6: C6) -> some View {
    ControlBar6(item1: i1, item2: i2, item3: i3,
                item4: i4, item5: i5, item6: i6,
                content1: c1, content2: c2, content3: c3,
                content4: c4, content5: c5, content6: c6)
}

struct ControlBar1<Item: View, Content: View>: View {

    private let item: Item
    private let content: Content

    init(item: Item, content: Content) {
        self.item = item
        self.content = content
    }

    #if targetEnvironment(macCatalyst)
    var body: some View {
        barBody(item, content)
    }
    #elseif os(iOS)
    var body: some View {
        barBody(item, content)
    }
    #else
    var body: some View {
        Text("Not supported yet")
    }
    #endif
}

struct ControlBar2<I1: View, I2: View, C1: View, C2: View>: View {

    private let item1: I1
    private let item2: I2
    private let content1: C1
    private let content2: C2

    init(item1: I1, item2: I2, content1: C1, content2: C2) {
        self.item1 = item1
        self.item2 = item2
        self.content1 = content1
        self.content2 = content2
    }

    #if targetEnvironment(macCatalyst)
    var body: some View {
        barBody(VStack {
            item1
            item2
        }, content1)
    }
    #elseif os(iOS)
    var body: some View {
        barBody(VStack {
            item1
            item2
        }, content1)
    }
    #else
    var body: some View {
        Text("Not supported yet")
    }
    #endif
}

struct ControlBar3<I1: View, I2: View, I3: View,
                   C1: View, C2: View, C3: View>: View {

    private let item1: I1
    private let item2: I2
    private let item3: I3
    private let content1: C1
    private let content2: C2
    private let content3: C3

    init(item1: I1, item2: I2, item3: I3,
         content1: C1, content2: C2, content3: C3) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
    }

    #if targetEnvironment(macCatalyst)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
        }, content1)
    }
    #elseif os(iOS)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
        }, content1)
    }
    #else
    var body: some View {
        Text("Not supported yet")
    }
    #endif
}

struct ControlBar4<I1: View, I2: View, I3: View, I4: View,
                   C1: View, C2: View, C3: View, C4: View>: View {

    private let item1: I1
    private let item2: I2
    private let item3: I3
    private let item4: I4
    private let content1: C1
    private let content2: C2
    private let content3: C3
    private let content4: C4

    init(item1: I1, item2: I2, item3: I3, item4: I4,
         content1: C1, content2: C2, content3: C3, content4: C4) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
    }

    #if targetEnvironment(macCatalyst)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
            item4
        }, content1)
    }
    #elseif os(iOS)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
            item4
        }, content1)
    }
    #else
    var body: some View {
        Text("Not supported yet")
    }
    #endif
}

struct ControlBar5<I1: View, I2: View, I3: View, I4: View, I5: View,
                   C1: View, C2: View, C3: View, C4: View, C5: View>: View {

    private let item1: I1
    private let item2: I2
    private let item3: I3
    private let item4: I4
    private let item5: I5
    private let content1: C1
    private let content2: C2
    private let content3: C3
    private let content4: C4
    private let content5: C5

    init(item1: I1, item2: I2, item3: I3, item4: I4, item5: I5,
         content1: C1, content2: C2, content3: C3, content4: C4, content5: C5) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
        self.content5 = content5
    }

    #if targetEnvironment(macCatalyst)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
            item4
            item5
        }, content1)
    }
    #elseif os(iOS)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
            item4
            item5
        }, content1)
    }
    #else
    var body: some View {
        Text("Not supported yet")
    }
    #endif
}

@available(iOS, unavailable, message: "iOS does not support more than 5 items")
struct ControlBar6<I1: View, I2: View, I3: View,
                   I4: View, I5: View, I6: View,
                   C1: View, C2: View, C3: View,
                   C4: View, C5: View, C6: View>: View {

    private let item1: I1
    private let item2: I2
    private let item3: I3
    private let item4: I4
    private let item5: I5
    private let item6: I6
    private let content1: C1
    private let content2: C2
    private let content3: C3
    private let content4: C4
    private let content5: C5
    private let content6: C6

    init(item1: I1, item2: I2, item3: I3, item4: I4, item5: I5, item6: I6,
         content1: C1, content2: C2, content3: C3,
         content4: C4, content5: C5, content6: C6) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
        self.item6 = item6
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
        self.content5 = content5
        self.content6 = content6
    }

    #if targetEnvironment(macCatalyst)
    var body: some View {
        barBody(VStack {
            item1
            item2
            item3
            item4
            item5
            item6
        }, content1)
    }
    #elseif os(iOS)
    var body: Never {
        fatalError("Should never happen")
    }
    #else
    var body: some View {
        Text("Not supported yet")
    }
    #endif
}

/// TODO: ControlBar6 ... ControlBarX

private func
barBody<Items: View, Content: View>(_ items: Items, _ content: Content)
-> some View {
    HStack(alignment: .start) {
        VStack(alignment: .start) {
            items
            Spacer()
        }
        .margin(top(70))
        .frame(width: 205)
        .decorate {
            color(Color(0xF3F3F7))
            borderColor(Color(0xE5E5E8))
            borderWidth(1)
        }
        content
    }
}
