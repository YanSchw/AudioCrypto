import ddf.minim.*;
import ddf.minim.analysis.*;

// Define the buffer size as a constant
final int BUFFER_SIZE = 1024 * 100;

Minim minim;
AudioInput in;
float[] ringBuffer;
int ringBufferIndex = 0;
float[] secretBuffer = null;

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
  
  
  if (secretBuffer != null) {
    stroke(0, 255, 0, 255);
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      line(width * (float)i/BUFFER_SIZE, height / 2 + secretBuffer[(i) % BUFFER_SIZE] * 100, width * (float)(i+1)/BUFFER_SIZE, height / 2 + secretBuffer[(i + 1) % BUFFER_SIZE] * 100);
      i += 10;
     }
     
    text(compareBuffers(ringBuffer, secretBuffer), 20, 20);
  }
  
  stroke(255);
  for (int i = 0; i < BUFFER_SIZE - 1; i++) {
    line(width * (float)i/BUFFER_SIZE, height / 2 + ringBuffer[(i + ringBufferIndex) % BUFFER_SIZE] * 100, width * (float)(i+1)/BUFFER_SIZE, height / 2 + ringBuffer[(i + 1 + ringBufferIndex) % BUFFER_SIZE] * 100);
    i += 10;
  }
  

}

void keyPressed() {
  if (key == 'r') {
    secretBuffer = new float[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE - 1; i++) {
      secretBuffer[i] = ringBuffer[(i + ringBufferIndex) % BUFFER_SIZE];
    }
  }
}

void updateRingBuffer() {
  // Fill the ring buffer with the latest audio samples
  for (int i = 0; i < in.bufferSize(); i++) {
    ringBuffer[ringBufferIndex++] = in.mix.get(i);
    ringBufferIndex %= BUFFER_SIZE; // Wrap around using the constant
  }
}

float compareBuffers(float[] buffer1, float[] buffer2) {
  // Compute the absolute difference between two buffers
  float totalDifference = 0;
  for (int i = 0; i < BUFFER_SIZE; i++) {
    totalDifference += abs(buffer1[i] - buffer2[i]);
  }
  return totalDifference;
}

void stop() {
  in.close();
  minim.stop();
  super.stop();
}
