//
//  QrScannerView.swift
//  ResicloApp
//
//  Created by Diego Esparza on 13/11/24.
//

import SwiftUI
import UIKit

struct QRScannerView: UIViewControllerRepresentable {
    var didFindCode: (String) -> Void
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> QRScannerViewController {
        let scannerVC = QRScannerViewController()
        scannerVC.delegate = context.coordinator
        return scannerVC
    }
    
    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, QRScannerDelegate {
        let parent: QRScannerView
        
        init(parent: QRScannerView) {
            self.parent = parent
        }
        
        func didDetectCode(_ code: String) {
            parent.didFindCode(code)
        }
        
        func didDismissScanner() {
            parent.isPresented = false
        }
    }
}
