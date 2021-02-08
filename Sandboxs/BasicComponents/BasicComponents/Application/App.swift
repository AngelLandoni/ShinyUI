//
//  App.swift
//  BasicComponents
//
//  Created by Angel Landoni on 28/12/20.
//

import ShinyUI

struct App: View {

    @State var isHomeActive: Bool = true
    @State var isNotificationsActive: Bool = false
    @State var isSettingsActive: Bool = false

    var body: some View {
        ControlBar(
            BarItem(icon: "􀎞", title: "Home", isActive: $isHomeActive),
            BarItem(icon: "􀌤", title: "Notifications", isActive: $isNotificationsActive),
            BarItem(icon: "􀍟", title: "Settings", isActive: $isSettingsActive),

            Home(),
            Notifications(),
            Settings()
        )
        .decorate {
            color(Color(0xF6F6F6))
        }
    }
}
