//
//  TitleBar.swift
//  BasicComponents
//
//  Created by Angel Landoni on 30/1/21.
//

import ShinyUI

struct TitleBar: View {

    let title: String

    var body: some View {
        HStack {
            Image("SideBarIcon")
                .frame(width: 22, height: 16)
                .margin { right(10) }
            Text(title)
                .color(Color(0xFFFFFF))
                .foregroundColor(Color(0x15171B))
            Spacer()
        }
        .margin {
            left(25)
        }
        .center(.vertical)
        .frame(height: 55)
        .decorate {
            color(Color(0xFFFFFF))
            borderColor(Color(0xD0D0D0))
            borderWidth(1)
        }
    }
}
