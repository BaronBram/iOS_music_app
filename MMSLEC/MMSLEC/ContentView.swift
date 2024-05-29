//
//  ContentView.swift
//  MMSLEC
//
//  Created by Baron Bram on 02/12/23.
//

import SwiftUI
import AVFoundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

let midnight = Color(0x191970)
struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    
   
    
    var audios: [Audio] = tesData
    @State private var  isLoggedIn = false
    @State private var  isRegisterActive = false
    @State private var showSplash = true
    
    var body: some View {
        ZStack{
           
            if showSplash{
                SplashScreen().onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                        withAnimation{showSplash = false}
                    }
                }
            }
            else{
                if isLoggedIn{
                    Color(0x191970).ignoresSafeArea(.all).overlay(
                        NavigationView{
                                                     //Color.red.edgesIgnoringSafeArea(.all)
                            List(audios){ audio in
                                    AudioCell(audio: audio)
                            }.navigationTitle("Audio Lists 🎶").edgesIgnoringSafeArea(.leading).accentColor(.white).foregroundColor(.white)
                        }.accentColor(.white)

                    )
                         
                       } else{
                           if isRegisterActive {
                                           // Display RegisterView if isRegisterActive is true
                                           RegisterView(isRegisterPageActive: $isRegisterActive)
                           } else{
                               LoginView(isLoggedIn: $isLoggedIn, isRegisterActive: $isRegisterActive)
                           }
                       }
            }
        }
       
    }
  

}
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView(audios: tesData)
            }
        }
    

struct AudioCell: View {
    
    let audio: Audio
    
    var body: some View {
                      // Color(0x191970)
                       let selectedAudio = Audio(title: audio.title, Singer: audio.Singer, audioTitle: audio.audioTitle)
                              
                              NavigationLink(destination: AudioDetail(selectedSong: [audio] ,expandSheet: .constant(true), animation: Namespace().wrappedValue, imageName: audio.imageName, songName: audio.title, singer: audio.Singer, audioTitle: audio.audioTitle)){
                                  
                                  HStack{
                                      Image(audio.imageName).resizable()
                                      
                                          .frame(width: 100, height: 100).padding().cornerRadius(100)
                                      VStack(alignment: .leading){
                                          Text(audio.title).font(.title).foregroundColor(.black)
                                          Text(audio.Singer).font(.subheadline).foregroundColor(Color.gray)
                                      }
                                  }.edgesIgnoringSafeArea(.all)
                                  
                              }
                   }
    }
struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding  var isRegisterActive: Bool

    var body: some View {
        NavigationView{
            ZStack{
               // Color.secondary.edgesIgnoringSafeArea(.all)
               
                Color(0x191970).edgesIgnoringSafeArea(.all)
                       
                       VStack {
                           Image("logo").resizable().frame().frame(width: 300, height: 200).edgesIgnoringSafeArea(.leading)
                           Text("Login").foregroundColor(.white).font(.system(size: 50, weight: .bold))
                                 TextField("Username", text: $username)
                                     .padding()
                                     .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 350, height: 30)
                                 
                                 SecureField("Password", text: $password)
                                     .padding()
                                     .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 350, height: 90)
                                   //  .padding(0)
                           
                           //Spacer()
                           Button(action: {
                               login(username: username, password: password)
                           }){
                               Text("Login").frame(width: 200, height: 30, alignment: .center)
                                
                                 }
                           .padding(10).background(Color.white).foregroundColor(midnight).cornerRadius(20)
                           .disabled(username.isEmpty || password.isEmpty)
                                 
                                 
                                 
                           Button(action: {
                               isRegisterActive = true
                           }){
                               Text("Don't have an account?").frame(width: 200, height: 30, alignment: .center).font(.system(size: 15, weight: .bold))
                                
                                 }
                                 .foregroundColor(.white)
                                                 .padding()
                                                
                                                 .cornerRadius(50)
                             }
                       .padding()
                   }
        }
       
    }
    func login(username: String, password: String){
        Auth.auth().signIn(withEmail: username, password: password) {
            result, error in
            if let error = error {
                       print("Error: \(error.localizedDescription)")
                     
                   } else if result != nil {
                       print("User logged in successfully!")
                      
                       isLoggedIn = true
                   }
        }
    }
}

struct RegisterView: View {
    @Binding var isRegisterPageActive: Bool
        @State private var username: String = ""
        @State private var password: String = ""
        @State private var registrationComplete = false // Flag to simulate registration completion

        var body: some View {
            NavigationView{
                ZStack{
                    Color(0x191970).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("logo").resizable().frame().frame(width: 300, height: 200).edgesIgnoringSafeArea(.leading)
                        Text("Register").foregroundColor(.white).font(.system(size: 50, weight: .bold))
                                  TextField("Username", text: $username)
                                      .padding()
                                      .textFieldStyle(RoundedBorderTextFieldStyle())

                                  SecureField("Password", text: $password)
                                      .padding()
                                      .textFieldStyle(RoundedBorderTextFieldStyle())
                                  
                                  if registrationComplete {
                                      Text("Registration Successful!")
                                          .padding().font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                                      
                                      Button(action: {
                                          isRegisterPageActive = false
                                      }){
                                          Text("Go to login").frame(width: 200, height: 30, alignment: .center).font(.system(size: 20, weight: .bold))// Dismiss RegisterView
                                      }
                                      .foregroundColor(.white)
                                                      .padding()
                                  } else {
                                      Button(action: {
                                          
                                          register(username: username, password: password)
                                          saveToFirestore()
                                         
                                          if !username.isEmpty && !password.isEmpty {
                                              
                                              registrationComplete = true
                                          }
                                          
                                      })
                                      {
                                        Text("Register").frame(width: 100, height: 30, alignment: .center)
                                          }
                                      .padding(10)
                                      .background(Color.white)
                                      .foregroundColor(midnight)
                                      .cornerRadius(20)
                                      .disabled(username.isEmpty || password.isEmpty) // Disable button if fields are empty
                                  }
                              }
                              .padding()
                }
            }
        }
    
    func register(username: String, password: String){
        if isValidEmail(email: username) && password.count > 5{
            Auth.auth().createUser(withEmail: username, password: password) {result, error in
                       if error != nil {
                           print(error!.localizedDescription)
                       }
                   }
                   isRegisterPageActive = true
        }
       
    }
   
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func saveToFirestore() {
        let db = Firestore.firestore()
        
        // Add data to Firestore
        db.collection("users").addDocument(data: [
            "email": username,
            "password": password
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                // Optionally, clear text fields after saving
                username = ""
                password = ""
            }
        }
    }
    
}

extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

struct SplashScreen: View {
    var body: some View {
        ZStack{
            Color(0x191970).edgesIgnoringSafeArea(.all)
            Image("logo").resizable().aspectRatio(contentMode: .fit).edgesIgnoringSafeArea(.all)
        }
    }
}


