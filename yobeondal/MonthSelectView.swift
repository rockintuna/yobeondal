//
//  ContentView.swift
//  yobeondal
//
//  Created by 이정인 on 3/10/25.
//

import SwiftUI
import PopupView
import Combine

struct MonthSelectView: View {
    let numbers = Array(1...12)
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Environment(\.presentationMode) var presentationMode
    @StateObject var transactionViewModel = TransactionViewModel()
    @StateObject var memoViewModel = MemoViewModel()
    
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
                                transactionViewModel: transactionViewModel,
                                memoViewModel: memoViewModel)) {
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
    let buttonColor: Color = Color(red: 36/255, green: 36/255, blue: 36/255)
    @ObservedObject var transactionViewModel: TransactionViewModel
    @ObservedObject var memoViewModel: MemoViewModel
    @State private var inputTitle: String = "" // 입력할 제목
    @State private var tid: Int? = nil
    @State private var inputAmount: String = "" // 입력할 금액
    @State private var viewUpdateSheet: Bool = false
    @State private var viewLoadLastMonthPopup: Bool = false
    @State private var viewMemoPopup: Bool = false
    @State private var isExpenses: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedTitle: String = ""
    @State private var selectedAmount: Int?
    @State private var userId: Int = 1
    
    init(year: Int, month: Int, transactionViewModel: TransactionViewModel, memoViewModel: MemoViewModel) {
        self.year = year
        self.month = month
        self.transactionViewModel = transactionViewModel
        self.memoViewModel = memoViewModel
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
                viewLoadLastMonthPopup.toggle()
            } label: {
                Image(systemName: "arrow.trianglehead.clockwise.heart")
                    .resizable()
                    .foregroundColor(buttonColor)
                    .frame(width: 25, height: 25)
                    .padding(25)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .popup(isPresented: $viewLoadLastMonthPopup) {
                VStack {
                    Text("지난 달 데이터를 불러옵니다.")
                        .bold()
                        .padding(20)
                        .foregroundStyle(buttonColor)
                    Button {
                        print("test")
                    } label: {
                        Text("OK")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(buttonColor)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
            } customize: {
                $0
                    .position(.center)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            
            Spacer(minLength: 55)
            
            Button {
                viewMemoPopup.toggle()
            } label: {
                Image(systemName: "message")
                    .resizable()
                    .foregroundColor(buttonColor)
                    .frame(width: 25, height: 25)
                    .padding(25)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $viewMemoPopup) {
                MemoPopup(
                    year: year,
                    month: month,
                    memoViewModel: memoViewModel
                )
                .onAppear {
                    DispatchQueue.main.async {
                        memoViewModel.getMemos(year, month)
                        viewMemoPopup = true
                    }
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.4)])
            }
            .animation(.easeInOut(duration: 0.1), value: viewUpdateSheet)
            
            Spacer(minLength: 55)
            
            Button {
                tid = nil
                selectedTitle = ""
                selectedAmount = nil
                isExpenses = true
                userId = 1
                viewUpdateSheet.toggle()
            } label: {
                Image(systemName: "arrow.up.heart")
                    .resizable()
                    .foregroundColor(buttonColor)
                    .frame(width: 25, height: 25)
                    .padding(25)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $viewUpdateSheet) {
                TransactionEditPopup(
                    tid: $tid,
                    year: year,
                    month: month,
                    title: $selectedTitle,
                    amount: $selectedAmount,
                    isPresented: $viewUpdateSheet,
                    selectedUserId: $userId,
                    isExpenses: $isExpenses,
                    transactionViewModel: transactionViewModel
                )
                .onAppear {
                    DispatchQueue.main.async {
                        viewUpdateSheet = true
                    }
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.5)])
            }
            .animation(.easeInOut(duration: 0.1), value: viewUpdateSheet)
            
            Spacer()
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
                                viewUpdateSheet.toggle()
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
                                viewUpdateSheet.toggle()
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
                                viewUpdateSheet.toggle()
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
                                viewUpdateSheet.toggle()
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
            
            HStack {
                Button(action: sendTransactionInfo) {
//                    Text(tid == nil ? "추가하기" : "변경하기")
//                        .frame(width: 100, height: 25)
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .foregroundColor(Color.primary)
                        .frame(width: 30, height: 30)
                        .padding(20)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                if tid != nil {
                    Spacer()
                    Button(action: deleteTransaction) {
//                        Text("삭제하기")
//                        .frame(width: 100, height: 25)
//                        .background(Color.gray)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundColor(Color.gray)
                            .frame(width: 30, height: 30)
                            .padding(20)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
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

struct MemoPopup: View {
    let year: Int
    let month: Int
    @State private var content: String = ""
    @ObservedObject var memoViewModel: MemoViewModel = MemoViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    init(year: Int, month: Int, memoViewModel: MemoViewModel) {
        self.year = year
        self.month = month
        self.memoViewModel = memoViewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ScrollViewReader { proxy in
                List(memoViewModel.response) { memo in
                    Text(memo.content)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .listRowSeparator(.hidden)
                        .contextMenu{
                            Button(role: .destructive) {
                                deleteMemo(memo.id, year, month)
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                }
                .listStyle(PlainListStyle())
                .onAppear() {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: memoViewModel.response.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }
            
            Spacer()
            
            // 입력창
            HStack {
                TextField("메시지를 입력하세요...", text: $content)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)
                    .focused($isTextFieldFocused)
                
                Button(action: sendMemo) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 10)
            }
            .padding(.vertical, 10)
            .background(Color(.systemGray6)) // 입력창 배경
            .onTapGesture {
                isTextFieldFocused = true // 클릭 시 키보드 표시
            }
            .padding(.bottom, keyboardResponder.keyboardHeight) // ✅ 키보드 높이만큼
            .animation(.easeOut(duration: 0.3), value: keyboardResponder.keyboardHeight)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // 자동 스크롤 함수
    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let lastMessage = memoViewModel.response.last {
                withAnimation {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
    
    func sendMemo() {
        guard !content.isEmpty else { return }
        
        memoViewModel.createMemo(year, month, content, 1)
        
        content = ""
    }
    
    func deleteMemo(_ id: Int,_ year: Int,_ month: Int) {
        memoViewModel.deleteMemo(id, year, month)
    }
}

// ✅ 키보드 감지 클래스
class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        
        willShow.merge(with: willHide)
            .sink { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = notification.name == UIResponder.keyboardWillShowNotification ? keyboardFrame.height : 0
                }
            }
            .store(in: &cancellables)
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
