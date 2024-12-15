# Audio driven Passphrases

## The Problem
Audio-driven passphrases solve issues like weak or reused passwords, vulnerability to phishing and keylogging, and accessibility challenges. They leverage unique voice characteristics and dynamic elements to resist replay attacks and enhance security. Additionally, they improve usability by reducing reliance on memorization and offer a more inclusive authentication method for diverse users.

## The Idea
You can record a passphrase with your own voice and unlock it by repeating this phrase.

1. Install `minim` in Processing 4
2. Start the sketch
3. use 'r' to record your current voice as a passphrase


## Why This is Smart
### Human-Centric Security:
Voices are unique to every individual, yet no sensitive biometric data is stored. The system relies on frequency-based analysis, which means no raw audio files are saved, significantly reducing privacy risks.
### Lightweight & Accessible:
Unlike complex biometric systems (e.g., fingerprint or face scans), this solution requires minimal computational power. It can run on any device with a basic microphone, making it ideal for low-cost hardware and IoT devices.
### Dynamic Passcodes:
The passcode changes based on the user's speech patterns. This makes brute-force attacks nearly impossible while still being easy for the user to replicate through natural speech.
### Noise Tolerance:
By filtering frequencies outside the human vocal range, the system ignores background noise and focuses solely on the voice, making it effective even in non-ideal conditions.
### No Biometric Database:
Unlike traditional biometrics, this solution doesn’t require sensitive data storage. Each passcode is generated in real-time, reducing liability risks for businesses.
### Scalable for Diverse Use Cases:
This technology is versatile:
- Secure IoT devices (e.g., smart locks, appliances).
- Authenticate payments in voice-enabled assistants.
- Enable password-less logins for apps and devices.
### Cost-Effective Implementation:
Voice frequency analysis uses simple algorithms (like FFT) that can be integrated into most existing hardware and software systems. There’s no need for specialized sensors or expensive infrastructure.