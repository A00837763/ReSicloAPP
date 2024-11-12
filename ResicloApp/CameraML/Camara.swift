import UIKit
import SwiftUI
import AVFoundation
import Vision
import CoreML
import SwiftEntryKit

// Este es el contenedor de SwiftUI para CameraMLViewController
struct CameraView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CameraMLViewController {
        return CameraMLViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraMLViewController, context: Context) {
        // No necesitamos actualizar nada en tiempo real en este caso
    }
}


class CameraMLViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let model: VNCoreMLModel = {
        do {
            let config = MLModelConfiguration()
            let mlModel = try CatDog(configuration: config).model
            return try VNCoreMLModel(for: mlModel)
        } catch {
            fatalError("Error al cargar el modelo de ML: \(error)")
        }
    }()
    private var lastDetectionTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPreview()
    }

    private func setupCameraPreview() {
        // Configuración de la sesión de captura
        captureSession.sessionPreset = .photo

        // Verifica que haya una cámara disponible
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("No se encontró una cámara disponible.")
            return
        }

        do {
            // Configuración de entrada de la cámara
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch {
            print("Error al configurar la entrada de la cámara: \(error)")
            return
        }

        // Asegúrate de que todas las configuraciones de UI estén en el hilo principal
        DispatchQueue.main.async {
            // Configuración de la capa de vista previa
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer.frame = self.view.bounds
            self.view.layer.addSublayer(self.previewLayer)

            // Iniciar la sesión de captura en el hilo principal
            self.captureSession.startRunning()
        }
    }


    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let lastDetection = lastDetectionTime, Date().timeIntervalSince(lastDetection) < 5 {
            return // Solo hace detección cada 5 segundos
        }
        lastDetectionTime = Date()

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            self?.processDetection(for: request, error: error)
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error en la predicción de objetos: \(error)")
        }
    }

    private func processDetection(for request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }

        if let firstResult = results.first, firstResult.confidence > 0.8 {
            let detectedObject = firstResult.identifier
            let confidence = Double(firstResult.confidence * 100)  // Convertimos a Double aquí
            
            // Llama a la función para mostrar el banner
            showBanner(detectedObject: detectedObject, confidence: confidence)
        }
    }


    private func showBanner(detectedObject: String, confidence: Double) {
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .color(color: .init(UIColor.systemBlue))
        attributes.displayDuration = 2.0
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .dismiss
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.roundCorners = .all(radius: 10)
        attributes.positionConstraints.safeArea = .overridden
        
        let title = EKProperty.LabelContent(text: "Objeto Detectado", style: .init(font: UIFont.boldSystemFont(ofSize: 16), color: .white))
        let description = EKProperty.LabelContent(text: "\(detectedObject) con \(Int(confidence))% de confianza", style: .init(font: UIFont.systemFont(ofSize: 14), color: .white))
        
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

