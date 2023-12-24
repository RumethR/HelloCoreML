//
//  ContentView.swift
//  HelloCoreML
//
//  Created by Tihara Jayawickrama on 2023-12-24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel : MLDitector = MLDitector()
    @State var showPicker: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .padding()
                    .frame(height: 300)
                
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }.onTapGesture {
                showPicker = true
            }
            
            if let generatedImage = viewModel.modifiedImage{
                Image(uiImage: generatedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            Button(action: {
                viewModel.runMLPipeline()
            }, label: {
                Text("Button")
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 300)
                    )
            })
            
            Text(viewModel.identifier).font(.system(size: 32))
        }.sheet(isPresented: $showPicker, content: {
            PickerUIViewController(pickedImage: $viewModel.selectedImage)
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
