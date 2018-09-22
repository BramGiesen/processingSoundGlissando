import processing.sound.*;

OnePole onePole;

//==============================================================================
float pi_2 = 6.28318530717959;
float lfo;

float phase = 0;
float amplitude = 0.5;
float frequency = 80;
//==============================================================================

// float OnePole onePole1;
float freq = 440;
float[] lFreq;
OnePole[] onePoles; // Array of lowPass filters
SawOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use

void setup() {
  size(640, 360);
  background(255);

  onePoles = new OnePole[numSines];
  sineWaves = new SawOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies
  lFreq = new float[numSines];

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    //create the onePoles
    onePoles[i] = new OnePole((50.0 + ( i * 10)) / 44100);
    // Create the oscillators
    sineWaves[i] = new SawOsc(this);
    // Set panning
    sineWaves[i].pan(random(-1.0,1.0));
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

void draw() {

  lfo = sin(phase * pi_2 );
  phase += frequency / 44100;

  float rand = random(500);
  if(rand > 490){
    freq = random(50) + 60;
}
  for (int i = 0; i < numSines; i++) {
    lFreq[i] = onePoles[i].process(freq);
    sineFreq[i] = lFreq[i] + 1 + (i * 0.050909091);
    // Set the frequencies for all oscillators
    sineWaves[i].freq(sineFreq[i]);
  }
}
