//
//  SplashScreenView.swift
//  Sako
//
//  Created by Ammar Sufyan on 26/03/25.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @State private var isActive = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity = 0.0
    @State private var rotation: Double = 0.0

    var body: some View {
        Group {
            if isActive || hasLaunchedBefore {
                HomeView()
            } else {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 12) {
                        // Animated Coin Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.orange]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .frame(width: 100, height: 100)
                                .shadow(radius: 10)
                                .scaleEffect(scale)
                                .rotationEffect(.degrees(rotation))

                            Text("S")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .scaleEffect(scale)
                        }

                        // App Name
                        Text("Sako")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black)
                            .opacity(opacity)
                            .offset(y: isActive ? 0 : 20)
                            .animation(.easeOut(duration: 1.0), value: opacity)

                        // Tagline
                        Text("Sistem Kantin Offline")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .opacity(opacity)
                            .offset(y: isActive ? 0 : 20)
                            .animation(.easeOut(duration: 1.0), value: opacity)
                    }
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scale = 1.0
                        opacity = 1.0
                        rotation = 360.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            hasLaunchedBefore = true
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .modelContainer(for: Item.self, inMemory: true)
}
