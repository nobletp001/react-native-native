//
//  NativeImagePickerBridge.m
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//
// NativeImagePickerBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeImagePicker, NSObject)

RCT_EXTERN_METHOD(pickImage:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
