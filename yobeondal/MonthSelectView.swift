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
        HStack {
            List(getTransactionsForSJ()) { transaction in
                HStack {
                    if transaction.amount >= 0 {
                        Text(transaction.userName)
                            .font(.system(size: 13))
                        Spacer()
                        Text("\(transaction.amount)")
                            .font(.system(size: 13))
                    } else {
                        Text("🩷 " + transaction.title)
                            .font(.system(size: 13))
                        Spacer()
                        Text("\(transaction.amount)")
                            .font(.system(size: 13))
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            
            Divider()
                .background(Color.black)
                .frame(maxHeight: .infinity)
                .padding(.vertical, 40)
                .padding(.trailing, 0)
            
            List(getTransactionsForJI()) { transaction in
                HStack {
                    if transaction.amount >= 0 {
                        Text(transaction.userName)
                            .font(.system(size: 13))
                        Spacer()
                        Text("\(transaction.amount)")
                            .font(.system(size: 13))
                    } else {
                        Text("🩷 " + transaction.title)
                            .font(.system(size: 13))
                        Spacer()
                        Text("\(transaction.amount)")
                            .font(.system(size: 13))
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            transactionViewModel.getTransactions(year, month)
        }
        .navigationTitle(formatYear(year) + "년 \(month)월")
        .navigationBarTitleDisplayMode(.inline)
    
    }
    
    func getTransactionsForSJ() -> [Transaction] {
        self.transactionViewModel.transactionsForSJ
    }
    func getTransactionsForJI() -> [Transaction] {
        self.transactionViewModel.transactionsForJI
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
