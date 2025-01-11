import Foundation

@objc(NativeLocalStorage)
class NativeLocalStorage: NSObject {
    private let localStorage = UserDefaults(suiteName: "local-storage")

    @objc func setItem(_ value: String, key: String) {
        localStorage?.set(value, forKey: key)
    }

    @objc func getItem(_ key: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        if let value = localStorage?.string(forKey: key) {
            resolver(value)
        } else {
            resolver(nil) // Return `null` if the key does not exist
        }
    }

    @objc func removeItem(_ key: String) {
        localStorage?.removeObject(forKey: key)
    }

    @objc func clear() {
        guard let localStorage = localStorage else { return }
        for key in localStorage.dictionaryRepresentation().keys {
            localStorage.removeObject(forKey: key)
        }
    }
}


