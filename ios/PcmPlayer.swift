import Foundation
import AVFoundation

@objc(PcmPlayer)
class PcmPlayer: NSObject {

  private let engine = AVAudioEngine()
  private let player = AVAudioPlayerNode()
  private var fmt: AVAudioFormat?
  private var isStarted = false

  @objc(start:withResolver:withRejecter:)
  func start(sampleRate: NSNumber,
             resolve: RCTPromiseResolveBlock,
             reject: RCTPromiseRejectBlock) {
    if isStarted { resolve(nil); return }
    let sr = sampleRate.doubleValue
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {}

    // Use float32 format and convert from Int16 manually.
    fmt = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sr, channels: 1, interleaved: true)

    engine.attach(player)
    engine.connect(player, to: engine.mainMixerNode, format: fmt)
    do {
      try engine.start()
      player.play()
      isStarted = true
      resolve(nil)
    } catch {
      reject("ERR_START", "Failed to start audio engine", error)
    }
  }

  @objc(enqueueBase64:)
  func enqueueBase64(_ b64: NSString) {
    guard isStarted, let fmt = fmt else { return }
    guard let data = Data(base64Encoded: b64 as String) else { return }
    let count = data.count / 2
    var floats = [Float](repeating: 0, count: count)
    data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
      let int16s = ptr.bindMemory(to: Int16.self)
      for i in 0..<count {
        floats[i] = Float(int16s[i]) / 32768.0
      }
    }
    let frameCount = AVAudioFrameCount(count)
    guard let buffer = AVAudioPCMBuffer(pcmFormat: fmt, frameCapacity: frameCount) else { return }
    buffer.frameLength = frameCount
    let ch = buffer.floatChannelData![0]
    floats.withUnsafeBufferPointer { src in
      ch.assign(from: src.baseAddress!, count: count)
    }
    player.scheduleBuffer(buffer, completionHandler: nil)
  }

  @objc(stop:withRejecter:)
  func stop(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    if !isStarted { resolve(nil); return }
    player.stop()
    engine.stop()
    isStarted = false
    resolve(nil)
  }

  @objc static func requiresMainQueueSetup() -> Bool { false }
}
