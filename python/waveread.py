import wave
import sys

main(argv){
waveFileName = "khm01-01-01"

wavreader =  wave.open("./../../Khmer/wav/" + waveFileName + ".wav")

numchannels =  wavreader.getnchannels()
print "channels: " + numchannels
framerate =  wavreader.getframerate()
print "framerate/samplerate: " + framerate
numframes =  wavreader.getnframes()
print "frames/samples: " + numframes
#How to run in commandline: ./main3.o wavfilename channels framerate frames
system("./../carfac/main3.o "+ 
}

    if  __name__ =='__main__':main(sys.argv)
