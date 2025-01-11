//
//  FileSystem.swift
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//
import Foundation

@objc(FileSystem)
class FileSystem: NSObject {
    @objc func getDocumentDirectory(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        resolve(paths.first?.absoluteString ?? "")
    }
}
