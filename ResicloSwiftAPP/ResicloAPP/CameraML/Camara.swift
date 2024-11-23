import SwiftUI
import UIKit
import AVFoundation
import Vision
import CoreML
import SwiftEntryKit

struct CameraView: UIViewControllerRepresentable {
    class Coordinator {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func capturePhoto() {
            parent.cameraController.capturePhoto()
        }

        func toggleFlash(isOn: Bool) {
            parent.cameraController.toggleFlash(isOn: isOn)
        }

        func switchCamera(isUsingFrontCamera: Bool) {
            parent.cameraController.switchCamera(isUsingFrontCamera: isUsingFrontCamera)
        }
    }


    let cameraController = CameraMLViewController()

    func makeUIViewController(context: Context) -> CameraMLViewController {
        return cameraController
    }

    func updateUIViewController(_ uiViewController: CameraMLViewController, context: Context) {
        // No necesitamos actualizar nada en tiempo real en este caso
    }

    func dismantleUIViewController(_ uiViewController: CameraMLViewController, coordinator: ()) {
        uiViewController.stopCamera()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

struct CameraViewWrapper: View {
    @State private var coordinator: CameraView.Coordinator?
    @State private var isFlashOn = false
    @State private var isUsingFrontCamera = false

    var body: some View {
        ZStack {
            let cameraView = CameraView()
            cameraView
                .onAppear {
                    self.coordinator = cameraView.makeCoordinator()
                }

            VStack {
                // Botones de Flash y Cambiar Cámara
                HStack {
                    Spacer()
                    
                    // Botón de Flash
                    Button(action: {
                        isFlashOn.toggle()
                        coordinator?.parent.cameraController.toggleFlash(isOn: isFlashOn)
                    }) {
                        Image(systemName: isFlashOn ? "bolt.fill" : "bolt.slash.fill") // Rayo encendido o apagado
                            .font(.system(size: 20))
                            .foregroundColor(isFlashOn ? .yellow : .white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.6)).frame(width: 40, height: 40)) // Círculo más pequeño
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                    .padding(.leading, 20)

                    Spacer()

                    // Botón de Cambiar Cámara
                    Button(action: {
                        isUsingFrontCamera.toggle()
                        coordinator?.parent.cameraController.switchCamera(isUsingFrontCamera: isUsingFrontCamera)
                    }) {
                        Image(systemName: "camera.rotate")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.6)).frame(width: 40, height: 40)) // Círculo más pequeño
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding(.top, 40) // Ajusta la posición superior
                
                Spacer()

                // Botón de Captura
                Button(action: {
                    coordinator?.capturePhoto()
                }) {
                    Circle()
                        .fill(Color.white) // Botón blanco
                        .frame(width: 70, height: 70) // Tamaño del botón
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2) // Borde gris claro
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Sombra sutil
                }
                .padding(.bottom, 20)
            }
        }
    }
}


class CameraMLViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let photoOutput = AVCapturePhotoOutput()
    private var isSessionConfigured = false

    // Modelo CoreML
    private lazy var model: VNCoreMLModel = {
        do {
            let config = MLModelConfiguration()
            let mlModel = try VNCoreMLModel(for: best(configuration: config).model)
            return mlModel
        } catch {
            fatalError("Error al cargar el modelo de detección de objetos: \(error)")
        }
    }()
    
    func toggleFlash(isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("El dispositivo no tiene flash.")
            return
        }
        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Error al cambiar el estado del flash: \(error.localizedDescription)")
        }
    }
    
    func switchCamera(isUsingFrontCamera: Bool) {
        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        // Determinar la nueva cámara (frontal o trasera)
        let newCamera = isUsingFrontCamera
            ? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            : AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

        do {
            // Cambiar la entrada actual por la nueva
            let newInput = try AVCaptureDeviceInput(device: newCamera!)
            captureSession.removeInput(currentInput)
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
            }
        } catch {
            print("Error al cambiar la cámara: \(error.localizedDescription)")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPreview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            startCamera()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCamera()
    }

    private func setupCameraPreview() {
        guard !isSessionConfigured else { return }
        isSessionConfigured = true

        captureSession.sessionPreset = .photo

        do {
            guard let camera = AVCaptureDevice.default(for: .video) else {
                throw NSError(domain: "CameraML", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No se encontró una cámara disponible."])
            }

            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            } else {
                throw NSError(domain: "CameraML", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No se pudo añadir la salida de captura."])
            }

            // Configura la capa de vista previa
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspectFill

            // Calcula el área segura
            DispatchQueue.main.async {
                let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame
                self.previewLayer?.frame = safeAreaFrame
                if let previewLayer = self.previewLayer {
                    self.view.layer.addSublayer(previewLayer)
                }
            }
        } catch {
            print("Error durante la configuración de la cámara: \(error.localizedDescription)")
        }
    }


    func startCamera() {
        guard !captureSession.isRunning else { return }
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    func stopCamera() {
        guard captureSession.isRunning else { return }
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }

    func capturePhoto() {
        guard captureSession.isRunning else {
            print("La sesión de captura no está corriendo. No se puede tomar la foto.")
            return
        }

        guard photoOutput.isLivePhotoCaptureSupported else {
            print("La captura de fotos no está soportada en este momento.")
            return
        }

        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto

        do {
            try photoOutput.capturePhoto(with: settings, delegate: self)
        } catch {
            print("Error al intentar capturar la foto: \(error.localizedDescription)")
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error al procesar la foto: \(error.localizedDescription)")
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let ciImage = CIImage(data: imageData) else {
            print("No se pudo obtener la representación de datos de la imagen.")
            return
        }

        detectObjects(in: ciImage)
    }

    private func detectObjects(in image: CIImage) {
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }

            for observation in results {
                let boundingBox = observation.boundingBox
                let topLabelObservation = observation.labels.first
                let detectedObject = topLabelObservation?.identifier ?? "Desconocido"
                let confidence = (topLabelObservation?.confidence ?? 0) * 100

                self?.showBanner(
                    detectedObject: detectedObject,
                    confidence: Double(confidence),
                    boundingBox: boundingBox
                )
            }
        }

        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error al realizar la detección: \(error)")
        }
    }

    private func showBanner(detectedObject: String, confidence: Double, boundingBox: CGRect) {
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .color(color: EKColor(UIColor(named: "ResicloCream1") ?? .systemGreen)) // Fondo del banner
        attributes.displayDuration = 4.0
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.roundCorners = .all(radius: 10)

        let title = EKProperty.LabelContent(
            text: "Objeto Detectado",
            style: .init(
                font: UIFont.boldSystemFont(ofSize: 16),
                color: EKColor(UIColor(named: "ResicloGreen2") ?? .white) // Color personalizado del texto del título
            )
        )
        let description = EKProperty.LabelContent(
            text: "\(detectedObject)",
            style: .init(
                font: UIFont.systemFont(ofSize: 14),
                color: EKColor(UIColor(named: "ResicloGreen1") ?? .white) // Color personalizado del texto de descripción
            )
        )

        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }

}
