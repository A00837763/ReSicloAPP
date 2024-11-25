import SwiftUI

struct QRGeneratorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var material: String = ""
    @State private var kilos: String = ""
    @State private var showQRCode = false
    @State private var showMaterialPicker = false
    @FocusState private var isKilosFocused: Bool
    
    private let materials = Array(MaterialMultiplicador.obtenerMateriales()).sorted()
    
    private var isValidForm: Bool {
        !material.isEmpty && !kilos.isEmpty && (Double(kilos) ?? 0) > 0
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Registrar Material Reciclado")
                    .font(.headline)
                
                Button(action: {
                    isKilosFocused = false
                    showMaterialPicker = true
                }) {
                    HStack {
                        Text(material.isEmpty ? "Seleccionar Material" : material)
                            .foregroundColor(material.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4))
                    )
                }
                .padding(.horizontal)
                
                TextField("Kilos reciclados", text: $kilos)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($isKilosFocused)
                    .padding(.horizontal)
                
                Button(action: {
                    isKilosFocused = false
                    showQRCode = true
                }) {
                    Text("Generar Código QR")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isValidForm)
                
                Spacer()
            }
            .padding()
            .onTapGesture {
                isKilosFocused = false
            }
            .sheet(isPresented: $showMaterialPicker) {
                NavigationView {
                    List(materials, id: \.self) { item in
                        Button(action: {
                            material = item
                            showMaterialPicker = false
                        }) {
                            Text(item)
                        }
                    }
                    .navigationTitle("Seleccionar Material")
                    .navigationBarItems(trailing: Button("Cancelar") {
                        showMaterialPicker = false
                    })
                }
            }
            .sheet(isPresented: $showQRCode) {
                NavigationView {
                    QRCodeView(dataString: "\(material):\(kilos)")
                        .navigationBarItems(trailing: Button("Listo") {
                            showQRCode = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                dismiss()
                            }
                        })
                }
            }
            .navigationTitle("Registrar Material")
            .navigationBarItems(trailing: Button("Cancelar") {
                dismiss()
            })
        }
    }
}
