//
//  ContentView.swift
//  SwiftUIToDoApp
//
//  Created by Takafumi Watanabe on 2021-12-07.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}

struct LoginView: View {
    
    @State var isLoginMode = false
    
    @State var email: String = ""
    @State var password: String = ""

    init() {
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 12) {
                    Picker(selection: $isLoginMode, label: Text("Picker here  ")) {
                        Text("Login")
                            .tag(true)
                        
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        
                        Button {
                            
                        } label: {
                            
                            Image("LoginImage")
                                .font(.system(size: 50))
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                        
                    }
                    .padding(12)
                    .background(Color.white)

                    Button {
                        handleAction()
                        
                    } label: {
                        HStack {
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .font(.system(size: 14, weight: .semibold))
                        }.background(Color.blue)
                    }
                    
                    Text(self.loginStatusMessge)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha:  0.05)) .ignoresSafeArea())

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAction() {
        if isLoginMode {
//            print("Should log into Firebase with existing credentials")
            loginUser()
        } else {
            createNewAccount()
//            print("Register a ner account")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
        result, err in
        if let err = err {
            print("Failed to create user", err)
            self.loginStatusMessge = "Failed to create user: \(err)"
            return
        }
        
        print("Successfully logged in as user: \(result?.user.uid ?? "")")
        self.loginStatusMessge = "Successfully logged in as user: \(result?.user.uid ?? "")"
    }
}
    
    @State var loginStatusMessge = ""
    
    private func createNewAccount() {

        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user", err)
                self.loginStatusMessge = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
