//
//  ContentView.swift
//  yobeondal
//
//  Created by 이정인 on 3/10/25.
//

import SwiftUI

struct MonthSelectView: View {
    let numbers = Array(1...12)
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(formatYear(thisYear()))년")
                    .font(.title)
                    .foregroundColor(Color(red: 243/255, green: 212/255, blue:224/255))

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(numbers, id: \.self) { number in
                        NavigationLink(destination: SelectedMonthView(year: thisYear(), month: number)) {
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
    }
}

// 선택된 숫자 화면
struct SelectedMonthView: View {
    let year: Int
    let month: Int
    @StateObject var transactionViewModel: TransactionViewModel = TransactionViewModel()
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    var body: some View {
        VStack {
            Text("\(formatYear(year))년 \(month)월")
                .font(.title)
                .foregroundColor(.blue)
            
            if transactionViewModel.transactions.isEmpty {
                Text("데이터를 불러오는 중...")
            } else {
                ForEach(getTransaction()) { transaction in
                    Text(transaction.title + " \(transaction.amount)            " + transaction.title + " \(transaction.amount)")
                }
            }
        }
        .onAppear {
            transactionViewModel.getTransactions(year, month)
        }
        .navigationTitle("\(month)월 선택됨")
        .navigationBarTitleDisplayMode(.inline)
    
    }
    
    func getTransaction() -> [Transaction] {
        self.transactionViewModel.transactions
    }
}

// 현재 연도 반환 함수
func thisYear() -> Int {
    let today = Date()
    let calendar = Calendar.current
    return calendar.component(.year, from: today)
}

func formatYear(_ year: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none // 쉼표 제거
    return formatter.string(from: NSNumber(value: year)) ?? "\(year)"
}

struct MonthSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MonthSelectView()
    }
}
