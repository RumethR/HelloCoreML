//
//  VideoMLView.swift
//  HelloCoreML
//
//  Created by Tihara Jayawickrama on 2023-12-24.
//

import SwiftUI

struct VideoMLView: View {
    @State var gesture : String = ""
    var body: some View {
        VStack{
            //VideoView(identifier: $gesture)
            Text("Number \(gesture)").font(.system(size: 32))
        }
    }
}

#Preview {
    VideoMLView()
}
