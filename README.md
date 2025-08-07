# react-native-pcm-player-lite

Tiny React Native native module to play **streaming 16‑bit PCM (mono, little‑endian)** with very low latency.
Works great for AI voice assistants that stream raw PCM over sockets.

- Android: `AudioTrack` streaming mode
- iOS: `AVAudioEngine` + `AVAudioPlayerNode` (converts Int16 -> Float32)

> ⚠️ Expects base64-encoded **Int16 LE** PCM chunks and a **fixed sample rate** (e.g., 24000).

## Install

```bash
npm i react-native-pcm-player-lite
# or
yarn add react-native-pcm-player-lite
```

iOS:
```bash
cd ios && pod install && cd ..
```

Rebuild your app (Android/iOS). Autolinking will pick it up.

## Usage

```ts
import PCM from 'react-native-pcm-player-lite'

await PCM.start(24000) // start before first chunk

// For each audio chunk from your server (base64 Int16LE PCM):
PCM.enqueueBase64(chunkBase64)

// When the utterance/stream ends:
await PCM.stop()
```

### Chunk sizing
Send ~10–60 ms of audio per chunk:
- At 24 kHz mono, 10 ms = 240 samples = 480 bytes.
- At 24 kHz mono, 40 ms = 960 samples = 1920 bytes.

Too-small chunks can underrun; too-large chunks add latency.

## API

- `start(sampleRate?: number): Promise<void>` – Start the audio engine and prepare streaming.
- `enqueueBase64(base64Chunk: string): void` – Push raw PCM data (base64 string).
- `stop(): Promise<void>` – Stop and release resources.

## Troubleshooting

- **Silence?** Ensure your PCM is **16-bit little‑endian**, **mono**, and sample rate matches `start()`.
- **Stutter on Android?** Increase queue size or send slightly larger chunks (e.g., 20–40 ms).
- **iOS quiet/muted?** Check the device's silent switch and ensure your app's audio session allows playback.

## License
MIT
