//
//  ProfileView.swift
//  DCARB
//
//  Created by Alexander Nanda on 10/14/23.
//

import Foundation
import SwiftUI
import Firebase

struct ProfileView: View {
    @StateObject private var userManager = UserManager()
    @State private var isShowingResetPasswordAlert = false
    
    var body: some View {
        VStack {
            
                    Spacer().frame(height:25)
            var greeting: String {
                let hour = Calendar.current.component(.hour, from: Date())

                if (6..<12).contains(hour) {
                    return "Good Morning"
                } else if (12..<18).contains(hour) {
                    return "Good Afternoon"
                } else {
                    return "Good Evening"
                }
            }
            HStack{
            Text(greeting + ", \(userManager.user?.displayName ?? "")")
                         .fontWeight(.black)
                         .foregroundColor(Color(hex: "7D5E35"))
                    }
                        .font(.title)
                        .padding()
                        .background(Color(hex: "D1AD7D"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(10)
            
            
            HStack{
                Text("Email: ")
                .font(.title)
                        .padding()
                 .fontWeight(.black)
                         .foregroundColor(Color(hex: "7D5E35"))
                Text("\(userManager.user?.email ?? "")")
                    .font(.caption)//shirnk
                        .padding()
                
            }
            .padding()
                        .background(Color(hex: "D1AD7D"))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .cornerRadius(10)
           
            HStack{
                Text("House: ")
                .font(.title)
                        .padding()
                 .fontWeight(.black)
                         .foregroundColor(Color(hex: "7D5E35"))
                Text(" North Park")
                        .padding()
                
            }
            .padding()
                        .background(Color(hex: "D1AD7D"))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .cornerRadius(10)

            
            Button(action: {
                isShowingResetPasswordAlert = true
            }) {
                Text("Reset Password").font(.title)
                        .padding()
                        .background(Color(hex: "D1AD7D"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding( 10)
                                }
            .alert(isPresented: $isShowingResetPasswordAlert) {
                Alert(
                    title: Text("Reset Password"),
                    message: Text("Are you sure you want to reset your password? An email will be sent to you shortly."),
                    primaryButton: .default(Text("Reset"), action: resetPassword),
                    secondaryButton: .cancel()
                )
            }

            Button(action: logout) {
                Text("Logout").font(.title)
                        .padding()
                        .background(Color(hex: "D1AD7D"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 10)
                                }

            Spacer()
        }
        .navigationBarTitle("Profile")
        .onAppear {
            userManager.fetchUser()
        }
    }

    func resetPassword() {
        if let email = userManager.user?.email {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Error resetting password: \(error.localizedDescription)")
                } else {
                    print("Password reset email sent successfully")
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            clearStoredCredentials()
            exit(0)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func clearStoredCredentials() {
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        UserDefaults.standard.removeObject(forKey: "savedPassword")
    }

}

class UserManager: ObservableObject {
    @Published var user: User?

    func fetchUser() {
        user = Auth.auth().currentUser
    }
}
