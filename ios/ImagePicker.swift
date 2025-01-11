// ImagePicker.swift
import Foundation
import UIKit
import Photos

@objc(NativeImagePicker)
class NativeImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var resolveBlock: RCTPromiseResolveBlock?
    private var rejectBlock: RCTPromiseRejectBlock?
    
    // Keep strong reference to image picker
    private var imagePicker: UIImagePickerController?
    
    @objc
    func pickImage(_ resolve: @escaping RCTPromiseResolveBlock,
                  rejecter reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                reject("DEALLOCATED", "Image picker was deallocated", nil)
                return
            }
            
            self.resolveBlock = resolve
            self.rejectBlock = reject
            
            self.checkPhotoLibraryPermission()
        }
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            self.presentImagePicker()
        case .denied, .restricted:
            self.rejectBlock?("PERMISSION_DENIED", "Photo library access denied", nil)
            self.cleanup()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    if status == .authorized || status == .limited {
                        self.presentImagePicker()
                    } else {
                        self.rejectBlock?("PERMISSION_DENIED", "Photo library access denied", nil)
                        self.cleanup()
                    }
                }
            }
        @unknown default:
            self.rejectBlock?("UNKNOWN_ERROR", "Unknown permission status", nil)
            self.cleanup()
        }
    }
    
    private func presentImagePicker() {
        guard let viewController = RCTPresentedViewController() else {
            self.rejectBlock?("VIEW_ERROR", "Cannot present image picker - no view controller found", nil)
            self.cleanup()
            return
        }
        
        let picker = UIImagePickerController()
        self.imagePicker = picker // Keep strong reference
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        
        viewController.present(picker, animated: true) { [weak self] in
            // Check if presentation was successful
            if viewController.presentedViewController == nil {
                self?.rejectBlock?("PRESENTATION_ERROR", "Failed to present image picker", nil)
                self?.cleanup()
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        do {
            // Validate image data
            guard let image = info[.originalImage] as? UIImage else {
                throw NSError(domain: "ImagePickerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data"])
            }
            
            guard let imageURL = info[.imageURL] as? URL else {
                throw NSError(domain: "ImagePickerError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to get image URL"])
            }
            
            // Get image properties
            let imageSize = image.size
            let fileSize = try FileManager.default.attributesOfItem(atPath: imageURL.path)[.size] as? Int64 ?? 0
            
            let result: [String: Any] = [
                "uri": imageURL.absoluteString,
                "width": imageSize.width,
                "height": imageSize.height,
                "fileSize": fileSize,
                "fileName": imageURL.lastPathComponent,
                "type": "image/\(imageURL.pathExtension.lowercased())"
            ]
            
            // Dismiss picker before calling resolve
            picker.dismiss(animated: true) { [weak self] in
                self?.resolveBlock?(result)
                self?.cleanup()
            }
            
        } catch {
            picker.dismiss(animated: true) { [weak self] in
                self?.rejectBlock?("IMAGE_PROCESSING_ERROR", error.localizedDescription, nil)
                self?.cleanup()
            }
        }
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.rejectBlock?("USER_CANCELLED", "User cancelled image selection", nil)
            self?.cleanup()
        }
    }
    
    // Cleanup method to reset state
    private func cleanup() {
        self.resolveBlock = nil
        self.rejectBlock = nil
        self.imagePicker = nil
    }
    
    // Required for React Native
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
