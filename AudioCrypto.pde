import ddf.minim.*;
import ddf.minim.analysis.*;

// Define the buffer size as a constant
final int BUFFER_SIZE = 1024 * 100;

Minim minim;
AudioInput in;
float[] ringBuffer;
int ringBufferIndex = 0;
float[] secretBuffer = null;
int secretStartMillis = 0;

void setup() {
  size(800, 600);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 2048);
  ringBuffer = new float[BUFFER_SIZE]; // Use the constant here
}

void draw() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  
  //text("Not granted");

  // Continuously update the ring buffer with incoming audio samples
  updateRingBuffer();

  // Handle real-time passphrase recording
  /*if (recordingPassphrase) {
    passphraseSampleCounter += in.bufferSize();
    if (passphraseSampleCounter >= BUFFER_SIZE) {
      passphraseBuffer = ringBuffer.clone(); // Save the current buffer as passphrase
      recordingPassphrase = false;
      passphraseSampleCounter = 0;
      println("Passphrase recorded!");
    }
  }*/
  
  int STEP_SIZE = 10;
  if (secretBuffer != null) {
    stroke(0, 255, 0, 255);
    for (int i = 0; i < BUFFER_SIZE - STEP_SIZE; i += STEP_SIZE) {
      line(width * (float)i/BUFFER_SIZE, height / 2 + secretBuffer[(i) % BUFFER_SIZE] * 100, width * (float)(i+1)/BUFFER_SIZE, height / 2 + secretBuffer[(i + STEP_SIZE) % BUFFER_SIZE] * 100);
     }
     
    if (compareBuffers(ringBuffer, secretBuffer)) {
      secretBuffer = null;
    }
  }
  
  stroke(255);
  for (int i = 0; i < BUFFER_SIZE - STEP_SIZE; i += STEP_SIZE) {
    line(width * (float)i/BUFFER_SIZE, height / 2 + ringBuffer[(i + ringBufferIndex) % BUFFER_SIZE] * 100, width * (float)(i+1)/BUFFER_SIZE, height / 2 + ringBuffer[(i + STEP_SIZE + ringBufferIndex) % BUFFER_SIZE] * 100);
  }
  

}

void keyPressed() {
  if (key == 'r') {
    secretBuffer = new float[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE - 1; i++) {
      secretBuffer[i] = ringBuffer[(i + ringBufferIndex) % BUFFER_SIZE];
    }
    secretStartMillis = millis();
  }
}

void updateRingBuffer() {
  // Fill the ring buffer with the latest audio samples
  for (int i = 0; i < in.bufferSize(); i++) {
    ringBuffer[ringBufferIndex++] = in.mix.get(i);
    ringBufferIndex %= BUFFER_SIZE; // Wrap around using the constant
  }
}

void normalizeBuffer(float[] buffer) {
  // Step 1: Find the maximum absolute value in the buffer
  float maxAmplitude = 0;
  for (int i = 0; i < buffer.length; i++) {
    maxAmplitude = max(maxAmplitude, abs(buffer[i]));
  }

  // Step 2: If maxAmplitude is zero, the buffer is silent, and normalization is not needed
  if (maxAmplitude == 0) return;

  // Step 3: Calculate the normalization factor
  float normalizationFactor = 1.0 / maxAmplitude;

  // Step 4: Scale all samples by the normalization factor
  for (int i = 0; i < buffer.length; i++) {
    buffer[i] *= normalizationFactor;
  }
}


boolean compareBuffers(float[] buffer1, float[] buffer2) {
  if (secretStartMillis > millis() - 1500) {
    return false;
  }
  
  boolean result = true;
  
  // Compute the absolute difference between two buffers
  for (int i = 0; i < BUFFER_SIZE; i++) {
    int start = i;
    float totalDifference = 0;
    for (; i < BUFFER_SIZE && i < start + 1024 * 3; i++) {
      totalDifference += abs(buffer1[(i + ringBufferIndex) % BUFFER_SIZE]) - abs(buffer2[i]);
    }
    totalDifference = abs(totalDifference);
    fill(255, 255, totalDifference > 50.0 ? 0 : 255);
    text((int)totalDifference, width * (float)(i)/BUFFER_SIZE - 30, 35);
    if (totalDifference > 50.0) {
      result = false;
    }
  }
  
  return result;
}

void stop() {
  in.close();
  minim.stop();
  super.stop();
}
