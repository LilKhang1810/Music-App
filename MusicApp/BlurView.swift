//
//  BlurView.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 18/03/2024.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

