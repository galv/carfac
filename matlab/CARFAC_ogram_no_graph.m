% Copyright 2012, Google, Inc.
% Author: Richard F. Lyon
%
% This Matlab file is part of an implementation of Lyon's cochlear model:
% "Cascade of Asymmetric Resonators with Fast-Acting Compression"
% to supplement Lyon's upcoming book "Human and Machine Hearing"
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

%% Test/demo hacking for CARFAC Matlab stuff:

clear variables

%%

% wav_fn = 'plan.wav';
% wav_fn = 'mixsound.wav';

dir = 'Language_Learning/khmersounds/' % 'Language_Learning/bengali/' % 'Language_Learning/Chinese/';
basename = 'khm01-01-0';  % 'bng01-01-'; % 'Chinese '

nums = 0  % 1:8;  % 0; % 21:28;  %[0 1 3 4];
trims = 0;  % 0.05*[1 1 1 1 1 1 1 1]  % 0;  %[0.5 0.3 0.6 0.4 0.4 0.5 0.3 0.2];  % [0.2 0.6 0.8 0.6];
for j = 1:length(nums)
  trim = trims(j);
%   wav_fn = [basename, num2str(nums(j)), '.wav'];
wav_fn = 'khm01-01-01.wav';  % 'Khmer students.wav'  % 'BNG WAL audio.wav';
  
  fig_no = j;
t=cputime;
[wav fs] = wavread([dir, wav_fn]);
    printf('Total cpu time: %f seconds\n', cputime-t);
%  wav = wav(round(trim*fs) + (1:fs));  % one second
  
  test_signal = wav * 0.0316;
  test_signal = test_signal(:, 1);  % mono
  
  % modest pre-emphasis:
  test_signal = filter([1, -0.80], 1, test_signal);
  
  
  
  agc_plot_fig_num = 0;
  n_ears = 1;
#error('CARFAC_Design enter');
 CF_struct = CARFAC_Design(n_ears);  % default design
#error('CARFAC_Init enter');
  CF_struct = CARFAC_Init(CF_struct);
#error('CARFAC_SAI_Run');
  [CF_struct, nap_decim, pitchogram, sai] = CARFAC_SAI_Run ...
    (CF_struct, test_signal, 110);  % 110 for 5 ms samples
#error('out of CARFAC_SAI_Run');  
  sai;
#error('out of sai');
  #nap_decim = smooth1d(nap_decim, 0.5);
end
