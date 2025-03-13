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
    
    @State private var inputTitle: String = "" // 입력할 제목
    @State private var inputAmount: String = "" // 입력할 금액
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    var body: some View {
        HStack {
            VStack {
                List(getTransactions(1)) { transaction in
                    HStack {
                        if transaction.amount >= 0 {
                            Text(transaction.title)
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
                .background(Color.red)
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                
                HStack {
                    TextField("항목 이름", text: $inputTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)
                    
                    TextField("금액", text: $inputAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                        .keyboardType(.numberPad) // 숫자 키보드
                }
                .padding()
                
                HStack {
                    Text("Total")
                        .font(.system(size: 13))
                    Spacer()
                        .background(Color.red)
                    Text("\(getSumOfExpenses(1))")
                        .font(.system(size: 13))
                }
                .frame(width: 160, height: 10)
                HStack {
                    Text("비상금")
                        .font(.system(size: 13))
                    Spacer()
                        .background(Color.red)
                    Text("\(getSumOfTransactions(1))")
                        .font(.system(size: 13))
                }
                .frame(width: 160, height: 30)
                .padding(.bottom, 30)
            }
            
            Divider()
                .background(Color.black)
                .frame(maxHeight: .infinity)
                .padding(.vertical, 40)
                .padding(.trailing, 0)
            
            VStack {
                List(getTransactions(2)) { transaction in
                    HStack {
                        if transaction.amount >= 0 {
                            Text(transaction.title)
                                .font(.system(size: 13))
                                .padding(.leading, -10)
                            Spacer()
                            Text("\(transaction.amount)")
                                .font(.system(size: 13))
                        } else {
                            Text("🩷 " + transaction.title)
                                .font(.system(size: 13))
                                .padding(.leading, -10)
                            Spacer()
                            Text("\(transaction.amount)")
                                .font(.system(size: 13))
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                
                HStack {
                    Text("Total")
                        .font(.system(size: 13))
                    Spacer()
                        .background(Color.red)
                    Text("\(getSumOfExpenses(2))")
                        .font(.system(size: 13))
                }
                .frame(width: 160, height: 10)
                HStack {
                    Text("비상금")
                        .font(.system(size: 13))
                    Spacer()
                        .background(Color.red)
                    Text("\(getSumOfTransactions(2))")
                        .font(.system(size: 13))
                }
                .frame(width: 160, height: 30)
                .padding(.bottom, 30)
            }
        }
        
        .onAppear {
            transactionViewModel.getTransactions(year, month)
        }
        .navigationTitle(formatYear(year) + "년 \(month)월")
        .navigationBarTitleDisplayMode(.inline)
    
    }
    
    func getTransactions(_ userId: Int) -> [Transaction] {
        if userId == 1 {
            return self.transactionViewModel.transactionsForSJ
        } else {
            return self.transactionViewModel.transactionsForJI
        }
    }
    
    func getSumOfTransactions(_ userId: Int) -> Int {
        if userId == 1 {
            return self.transactionViewModel.transactionsForSJ
                .map { $0.amount }  // 모든 amount 값 가져오기
                .reduce(0, +)       // 합산
        } else {
            return self.transactionViewModel.transactionsForJI
                .map { $0.amount }  // 모든 amount 값 가져오기
                .reduce(0, +)       // 합산
        }
    }
    
    func getSumOfExpenses(_ userId: Int) -> Int {
        if userId == 1 {
            return self.transactionViewModel.transactionsForSJ
                .filter { $0.amount < 0 }  // 음수인 값만 필터링
                .map { abs($0.amount) }    // 절대값 변환
                .reduce(0, +)              // 합산
        } else {
            return self.transactionViewModel.transactionsForJI
                .filter { $0.amount < 0 }  // 음수인 값만 필터링
                .map { abs($0.amount) }    // 절대값 변환
                .reduce(0, +)              // 합산
        }
    }
    
    func addTransaction() {
            guard let amount = Int(inputAmount), !inputTitle.isEmpty else { return }
            
//            let newTransaction = Transaction(title: inputTitle, amount: amount)
//            transactionViewModel.transactionsForSJ.append(newTransaction) // 리스트에 추가
            
            // 입력 필드 초기화
            inputTitle = ""
            inputAmount = ""
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
