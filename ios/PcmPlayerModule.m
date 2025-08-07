#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(PcmPlayer, NSObject)
RCT_EXTERN_METHOD(start:(nonnull NSNumber *)sampleRate withResolver:(RCTPromiseResolveBlock)resolve withRejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(enqueueBase64:(NSString *)b64)
RCT_EXTERN_METHOD(stop:(RCTPromiseResolveBlock)resolve withRejecter:(RCTPromiseRejectBlock)reject)
@end
