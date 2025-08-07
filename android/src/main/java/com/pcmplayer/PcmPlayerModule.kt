package com.pcmplayer

import com.facebook.react.bridge.*
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.util.Base64
import java.util.concurrent.ArrayBlockingQueue
import kotlin.concurrent.thread

class PcmPlayerModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  private var track: AudioTrack? = null
  private val queue = ArrayBlockingQueue<ByteArray>(64)
  @Volatile private var playing = false

  override fun getName() = "PcmPlayer"

  @ReactMethod
  fun start(sampleRate: Int, promise: Promise) {
    try {
      if (track != null) { promise.resolve(null); return }
      val minBuf = AudioTrack.getMinBufferSize(
        sampleRate,
        AudioFormat.CHANNEL_OUT_MONO,
        AudioFormat.ENCODING_PCM_16BIT
      )
      track = AudioTrack(
        AudioManager.STREAM_MUSIC,
        sampleRate,
        AudioFormat.CHANNEL_OUT_MONO,
        AudioFormat.ENCODING_PCM_16BIT,
        minBuf * 2,
        AudioTrack.MODE_STREAM
      )
      track!!.play()
      playing = true
      thread(isDaemon = true) {
        val t = track!!
        while (playing) {
          val data = queue.take() // blocks
          var off = 0
          while (off < data.size) {
            val wrote = t.write(data, off, data.size - off, AudioTrack.WRITE_BLOCKING)
            if (wrote > 0) off += wrote else break
          }
        }
      }
      promise.resolve(null)
    } catch (e: Exception) {
      promise.reject("ERR_START", e)
    }
  }

  @ReactMethod
  fun enqueueBase64(b64: String) {
    try {
      val bytes = Base64.decode(b64, Base64.DEFAULT)
      queue.offer(bytes)
    } catch (_: Exception) {}
  }

  @ReactMethod
  fun stop(promise: Promise) {
    try {
      playing = false
      track?.let { it.stop(); it.release() }
      track = null
      queue.clear()
      promise.resolve(null)
    } catch (e: Exception) {
      promise.reject("ERR_STOP", e)
    }
  }
}
