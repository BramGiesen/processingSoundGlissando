import processing.sound.*;

OnePole onePole;
Reverb reverb;

//==============================================================================
float pi_2 = 6.28318530717959;
float lfo;

float phase = 0;
float amplitude = 0.5;
float frequency = 80;
//==============================================================================

// float OnePole onePole1;
// float freq = 440;
float[] lFreq;
OnePole[] onePoles; // Array of lowPass filters
SawOsc[] sawWaves; // Array of sines
float[] sineFreq; // Array of frequencies
float[] freq;
int numSines = 5; // Number of oscillators to use

void setup() {
  size(640, 360);
  background(255);

  onePoles = new OnePole[numSines];
  sawWaves = new SawOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies
  lFreq = new float[numSines];
  freq = new float[numSines];
  reverb = new Reverb(this);

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    //create the onePoles
    onePoles[i] = new OnePole((50.0 + ( i * 10)) / 44100);
    // Create the oscillators
    sawWaves[i] = new SawOsc(this);
    //divide saws over panning
    sawWaves[i].pan(((2.0 / numSines) * i) - 1);
    // Start Oscillators
    sawWaves[i].play();
    // Set the amplitudes for all oscillators
    sawWaves[i].amp(sineVolume);

    freq[i] = random(50, 110);

    reverb.process(sawWaves[i]);

  }
  reverb.room(.1);
  // reverb.damp(1.0);

}

void draw() {

  lfo = sin(phase * pi_2 );
  phase += frequency / 44100;

  for (int i = 0; i < numSines; i++) {
    lFreq[i] = onePoles[i].process(freq[i]);
    float x = pow(1.0594630943, i * i * i);
    sineFreq[i] = lFreq[i] + (55 * x);
    // Set the frequencies for all oscillators
    sawWaves[i].freq(sineFreq[i]);
    // reverb.process(sawWaves[i]);
    float rand = random(1000);
    if(rand > 980){
      freq[i] = 55 * pow(1.0594630943,random(30));
    }
  }
}
