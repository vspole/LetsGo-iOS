//
//  PhoneLoginView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/6/22.
//

import SwiftUI

struct PhoneLoginView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {

        VStack() {
            Image("MainLogo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .padding(.horizontal, 100)
                .colorInvert()
            
            Spacer()

            ZStack() {
                RoundedRectangle(cornerRadius: 10).stroke(.red)
                
                TextField("", text: $viewModel.phoneNumber)
                    .scaledFont(type: .quickSandSemiBold, size: 20, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, SIZE_PADDING_XS)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .onTapGesture {
                        viewModel.isEditing = true
                    }
                    .onSubmit {
                        viewModel.isEditing = false
                    }
                
                
                if viewModel.phoneNumber.isEmpty && !viewModel.isEditing {
                    Text("Phone Number: ")
                        .scaledFont(type: .quickSandSemiBold, size: 20, color: .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, SIZE_PADDING_XS)
                }
            }
            .frame(height: 50)
            .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)

            
            Spacer()
            Spacer()
            
            Button {
                viewModel.dismissKeyboard()
                viewModel.mainViewModel.isUserLoggedIn = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(viewModel.isButtonDisabled ? .gray : .red)
                    Text("Request Code")
                        .scaledFont(type: .quickSandSemiBold, size: 17, color: .white)
                }
            }
            .frame(height: 50)
            .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)
            .disabled(viewModel.isButtonDisabled)
            
            Spacer()
        }
        .background(.black)
        .onTapGesture {
            viewModel.isEditing = false
            viewModel.dismissKeyboard()
        }
        //.padding(.all, MARGIN_SCREEN)
        //.frame(maxWidth: .infinity)
    }
    
}

extension PhoneLoginView {
    class ViewModel: ObservableObject {
        @Published var phoneNumber = ""
        @Published var shouldGoHome = false
        @Published var isEditing = false
        
        var isButtonDisabled: Bool {
            phoneNumber.isEmpty
        }
        
        var container: DependencyContainer
        var mainViewModel: MainView.ViewModel
        
        init(container: DependencyContainer, mainViewModel: MainView.ViewModel) {
            self.container = container
            self.mainViewModel = mainViewModel
        }
        
        func dismissKeyboard() {
            UIApplication.shared.endEditing()
        }
    }
}


