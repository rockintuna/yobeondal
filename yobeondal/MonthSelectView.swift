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
    @Environment(\.presentationMode) var presentationMode
    @StateObject var transactionViewModel = TransactionViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(formatYear(thisYear()))년")
                    .font(.title)
                    .foregroundColor(Color(red: 243/255, green: 212/255, blue:224/255))

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(numbers, id: \.self) { number in
                        NavigationLink(destination: SelectedMonthView(
                                year: thisYear(),
                                month: number,
                                transactionViewModel: transactionViewModel)) {
                            Text("\(number)")
                                .font(.title)
                                .frame(width: 80, height: 80)
                                .background(Color.white)
                                .foregroundColor(Color(red: 243/255, green: 212/255, blue:224/255))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
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
    @ObservedObject var transactionViewModel: TransactionViewModel
    @State private var inputTitle: String = "" // 입력할 제목
    @State private var tid: Int? = nil
    @State private var inputAmount: String = "" // 입력할 금액
    @State private var isPresented: Bool = false
    @State private var isExpenses: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedTitle: String = ""
    @State private var selectedAmount: Int?
    @State private var userId: Int = 1
    
    init(year: Int, month: Int, transactionViewModel: TransactionViewModel) {
        self.year = year
        self.month = month
        self.transactionViewModel = transactionViewModel
    }
    
    var backButton : some View {  // <-- 👀 커스텀 버튼
        Button{
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left") // 화살표 Image
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.black)
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                tid = nil
                selectedTitle = ""
                selectedAmount = nil
                isExpenses = true
                userId = 1
                isPresented.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(Color.black)
                    .frame(width: 30, height: 30)
                    .padding(20)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $isPresented) {
                TransactionEditPopup(
                    tid: $tid,
                    year: year,
                    month: month,
                    title: $selectedTitle,
                    amount: $selectedAmount,
                    isPresented: $isPresented,
                    selectedUserId: $userId,
                    isExpenses: $isExpenses,
                    transactionViewModel: transactionViewModel
                )
                .onAppear {
                    DispatchQueue.main.async {
                        isPresented = true
                    }
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.5)])
            }
            .animation(.easeInOut(duration: 0.1), value: isPresented)
        }

        HStack {
            VStack {
                List(getTransactions(1)) { transaction in
                    HStack {
                        if transaction.amount >= 0 {
                            Button {
                                tid = transaction.id
                                selectedTitle = transaction.title
                                selectedAmount = abs(transaction.amount)
                                userId = 1
                                isExpenses = false
                                isPresented.toggle()
                            } label: {
                                Text(transaction.title)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 13))
                            }
                            
                            Spacer()
                            
                            Text("\(abs(transaction.amount))")
                                .font(.system(size: 13))
                        } else {
                            Button {
                                tid = transaction.id
                                selectedTitle = transaction.title
                                selectedAmount = abs(transaction.amount)
                                userId = 1
                                isExpenses = true
                                isPresented.toggle()
                            } label: {
                                Text("🩷 " + transaction.title)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 13))
                            }
                            
                            Spacer()
                            
                            Text("\(abs(transaction.amount))")
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
                            Button {
                                tid = transaction.id
                                selectedTitle = transaction.title
                                selectedAmount = abs(transaction.amount)
                                userId = 2
                                isExpenses = false
                                isPresented.toggle()
                            } label: {
                                Text(transaction.title)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 13))
                                    .padding(.leading, -10)
                            }
                            
                            Spacer()
                            
                            Text("\(abs(transaction.amount))")
                                .font(.system(size: 13))
                        } else {
                            Button {
                                tid = transaction.id
                                selectedTitle = transaction.title
                                selectedAmount = abs(transaction.amount)
                                userId = 2
                                isExpenses = true
                                isPresented.toggle()
                            } label: {
                                Text("🩷 " + transaction.title)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 13))
                                    .padding(.leading, -10)
                            }
                            
                            Spacer()
                            
                            Text("\(abs(transaction.amount))")
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
                    
                    Text("\(getSumOfExpenses(2))")
                        .font(.system(size: 13))
                }
                .frame(width: 160, height: 10)
                HStack {
                    Text("비상금")
                        .font(.system(size: 13))
                    
                    Spacer().background(Color.red)
                    
                    Text("\(getSumOfTransactions(2))")
                        .font(.system(size: 13))
                }
                .frame(width: 160, height: 30)
                .padding(.bottom, 30)
            }
        }
        .padding(.top, -30)
        .onAppear {
            transactionViewModel.getTransactions(year, month)
        }
        .navigationTitle(formatYear(year) + "년 \(month)월")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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
}

struct TransactionEditPopup: View {
    @Binding var tid: Int?
    let year: Int
    let month: Int
    @Binding var title: String
    @Binding var amount: Int?
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isAmountFocused: Bool
    @Binding var isPresented: Bool
    @Binding var selectedUserId: Int
    @Binding var isExpenses: Bool
    @ObservedObject var transactionViewModel: TransactionViewModel
    
    var body: some View {
        VStack {
            Picker("사용자 선택", selection: $selectedUserId) {
                            Text("수진").tag(1)
                            Text("정인").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
            
            Picker("수입/지출", selection: $isExpenses) {
                            Text("수입").tag(false)
                            Text("지출").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
            
            TextField("제목 입력", text: $title)
                .focused($isTitleFocused)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            TextField("금액 입력", value: $amount, formatter: NumberFormatter())
                .focused($isAmountFocused)
                .keyboardType(.numberPad)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button(action: sendTransactionInfo) {
                Text(tid == nil ? "추가하기" : "변경하기")
                    .frame(width: 100, height: 25)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            
            if tid != nil {
                Button(action: deleteTransaction) {
                    Text("삭제하기")
                    .frame(width: 100, height: 25)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 250, height: 300)
        .background(Color.white)
        .cornerRadius(20)
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                isTitleFocused = true // 자동으로 첫 번째 TextField에 포커스를 줌
//            }
//            DispatchQueue.main.async {
//                isTitleFocused = true
//            }
        }
    }
    
    func sendTransactionInfo() {
        var integer: Int
        if isExpenses {
            integer = -amount!
        } else {
            integer = amount!
        }
        transactionViewModel.upsertTransactions(tid, year, month, title, integer, selectedUserId)
        isPresented = false
    }
    
    func deleteTransaction() {
        transactionViewModel.deleteTransactions(tid!, year, month)
        isPresented = false
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
