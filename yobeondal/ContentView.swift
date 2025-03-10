//
//  ContentView.swift
//  yobeondal
//
//  Created by 이정인 on 3/10/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Image("요번달")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(60)
        }
        .padding()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
