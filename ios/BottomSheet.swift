// BottomSheet.swift
import Foundation
import SwiftUI
import UIKit

// MARK: - SwiftUI Bottom Sheet View
struct BottomSheetView: View {
    @Binding var isPresented: Bool
    let config: BottomSheetConfig
    let onButtonTapped: (Int) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Handle indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
            
            // Title
            if let title = config.title {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal)
            }
            
            // Message
            if let message = config.message {
                Text(message)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            // Buttons
            VStack(spacing: 10) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, button in
                    Button(action: {
                        onButtonTapped(index)
                        isPresented = false
                    }) {
                        Text(button.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(buttonColor(for: button.style))
                            .foregroundColor(buttonTextColor(for: button.style))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color(UIColor.systemBackground) : .white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 10)
    }
    
    private func buttonColor(for style: ButtonStyle) -> Color {
        switch style {
        case .destructive:
            return .red.opacity(0.1)
        case .cancel:
            return Color(.systemGray5)
        case .default:
            return Color(.systemBlue).opacity(0.1)
        }
    }
    
    private func buttonTextColor(for style: ButtonStyle) -> Color {
        switch style {
        case .destructive:
            return .red
        case .cancel:
            return .primary
        case .default:
            return .blue
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Configuration Structures
struct BottomSheetConfig {
    let title: String?
    let message: String?
    let buttons: [ButtonConfig]
    let height: CGFloat
    
    struct ButtonConfig {
        let title: String
        let style: ButtonStyle
    }
}

enum ButtonStyle: String {
    case `default`
    case cancel
    case destructive
}

// MARK: - Bottom Sheet Host Controller
class BottomSheetHostingController: UIHostingController<AnyView> {
    private var bottomConstraint: NSLayoutConstraint?
    private let defaultHeight: CGFloat
    
    init(rootView: AnyView, height: CGFloat) {
        self.defaultHeight = height
        super.init(rootView: rootView)
        self.view.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        animateIn()
    }
    
    private func setupConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let parentView = view.superview {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                view.heightAnchor.constraint(equalToConstant: defaultHeight)
            ])
            
            bottomConstraint = view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: defaultHeight)
            bottomConstraint?.isActive = true
        }
    }
    
    func animateIn() {
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.superview?.layoutIfNeeded()
        }
    }
    
    func animateOut(completion: @escaping () -> Void) {
        bottomConstraint?.constant = defaultHeight
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.view.superview?.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}

// MARK: - React Native Module
@objc(NativeBottomSheet)
class NativeBottomSheet: NSObject {
    private var hostingController: BottomSheetHostingController?
    private var resolveBlock: RCTPromiseResolveBlock?
    
    @objc
    func showBottomSheet(_ config: NSDictionary,
                        resolver resolve: @escaping RCTPromiseResolveBlock,
                        rejecter reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.resolveBlock = resolve
            
            let bottomSheetConfig = self.parseConfig(config)
            let screenHeight = UIScreen.main.bounds.height
            let height = (bottomSheetConfig.height / 100.0) * screenHeight
            
            var isPresented = true
            let bottomSheetView = BottomSheetView(
                isPresented: .init(get: { isPresented },
                                 set: { isPresented = $0 }),
                config: bottomSheetConfig) { buttonIndex in
                    self.dismissBottomSheet()
                    self.resolveBlock?(buttonIndex)
                }
            
            let hostingController = BottomSheetHostingController(
                rootView: AnyView(bottomSheetView),
                height: height
            )
            
            self.hostingController = hostingController
            
            guard let rootVC = RCTPresentedViewController() else {
                reject("ERROR", "No root view controller found", nil)
                return
            }
            
            hostingController.modalPresentationStyle = .overFullScreen
            hostingController.view.backgroundColor = .black.withAlphaComponent(0.5)
            
            rootVC.present(hostingController, animated: false)
        }
    }
    
    @objc
    func dismissBottomSheet() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let hostingController = self.hostingController else { return }
            
            hostingController.animateOut {
                hostingController.dismiss(animated: false)
                self.hostingController = nil
            }
        }
    }
    
    private func parseConfig(_ config: NSDictionary) -> BottomSheetConfig {
        let title = config["title"] as? String
        let message = config["message"] as? String
        let height = CGFloat(config["height"] as? Double ?? 50)
        
        let buttons: [BottomSheetConfig.ButtonConfig] = (config["buttons"] as? [[String: Any]])?.compactMap { buttonDict in
            guard let title = buttonDict["title"] as? String else { return nil }
            let styleString = buttonDict["style"] as? String ?? "default"
            let style = ButtonStyle(rawValue: styleString) ?? .default
            
            return BottomSheetConfig.ButtonConfig(title: title, style: style)
        } ?? []
        
        return BottomSheetConfig(
            title: title,
            message: message,
            buttons: buttons,
            height: height
        )
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
