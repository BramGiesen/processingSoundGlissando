import processing.sound.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

OnePole onePole;
Reverb reverb;
LowPass lowPass;

float[] boids;

boolean firstOSC = false;
//==============================================================================
float pi_2 = 6.28318530717959;
float lfo;


float phase = 0;
float amplitude = 0.5;
float frequency = 80;
//==============================================================================
float[] lFreq;
OnePole[] onePoles; // Array of lowPass filters
SinOsc[] sawWaves; // Array of sines
float[] sineFreq; // Array of frequencies
float[] freq;
int[] oscX;
int numSines = 0; // Number of oscillators to use
int prevNumSines = 0;
int count = 0;

int initList = 20;

float[] notes = {48, 50, 51, 53, 54, 55, 57, 58,
  60, 62, 63, 65, 66, 67, 69, 70,
  72, 74, 75, 77, 78, 79, 81, 82};

void setup() {
  size(640, 360);
  background(255);

  // frameRate(25);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);

  onePoles = new OnePole[initList];
  sawWaves = new SinOsc[initList]; // Initialize the oscillators
  sineFreq = new float[initList]; // Initialize array for Frequencies
  lFreq = new float[initList];
  freq = new float[initList];
  reverb = new Reverb(this);
  lowPass = new LowPass(this);
  oscX = new int[initList];

  reverb.room(0.1);
}

void addWave(){
    println("wave added");
    //create the onePoles
    onePoles[count] = new OnePole((300.0 + ( count * 10)) / 44100);
    // Create the oscillators
    sawWaves[count] = new SinOsc(this);
    // Start Oscillators
    sawWaves[count].play();

    // Set the amplitudes for all oscillators
    for(int i = 0; i < numSines; i++){
      //divide saws over panning
      sawWaves[count].pan(((2.0 / numSines) * count) - 1);
      // Calculate the amplitude for each oscillator
      float sineVolume = ((1.0 / numSines) / (count + 1)) * 0.2;
      sawWaves[i].amp(sineVolume);
    }

    reverb.process(sawWaves[count]);
    count = count + 1;
}

void draw() {

  // lfo = sin( phase * pi_2 );
  // phase += frequency / 44100;
  //
  if(numSines != prevNumSines){
    addWave();
    prevNumSines = numSines;
  }

  for (int i = 0; i < numSines; i++) {

    if(firstOSC){
        lFreq[i] = onePoles[i].process(freq[i]);
        sineFreq[i] = lFreq[i] + (220 * 0);
        sawWaves[i].freq(sineFreq[i]);

        freq[i] = mtof(notes[oscX[i]]);
    }
  }
}

float mtof(float midiPitch) {
  return pow(2.0,(midiPitch-69.0)/12.0) * 440.0;
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  numSines = theOscMessage.get(0).intValue();
  int listLenght  = theOscMessage.get(1).intValue;

  if(theOscMessage.get(0).intValue() > 0){
    for(int i = 2; i < theOscMessage.get(0).intValue(); i++){
      for(int y = 0; y < listLenght; y++){
        oscX[i-1][y] = (((y-1) * 3) + round(map(theOscMessage.get(y + 1).floatValue(), 0, 1280, 0, 23))) % 24;
    }
  }
}
  firstOSC = true;
}
