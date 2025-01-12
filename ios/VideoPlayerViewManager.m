
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(VideoPlayerViewManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(uri, NSString)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(volume, float)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, NSString)
@end

@interface RCT_EXTERN_MODULE(NativeVideoPlayer, NSObject)
RCT_EXTERN_METHOD(getConstants)
@end
