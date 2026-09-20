import SwiftUI

// MARK: - Rubber Stamp Kinds & View

public enum RubberStampKind: String, CaseIterable, Sendable {
    case alibiCompromised = "ALIBI COMPROMISED"
    case contradictionDetected = "CONTRADICTION DETECTED"
    case matchConfirmed = "MATCH CONFIRMED"
    case topSecret = "TOP SECRET // CLASSIFIED"
    case evidenceAdmissible = "EVIDENCE ADMISSIBLE"
    case caseClosedSPlus = "CASE CLOSED // S+ EXCELLENCE"
    case underSurveillance = "SUBJECT UNDER SURVEILLANCE"

    public var tintColor: Color {
        switch self {
        case .alibiCompromised:
            return Color(red: 220/255, green: 38/255, blue: 38/255) // Crimson
        case .contradictionDetected:
            return Color(red: 217/255, green: 119/255, blue: 6/255) // Amber
        case .matchConfirmed:
            return Color(red: 16/255, green: 185/255, blue: 129/255) // Emerald
        case .topSecret:
            return Color(red: 75/255, green: 85/255, blue: 99/255) // Slate
        case .evidenceAdmissible:
            return Color(red: 37/255, green: 99/255, blue: 235/255) // Cobalt
        case .caseClosedSPlus:
            return Color(red: 217/255, green: 145/255, blue: 9/255) // Gold
        case .underSurveillance:
            return Color(red: 147/255, green: 51/255, blue: 234/255) // Violet
        }
    }

    public var defaultAngle: Double {
        switch self {
        case .alibiCompromised: return -8.0
        case .contradictionDetected: return 6.5
        case .matchConfirmed: return -5.0
        case .topSecret: return -12.0
        case .evidenceAdmissible: return 4.0
        case .caseClosedSPlus: return -3.5
        case .underSurveillance: return 9.0
        }
    }
}

public struct RubberStampView: View {
    public let kind: RubberStampKind
    public let customAngle: Double?
    public let isSlammed: Bool

    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0

    public init(kind: RubberStampKind, customAngle: Double? = nil, isSlammed: Bool = false) {
        self.kind = kind
        self.customAngle = customAngle
        self.isSlammed = isSlammed
    }

    public var body: some View {
        let angle = customAngle ?? kind.defaultAngle

        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "seal.fill")
                    .font(.system(size: 9, weight: .black))
                Text("METROPOLITAN FORENSIC DIVISION")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .tracking(1.5)
                Image(systemName: "seal.fill")
                    .font(.system(size: 9, weight: .black))
            }
            .opacity(0.85)

            Text(kind.rawValue)
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .tracking(2.0)
                .multilineTextAlignment(.center)
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .overlay(
                    Rectangle()
                        .strokeBorder(kind.tintColor.opacity(0.9), style: StrokeStyle(lineWidth: 2, dash: [6, 2]))
                )

            Text("VERIFIED BY ANALYST DESK • DOSSIER ARCHIVE")
                .font(.system(size: 7, weight: .semibold, design: .monospaced))
                .tracking(1.0)
                .opacity(0.75)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundColor(kind.tintColor)
        .background(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(kind.tintColor.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .strokeBorder(kind.tintColor.opacity(0.85), lineWidth: 1.5)
        )
        .rotationEffect(.degrees(angle))
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            if isSlammed {
                scale = 2.4
                opacity = 0.0
                withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                    scale = 1.0
                    opacity = 0.95
                }
            }
        }
    }
}

// MARK: - PushPin & Frosted Tape Attachments

public struct PushPinView: View {
    public enum PinColor: Sendable {
        case crimson
        case amber
        case brass
        case cobalt
        case obsidian

        var primary: Color {
            switch self {
            case .crimson: return Color(red: 220/255, green: 38/255, blue: 38/255)
            case .amber: return Color(red: 245/255, green: 158/255, blue: 11/255)
            case .brass: return Color(red: 217/255, green: 175/255, blue: 85/255)
            case .cobalt: return Color(red: 37/255, green: 99/255, blue: 235/255)
            case .obsidian: return Color(red: 31/255, green: 41/255, blue: 55/255)
            }
        }
    }

    public let pinColor: PinColor

    public init(_ pinColor: PinColor = .crimson) {
        self.pinColor = pinColor
    }

    public var body: some View {
        ZStack {
            // Drop shadow
            Circle()
                .fill(Color.black.opacity(0.35))
                .frame(width: 14, height: 14)
                .offset(x: 2, y: 3)
                .blur(radius: 1.5)

            // Pin head body with 3D gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            pinColor.primary.opacity(0.9),
                            pinColor.primary,
                            Color.black.opacity(0.6)
                        ],
                        center: .topLeading,
                        startRadius: 2,
                        endRadius: 10
                    )
                )
                .frame(width: 13, height: 13)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.45), lineWidth: 0.8)
                )

            // Center reflective highlight
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 3.5, height: 3.5)
                .offset(x: -2.5, y: -2.5)
        }
    }
}

public struct FrostedTapeView: View {
    public let width: CGFloat
    public let rotation: Double

    public init(width: CGFloat = 56, rotation: Double = -3.0) {
        self.width = width
        self.rotation = rotation
    }

    public var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.45))
            .background(.ultraThinMaterial)
            .frame(width: width, height: 16)
            .overlay(
                Rectangle()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 1, x: 0, y: 1)
            .rotationEffect(.degrees(rotation))
    }
}

// MARK: - Barcode Evidence Tag View

public struct BarcodeEvidenceTagView: View {
    public let serialId: String
    public let category: String

    public init(serialId: String, category: String = "EVID-A") {
        self.serialId = serialId
        self.category = category
    }

    public var body: some View {
        HStack(spacing: 8) {
            // Procedural barcode pattern
            HStack(spacing: 1.5) {
                ForEach(0..<18, id: \.self) { index in
                    let isThick = (index * 7 + 3) % 4 == 0
                    Rectangle()
                        .fill(Color.primary.opacity(0.65))
                        .frame(width: isThick ? 2.2 : 1.0, height: 14)
                }
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(category.uppercased())
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor(.secondary)
                Text(serialId.uppercased())
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color.primary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.12), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Interactive Loupe Modifier

public struct LoupeModifier: ViewModifier {
    @State private var isInspecting: Bool = false
    @State private var touchLocation: CGPoint = .zero

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    if isInspecting {
                        ZStack {
                            // Loupe rim & magnified view
                            Circle()
                                .fill(Color.black.opacity(0.9))
                                .frame(width: 120, height: 120)
                                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 6)

                            // Glass lens reflection highlight
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.8), Color.gray.opacity(0.2), Color.white.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 4
                                )
                                .frame(width: 120, height: 120)

                            // Crosshair reticle
                            Path { path in
                                path.move(to: CGPoint(x: 40, y: 60))
                                path.addLine(to: CGPoint(x: 80, y: 60))
                                path.move(to: CGPoint(x: 60, y: 40))
                                path.addLine(to: CGPoint(x: 60, y: 80))
                            }
                            .stroke(Color.red.opacity(0.8), lineWidth: 1)
                            .frame(width: 120, height: 120)

                            VStack(spacing: 2) {
                                Text("MAGNIFICATION: 2.5X")
                                    .font(.system(size: 7, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("MICROSCOPIC INSPECTION")
                                    .font(.system(size: 6, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .offset(y: 35)
                        }
                        .position(x: min(max(touchLocation.x, 60), geo.size.width - 60),
                                  y: min(max(touchLocation.y - 70, 60), geo.size.height - 60))
                        .allowsHitTesting(false)
                    }
                }
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        touchLocation = value.location
                        if !isInspecting {
                            isInspecting = true
                        }
                    }
                    .onEnded { _ in
                        isInspecting = false
                    }
            )
    }
}

public enum MultispectralFilter: String, CaseIterable, Identifiable {
    case visible = "Visible (Standard)"
    case ultraviolet = "UV 365nm (Fluorescence)"
    case infraredNegative = "IR / Negative"

    public var id: String { rawValue }

    public var sfSymbol: String {
        switch self {
        case .visible: return "sun.max.fill"
        case .ultraviolet: return "waveform.path.ecg"
        case .infraredNegative: return "circle.lefthalf.striped.horizontal"
        }
    }
}

public struct MultispectralFilterModifier: ViewModifier {
    public let filter: MultispectralFilter

    public func body(content: Content) -> some View {
        switch filter {
        case .visible:
            content
        case .ultraviolet:
            content
                .colorMultiply(Color(red: 0.75, green: 0.5, blue: 1.0))
                .contrast(1.3)
                .saturation(1.4)
                .overlay(
                    Color.purple.opacity(0.15)
                        .blendMode(.colorDodge)
                )
        case .infraredNegative:
            content
                .colorInvert()
                .contrast(1.35)
                .grayscale(0.8)
        }
    }
}

public extension View {
    func forensicLoupeInspection() -> some View {
        self.modifier(LoupeModifier())
    }

    func multispectralFilter(_ filter: MultispectralFilter) -> some View {
        self.modifier(MultispectralFilterModifier(filter: filter))
    }
}

// MARK: - Forensic Asset Loader & Image View

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

public enum ForensicAssetLoader {
    public static func image(named name: String) -> PlatformImage? {
        let cleanName = (name as NSString).deletingPathExtension
        
        #if canImport(UIKit)
        for ext in ["jpg", "jpeg", "png"] {
            if let path = Bundle.main.path(forResource: cleanName, ofType: ext) {
                if let img = UIImage(contentsOfFile: path) { return img }
            }
        }
        
        if let resPath = Bundle.main.resourcePath {
            for ext in ["jpg", "jpeg", "png"] {
                let p1 = (resPath as NSString).appendingPathComponent("\(cleanName).\(ext)")
                if FileManager.default.fileExists(atPath: p1), let img = UIImage(contentsOfFile: p1) {
                    return img
                }
                let p2 = (resPath as NSString).appendingPathComponent("Assets/\(cleanName).\(ext)")
                if FileManager.default.fileExists(atPath: p2), let img = UIImage(contentsOfFile: p2) {
                    return img
                }
            }
        }
        return UIImage(named: cleanName)
        #elseif canImport(AppKit)
        for ext in ["jpg", "jpeg", "png"] {
            if let path = Bundle.main.path(forResource: cleanName, ofType: ext) {
                if let img = NSImage(contentsOfFile: path) { return img }
            }
        }
        return NSImage(named: cleanName)
        #else
        return nil
        #endif
    }
}

public struct ForensicImageView: View {
    public let name: String
    public let fallbackSymbol: String
    public let contentMode: ContentMode

    public init(name: String, fallbackSymbol: String = "photo", contentMode: ContentMode = .fill) {
        self.name = name
        self.fallbackSymbol = fallbackSymbol
        self.contentMode = contentMode
    }

    public var body: some View {
        #if canImport(UIKit)
        if let uiImage = ForensicAssetLoader.image(named: name) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            Image(systemName: fallbackSymbol)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        #elseif canImport(AppKit)
        if let nsImage = ForensicAssetLoader.image(named: name) {
            Image(nsImage: nsImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            Image(systemName: fallbackSymbol)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        #else
        Image(systemName: fallbackSymbol)
            .resizable()
            .aspectRatio(contentMode: .fit)
        #endif
    }
}

