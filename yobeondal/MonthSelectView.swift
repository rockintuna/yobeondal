//
//  ContentView.swift
//  yobeondal
//
//  Created by 이정인 on 3/10/25.
//

import SwiftUI
import Foundation

struct MonthSelectView: View {
    let numbers = Array(1...12)
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var selectedNumber: Int? // 선택된 숫자 저장

    var body: some View {
        selectedNumber == nil ? AnyView(monthGridView()) : AnyView(selectedMonthView())
    }

    // 숫자 선택 화면
    func monthGridView() -> some View {
        VStack {
            Text("\(thisYear())년")
                .font(.title)
                .foregroundColor(Color(red: 243/255, green: 212/255, blue:224/255))
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(numbers, id: \.self) { number in
                    Button(action: {
                        selectedNumber = number
                    }) {
                        Text("\(number)")
                            .font(.title)
                            .frame(width: 80, height: 80)
                            .background(Color.white)
                            .foregroundColor(Color(red: 243/255, green: 212/255, blue:224/255))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
        }
    }

    // 선택된 숫자 화면
    func selectedMonthView() -> some View {
        VStack {
            Text("\(thisYear())년 \(selectedNumber!)월")
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}


func thisYear() -> String {
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"

    return formatter.string(from: today)
}

struct MonthSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MonthSelectView()
    }
}
