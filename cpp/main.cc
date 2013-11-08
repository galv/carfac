/*
Author: Daniel Galvez

This code acts as an implementation of a main method in order to take a wav file as input and then output a carfacogram, just like CARFAC_ogram.m

Pseudo code:



*/

#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include "carfac.h"
//#include "carfac_test.h"
#include "carfac_test.cc"
//#include "./additions/sndfile-to-text.c"
//#include "./additions/sndfile-to-text.h"
#include <sstream>
using namespace std;

void readWav(string wavFile){
  string wavOutput = wavFile;
  /*
  string wavOutput =  wavFile.replace(".wav");
  string wavOutput = wavFile.substr(
  stringstream ss;
  ss << "sndfile_to_text " << wavFile <<" " <<
  */
  // system("./additions/sndfile-to-text.c ./testingFiles/binaural_test.wav ./testingFiles/binaural_test.txt");
  system("./additions/sndfile-to-text ./testingFiles/binaural_test.wav ./testingFiles/binaural_test.txt"); 
  return;
}



int main(){

  string relativeDir = "" /*"/testingFiles/"*/;
  string wavFile = "binaural_test.wav";
  readWav(wavFile);
  std::cout << "testing!\n";

  int num_ears = 0;
  int num_samples = 0;
  ArrayXX sound_data = LoadAudio("binaural_test.txt", 0, num_ears); 

  //int test_signal = wav * 0.0316; 
  return 0;
	 }


