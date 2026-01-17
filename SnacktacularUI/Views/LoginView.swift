//
//  LoginView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 16/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
            Group {
                TextField("email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                SecureField("password", text: $password)
                    .submitLabel(.done)
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            
            HStack {
                Button("Sign Up") {
                    register()
                }
                .padding(.trailing)
                Button("Login") {
                    login()
                }
                .padding(.leading)
            }
            .buttonStyle(.borderedProminent)
            .tint(.snackColour)
            .font(.title2)
            .padding(.top)
            
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 SIGNUP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGNUP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration success!")
                // TODO: Load ListView
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login success!")
                // TODO: Load ListView
            }
        }
    }
}

#Preview {
    LoginView()
}
