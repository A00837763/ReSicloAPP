import SwiftUI
import MapKit
import FirebaseAuth

struct HomeView: View {
    @Binding var selectedTab: Int

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161), // Ejemplo: Monterrey
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )

    @State private var userName: String = "Usuario"
    @State private var userPoints: Int = 0
    @State private var showScanner = false
    @State private var showHistory = false
    @State private var scannerQRData: QRScannerData?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HeaderView(userName: userName)
                Divider()

                HStack(spacing: 16) {
                    LastVisitMapView(position: position, onTapMap: {
                        selectedTab = 2
                    })
                    PointsSummaryView(points: userPoints, level: "Eco Guerrero")
                }
                .frame(height: 200)

                Divider()

                HStack(spacing: 16) {
                    Button(action: {
                        showScanner = true
                    }) {
                        Label("Escanear QR", systemImage: "qrcode.viewfinder")
                    }
                    .buttonStyle(.bordered)

                    Button(action: {
                        showHistory = true
                    }) {
                        Label("Historial", systemImage: "clock")
                    }
                    .buttonStyle(.bordered)
                }

                Divider()
                ActivityView()
                Divider()
                KnowledgeSection()
            }
            .padding()
        }
        .onAppear(perform: cargarDatosUsuario) // Carga los datos al aparecer la vista
        .sheet(isPresented: $showScanner) {
            QRScannerView(
                didFindCode: { code in
                    // Simula datos del QR escaneado
                    scannerQRData = QRScannerData(qrData: code, material: "Plástico", kilos: 5)
                }
            )
        }
        .sheet(item: $scannerQRData) { data in
            ViewDataQR(
                qrData: data.qrData,
                material: data.material,
                kilos: data.kilos,
                onDismiss: {
                    guardarReciclaje(kilos: data.kilos, material: data.material, puntos: data.kilos * 10)
                    scannerQRData = nil
                    cargarDatosUsuario()
                }
            )
        }
        .sheet(isPresented: $showHistory) {
            HistorialReciclajeView()
        }
    }

    /// Carga los datos del usuario desde Firestore
    func cargarDatosUsuario() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Usuario no autenticado, no se puede cargar la información del usuario.")
            return
        }

        FirestoreManager.shared.obtenerDatosUsuario(uid: uid) { result in
            switch result {
            case .success(let userData):
                userName = userData["name"] as? String ?? "Usuario"
                userPoints = userData["puntosTotales"] as? Int ?? 0
            case .failure(let error):
                print("Error al cargar los datos del usuario: \(error.localizedDescription)")
            }
        }
    }

    /// Guarda el reciclaje en Firestore y actualiza el estado
    func guardarReciclaje(kilos: Int, material: String, puntos: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Usuario no autenticado, no se puede guardar el reciclaje.")
            return
        }

        FirestoreManager.shared.guardarReciclaje(
            uid: uid,
            kilos: kilos,
            material: material,
            puntos: puntos
        )

        userPoints += puntos // Actualiza los puntos totales localmente
    }
}

