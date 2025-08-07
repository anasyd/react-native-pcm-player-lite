import { NativeModules, Platform } from 'react-native';
const LINKING_ERROR =
  `The package 'react-native-pcm-player-lite' doesn't seem to be linked. Make sure: \n\n` +
  (Platform.OS === 'ios' ? "- You have run 'pod install'\n" : '') +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow (bare/with autolinking is fine)\n';

const PcmPlayer = NativeModules.PcmPlayer
  ? NativeModules.PcmPlayer
  : new Proxy({}, {
      get() {
        throw new Error(LINKING_ERROR);
      },
    });

/**
 * Start the native PCM player.
 * @param {number} sampleRate e.g., 24000
 */
export function start(sampleRate = 24000) {
  return PcmPlayer.start(sampleRate);
}

/**
 * Enqueue a base64-encoded 16-bit little-endian PCM chunk (mono).
 * Keep chunks around 10–60 ms of audio for best results.
 */
export function enqueueBase64(b64) {
  return PcmPlayer.enqueueBase64(b64);
}

/** Stop and release audio resources. */
export function stop() {
  return PcmPlayer.stop();
}

export default { start, enqueueBase64, stop };
