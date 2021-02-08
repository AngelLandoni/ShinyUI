//
//  BarItem.swift
//  BasicComponents
//
//  Created by Angel Landoni on 29/1/21.
//

import ShinyUI

struct BarItem: View {

    let icon: String
    let title: String

    @Binding var isActive: Bool

    var body: some View {
        HStack {
            Image(icon)
                .frame(width: 20, height: 16)
                .margin {
                    vertical(10)
                    horizontal(8)
                }
            Text(title)
                .color(Color(0xFFFFFF, alpha: 0))
                .foregroundColor(Color(isActive ? 0xFFFFFF : 0x4C4C4C))
                .margin(right(25))
            Spacer()
        }
        .decorate {
            isActive ?
                color(Color(0x2B87FC)) :
                color(Color(0xFFFFFF, alpha: 0))
            cornerRadius(12)
        }
        .margin { horizontal(15) }
    }
}
