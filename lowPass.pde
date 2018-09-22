class OnePole {
  float a0 = 1.0;
  float b1 = 0.0;
  float z1 = 0.0;
  float pi_2 = 6.28318530717959;

  OnePole(float frequency) {
    setFreq(frequency);
  }
  void setFreq(float frequency) {
    b1 = exp(-2.0 * pi_2 * frequency);
    a0 = 1.0 - b1;
  }
  float process(float in) {
      return z1 = in * a0 + z1 * b1;
  }
}
