import SwiftUI
import MapKit
import FirebaseAuth

struct HomeView: View {
    @Binding var selectedTab: Int
    @State var showProfileView = false
    @ObservedObject var authManager = AuthenticationManager.shared
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )
    
    @State private var userName: String = "Usuario"
    @State private var userPoints: Int = 0
    @State private var showScanner = false
    @State private var showHistory = false
    @State private var scannerQRData: QRScannerData?
    @State private var showDataView = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HeaderView(userName: userName, showProfileView: $showProfileView)
                    
                    HStack(spacing: 16) {
                        LastVisitMapView(position: position, onTapMap: {
                            selectedTab = 3
                        })
                    }
                    
                    HStack(spacing: 16) {
                        PointsSummaryView(points: userPoints)
                    }
                    
                    KnowledgeSection()
                }
                .padding()
            }
            .background(Color(.secondarySystemBackground))
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: { showHistory = true }) {
                        Image(systemName: "clock")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { showScanner = true }) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        authManager.obtenerImagenDePerfilDesdeFirestore { url in
                            if let url = url {
                                authManager.profileImageURL = url
                            }
                            showProfileView = true
                        }
                    }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("Resiclo")
                        .font(.title)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
            }
            .toolbarBackground(.resicloGreen2, for: .navigationBar)
        }
        .sheet(isPresented: $showScanner) {
            QRScannerView(
                didFindCode: { code in
                    if let data = QRScannerData(qrData: code) {
                        scannerQRData = data
                        showScanner = false
                        showDataView = true
                    }
                },
                isPresented: $showScanner
            )
        }
        .sheet(isPresented: $showDataView) {
                        if let data = scannerQRData {
                            ViewDataQR(
                                qrData: "\(data.material):\(data.kilos)",
                                material: data.material,
                                kilos: data.kilos,
                                onDismiss: {
                                    let puntos = Int(Double(data.kilos) * MaterialMultiplicador.obtenerMultiplicador(para: data.material))
                                    userPoints += puntos
                                    guardarReciclaje(kilos: data.kilos, material: data.material)
                                    showDataView = false
                                }
                            )
                        }
                    }
        .sheet(isPresented: $showHistory) {
            HistorialReciclajeView()
        }
        .onAppear(perform: cargarDatosUsuario)
    }
    
    private func cargarDatosUsuario() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirestoreManager.shared.obtenerDatosUsuario(uid: uid) { result in
            switch result {
            case .success(let userData):
                userName = userData["name"] as? String ?? "Usuario"
                userPoints = userData["puntosTotales"] as? Int ?? 0
            case .failure(let error):
                print("Error loading user data: \(error.localizedDescription)")
            }
        }
    }
    
    private func guardarReciclaje(kilos: Int, material: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let puntos = Int(Double(kilos) * MaterialMultiplicador.obtenerMultiplicador(para: material))
        
        FirestoreManager.shared.guardarReciclaje(
            uid: uid,
            kilos: kilos,
            material: material,
            puntos: puntos
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(1))
    }
}


