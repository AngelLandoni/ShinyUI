//
//  Home.swift
//  BasicComponents
//
//  Created by Angel Landoni on 30/1/21.
//

import ShinyUI
import Dispatch

struct Home: View {

    @State var counter: Int = 0

    init() {
        config()
    }

    var body: some View {
        VStack {
            TitleBar(title: "Home")
            Spacer()
            HStack {
                Text("Counter: ")
                Text("\(counter)")
            }
            .decorate {
                color(Color(0xFF00FF))
                cornerRadius(10)
                shadow {
                    offset(x: 0, y: 3)
                    color(Color(0xC6C6C6))
                    radius(20)
                }
            }
            .center()
            Spacer()
        }
    }

    func config() {
        DispatchQueue.global().async {
            while true {
                sleep(3)
                DispatchQueue.main.async {
                    counter += 1
                }
            }
        }
    }
}
