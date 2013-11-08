// Copyright 2013 The CARFAC Authors. All Rights Reserved.
// Author: Alex Brandmeyer
//
// This file is part of an implementation of Lyon's cochlear model:
// "Cascade of Asymmetric Resonators with Fast-Acting Compression"
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#include "carfac.h"

#include <math.h>
#include <string>
#include <vector>

#include <Eigen/Core>

#include "gtest/gtest.h"

#include "agc.h"
#include "car.h"
#include "common.h"
#include "ihc.h"
//#include "test_util.h"
//#include "carfac_test.cc"

#include <fstream>

using std::vector;
using namespace std;



// Location of the text files produced by 'CARFAC_GenerateTestData.m' for        
// comparing the ouput of the Matlab implementation with the C++ one.            
static const char* kTestDataDir = "../test_data/";
static const char* languageDirectory = "../../languagefiles/textfiles/";


// Reads a size rows by columns Eigen matrix from a text file written            
// using the Matlab dlmwrite function.                                           
ArrayXX LoadMatrix(const std::string& filename, int rows, int columns) {
  std::string fullfile = languageDirectory + filename;
  std::ifstream file(fullfile.c_str());
  ArrayXX output(rows, columns);
  CARFAC_ASSERT(file.is_open());
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < columns; ++j) {
      file >> output(i, j);
    }
  }
  file.close();
  return output;
}

void WriteMatrix(const std::string& filename, const ArrayXX& matrix) {
  std::string fullfile = languageDirectory + filename;
  std::ofstream ofile(fullfile.c_str());
  const int kPrecision = 9;
  ofile.precision(kPrecision);
  if (ofile.is_open()) {
    Eigen::IOFormat ioformat(kPrecision, Eigen::DontAlignCols);
    ofile << matrix.format(ioformat) << std::endl;
  }
  cout << "Output location: " << fullfile << "\n";
  ofile.close();
}


// Writes the CARFAC NAP output to a text file.
void WriteNAPOutput(const CARFACOutput& output, const std::string& filename,
                    int ear) {
  WriteMatrix(filename, output.nap()[ear].transpose());
}



// Reads a two dimensional vector of audio data from a text file               
// containing the output of the Matlab wavread() function.                     
  
ArrayXX LoadAudio(const std::string& filename, int num_samples, int num_ears) {
  // The Matlab audio input is transposed compared to the C++.                   
  return LoadMatrix(filename, num_samples, num_ears).transpose();
}



int main(int argc, char* argv[]){

  CARParams car_params_;
  IHCParams ihc_params_;
  AGCParams agc_params_;
  bool open_loop_ = false;
  string directory =  "../../data/Khmer/";
  string wavDirectory = directory + "wav/";
  string txtDirectory = directory + "txt/";

  std::string audioTextFile = argv[1];//"binaural_test";                       
  system(("./sndfile-to-text " + wavDirectory + audioTextFile  + ".wav " + txtDirectory  + audioTextFile + ".txt").c_str());
                                                  
  int num_samples = atoi(argv[4]); //Number of frames/samples.
  int num_ears = 1;
  int num_channels = atoi(argv[2]);//Always one channel for single mic, right?
  FPType sample_rate = atoi(argv[3]);
  system(("tail -n+3 " + txtDirectory + audioTextFile  +".txt > " + txtDirectory + audioTextFile + ".txt").c_str()); //Remove the header.
  ArrayXX sound_data = LoadAudio(txtDirectory + audioTextFile + ".txt", num_samples, num_ears);

  CARFAC carfac(num_ears, sample_rate, car_params_, ihc_params_, agc_params_);
  CARFACOutput output(true, true, true, false); //Want to store only nap, right?
  carfac.RunSegment(sound_data, open_loop_, &output);
  WriteNAPOutput(output, directory + "nap/" + audioTextFile + "-nap-test.txt", 0);
  //WriteSAIOutput(output, directory + "sai/" + audioTextFile + "-sai-test.txt", 0); //Not defined in past CARFAC code.
}

