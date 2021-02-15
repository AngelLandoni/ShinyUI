//  Copyright (c) 2021 Angel Landoni.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIEDi
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Dispatch
import ShinyUI

struct Counter: View {
    
    @Binding var counter: Int
    
    var body: some View {
        Text("Mobile App ShinyUI \(counter)")
            .font("", 20)
            .color(Color(0xFFFFFF, alpha: 0x00))
            .foregroundColor(Color(0xFFFFFFF))
    }
}

struct App: View {
    
    @State var counter: Int = 0
    
    var body: some View {
        Navigation {
            VStack {
                Counter(counter: $counter)
                    .center()
                    .fractionallyFrame(width: 50)
                    .frame(height: 90)
                    .decorate {
                        cornerRadius(15)
                        color(Color(0x3D7FFF))
                    }
                    .onTap {
                        counter += 1
                    }
                
                Text("Move to other section")
                    .color(Color(0xFFFFFF, alpha: 0x00))
                    .foregroundColor(Color(0xDDDDDD))
                    .margin(all(10))
                    .decorate {
                        cornerRadius(15)
                        color(Color(0x3D7FFF))
                    }
                    .margin(top(20))
                    .onTap {
                        //context.push(App())
                    }
            } .center()
        }
    }
}
