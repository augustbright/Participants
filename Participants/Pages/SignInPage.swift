//
//  SignInPage.swift
//  Participants
//
//  Created by Валерий Бубенщиков on 28.12.2022.
//

import SwiftUI
import Firebase

struct SignInPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var activeTab: String = "signIn"
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    
    @Binding var isPresented: Bool
    
    var body: some View {
        TabView(selection: $activeTab) {
            Form {
                Section(header: Text("By email")) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Enter your email and password")
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    HStack {
                        
                        if isLoading {
                            ProgressView()
                                .frame(height: 34)
                        } else {
                            Button("Sign In") {
                                login()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Spacer()
                        Button("forgot your password?") {
                            withAnimation {
                                
                                activeTab = "forgot"
                            }
                        }
                            .buttonStyle(.borderless)
                    }
                    .padding(.vertical)
                }
            }.tag("signIn")
            Form {
                Section(header: Text("Password recovery")) {
                    Text("Enter your email and we will send you a link to recover your password")
                    TextField("Your email", text: $email)
                    HStack {
                        Button("Send me email") {
                            withAnimation {
                                activeTab = "recoveryDone"
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical)
                }
            }.tag("forgot")
            Form {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Check your email")
                        .font(.title)
                    Text("Whe have sent you a link to restore your password")
                }
                HStack {
                    Button("Done") {
                        activeTab = "signIn"
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.vertical)
            }.tag("recoveryDone")
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .scrollDisabled(true)

    }
    
    func login() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in
            isLoading = false;
            guard error == nil else {
                errorMessage = error?.localizedDescription
                return
            }
            errorMessage = nil
            isPresented = false
        }
    }
}

struct SignInPage_Previews: PreviewProvider {
    static var previews: some View {
        SignInPage(isPresented: .constant(true))
    }
}