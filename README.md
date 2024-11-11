# ResicloAPP 🌱♻️

Repositorio para el desarrollo de la app **Reciclo** en la clase **TC2007B**.

Una aplicación iOS nativa dedicada a promover y facilitar el reciclaje responsable.

## 📝 Descripción

ResicloAPP es una solución integral para iOS que ayuda a los usuarios a reciclar correctamente sus residuos. La aplicación proporciona información detallada sobre clasificación de materiales y localiza puntos de reciclaje cercanos utilizando datos de Ecolana.

## ✨ Características Principales

- 🔍 Identificación inteligente de residuos usando CoreML
- 📍 Mapa interactivo de puntos de reciclaje con MapKit
- 💾 Almacenamiento local eficiente con SwiftData
- 📱 Interfaz moderna e intuitiva construida con SwiftUI
- 📊 Seguimiento personal de reciclaje
- 🎯 Sistema de recompensas por reciclaje

## 🛠️ Tecnologías y Arquitectura

### Frameworks
- SwiftUI
- MapKit
- CoreLocation
- SwiftData
- CoreML

### Arquitectura
- Patrón MVVM (Model-View-ViewModel)
- Clean Architecture

### Servicios
- Firebase (Autenticación y Analytics)
- Ecolana API (Datos de puntos de reciclaje)

## 📋 Prerrequisitos

- macOS Sonoma o superior
- Xcode 15.0+
- iOS 17.0+
- Cuenta de desarrollador de Apple
- CocoaPods (para dependencias de Firebase)

## 🚀 Instalación

1. Clona el repositorio
```bash
git clone https://github.com/tuusuario/resicloapp.git
```

2. Instala las dependencias de CocoaPods
```bash
cd resicloapp
pod install
```

3. Abre el workspace en Xcode
```bash
open ResicloAPP.xcworkspace
```

4. Configura los certificados de desarrollo y firma el proyecto

## 🔑 Configuración

### Firebase
1. Crea un nuevo proyecto en Firebase Console
2. Descarga `GoogleService-Info.plist`
3. Añade el archivo al proyecto en Xcode
4. Inicializa Firebase en `ResicloAPPApp.swift`

### Ecolana API
Configura las credenciales de la API en `Config.swift`:
```swift
struct APIConfig {
    static let baseURL = "https://api.ecolana.mx"
}
```


## 🧪 Testing

El proyecto incluye pruebas unitarias y de UI. Para ejecutarlas:
1. Abre el proyecto en Xcode
2. Presiona ⌘ + U o navega a Product > Test

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:

1. Haz fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Realiza tus cambios siguiendo el estilo de código Swift
4. Asegúrate de que todos los tests pasen
5. Haz commit de tus cambios
6. Abre un Pull Request

## 📄 Licencia

Este proyecto es con fines eductaivos, no de lucro

## 👥 Equipo

- Cuatro Cuatro Ojos

## 🙏 Agradecimientos

- Ecolana por proporcionar acceso a su API
- La comunidad de reciclaje por su retroalimentación
- Apple Developer Academy por su apoyo
