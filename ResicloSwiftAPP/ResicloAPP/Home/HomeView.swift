import SwiftUI
import MapKit
import FirebaseAuth

struct HomeView: View {
    @Binding var selectedTab: Int
    @State  var showProfileView = false
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
                    
                    HStack(spacing: 16){
                        PointsSummaryView(points: userPoints, level: "Eco Guerrero")
                        
                    }
                    
                    KnowledgeSection()
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showHistory = true
                    }) {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                            .foregroundColor(Color("ResicloGreen1"))
                    }
                    
                    Button(action: {
                        showScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 20))
                            .foregroundColor(Color("ResicloGreen1"))
                    }
                    Button(action: {
                        // Obtén la URL de la imagen de Firestore antes de mostrar ProfileView
                        authManager.obtenerImagenDePerfilDesdeFirestore { url in
                            if let url = url {
                                authManager.profileImageURL = url // Asegúrate de actualizar la URL
                            }
                            showProfileView = true
                        }
                    }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 25))
                            .foregroundColor(Color("ResicloGreen1"))
                    }
                    
                }
                ToolbarItem(placement: .topBarLeading){
                    Text("Resiclo")
                        .font(.title)
                        .foregroundStyle(.resicloGreen2)
                        .fontWeight(.bold)
    
                    
                }
            }
        }
        .onAppear(perform: cargarDatosUsuario)
        .sheet(isPresented: $showScanner) {
            QRScannerView(
                didFindCode: { code in
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

    func cargarDatosUsuario() {
        // Si el usuario no está autenticado, no intentamos cargar datos
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Usuario no autenticado, se mostrará la vista sin datos del usuario.")
            return
        }

        // Si el usuario está autenticado, cargamos los datos
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

        userPoints += puntos
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a constant binding for `selectedTab`
        HomeView(selectedTab: .constant(1))
    }
}