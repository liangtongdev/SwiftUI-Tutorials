//
//  PageControl.swift
//  8 Interfacing with UIKit
//
//  Created by liangtong on 2019/10/15.
//  Copyright © 2019 COM.LIANGTONG. All rights reserved.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    
    
    
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
       return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        
        control.pageIndicatorTintColor = .gray;
        control.currentPageIndicatorTintColor = .white;
        
        control.addTarget(
        context.coordinator,
        action: #selector(Coordinator.updateCurrentPage(sender:)),
        for: .valueChanged)
        
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    
    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
    
}
