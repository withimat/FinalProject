//
//  Lottie.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 29.04.2025.
//

import Foundation
import Lottie

func createLottieAnimationView(from urlString: String, width: CGFloat, height: CGFloat) -> LottieAnimationView {
    let animationView = LottieAnimationView()
    
    guard let url = URL(string: urlString) else {
        print("Hatalı URL")
        return animationView
    }

    LottieAnimation.loadedFrom(url: url, closure: { animation in
        if let animation = animation {
            animationView.animation = animation
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            animationView.play()
        } else {
            print(" Animasyon yüklenemedi.")
        }
    }, animationCache: nil)
    
    animationView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    // deneme
    return animationView
}
