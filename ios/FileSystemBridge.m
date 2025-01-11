//
//  FileSystemBridge.m
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FileSystem, NSObject)

RCT_EXTERN_METHOD(getDocumentDirectory:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

@end
