declare module 'react-native-pcm-player-lite' {
  /** Start the native PCM player at the given sample rate (e.g., 24000). */
  export function start(sampleRate?: number): Promise<void>;
  /** Enqueue a base64-encoded 16-bit LE PCM chunk (mono). */
  export function enqueueBase64(base64Chunk: string): void;
  /** Stop and release resources. */
  export function stop(): Promise<void>;
  const _default: { start: typeof start; enqueueBase64: typeof enqueueBase64; stop: typeof stop };
  export default _default;
}
