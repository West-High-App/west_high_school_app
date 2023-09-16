//
//  SplashScreenView.swift
//  West High App
//
//  Created by Aiden Lee on 8/29/23.
//

import SwiftUI

struct SplashScreenView: View {
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State var isShutDown = false
    @State var shutdownMessage = ""
    @State var shutdownmanager = ShutdownManager()
    @EnvironmentObject var userInfo: UserInfo

    
    init() {
        shutdownmanager.fetchData { [self] bool, string in
            
            shutdownmanager.isShutDown = bool
            shutdownmanager.shutdownMessage = string
            print("FROM INIT")
            print(shutdownmanager.isShutDown)
            print(shutdownmanager.shutdownMessage)
            
        }
    }
    
    var body: some View {
        
        ZStack {
            AuthView()
                .environmentObject(userInfo)
            
            if !isActive {
                ZStack{
                    westblue
                    VStack{
                        ZStack{
                            Image("Regents Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:200)
                                .padding(30)
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear{
                            withAnimation(.easeIn(duration: 2.0)){
                                self.size = 0.9
                                self.opacity = 1.0
                            }
                        }
                    }
                    .onAppear{
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.linear(duration: 0.5)) {
                            self.opacity = 0.0
                        }
                    }
                }
                
                .ignoresSafeArea()
                
                
            }
        }
        
    }
}

class Loading: ObservableObject {
    
    @Published var hasLoaded = false
    
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
