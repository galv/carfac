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
  wav_fn = 'Khmer students.wav'  % 'BNG WAL audio.wav';
  fig_no = j;
  
  [wav fs] = wavread([dir, wav_fn]);
  wav = wav(1:101);%Speed up testing.
%   wav = wav(round(trim*fs) + (1:fs));  % one second
  
  test_signal = wav * 0.0316;
  test_signal = test_signal(:, 1);  % mono
  
  % modest pre-emphasis:
  test_signal = filter([1, -0.80], 1, test_signal);
  
  
  
  agc_plot_fig_num = 0;
  n_ears = 1;
  CF_struct = CARFAC_Design(n_ears);  % default design
  CF_struct = CARFAC_Init(CF_struct);
  
  [CF_struct, nap_decim, pitchogram, sai] = CARFAC_SAI_Run ...
    (CF_struct, test_signal, 110);  % 110 for 5 ms samples
  
  sai
  
  nap_decim = smooth1d(nap_decim, 0.5);
  
  n_ch = CF_struct.n_ch;
%{
  nap_decim2 = interp1(nap_decim', (1:0.5:n_ch))';
  nap_decim2 = max(0, nap_decim2);
  nap_decim2 = smooth1d(nap_decim2', 0.5)';
  nap_decim2 = smooth1d(nap_decim2, 0.5);
 %}
  % Make double the number of samples in the frequency dimension, smoothly.
%   nap_decim2 = interp1(nap_decim', (1:0.5:n_ch))';
  %nap_decim2 = nap_decim(:, floor(1:0.5:(n_ch+0.5)));
  nap_decim2 = nap_decim;
  nap_decim2 = max(0, nap_decim2);
  % smooth a bit in both directions:
%   nap_decim2 = smooth1d(nap_decim2', 0.5)';
  nap_decim2 = filter([0.2, 0.6, 0.2], 1, nap_decim2')';
%   nap_decim2 = smooth1d(nap_decim2, 0.5);
  nap_decim2 = filter([0.2, 0.6, 0.2], 1, nap_decim2);
  mono_max = max(nap_decim2(:));
 
  
%{  
  pitchogram2 = smooth1d(pitchogram(:, end:-1:1)', 1)';
  np = 140;
  pitchogram2 = interp1(pitchogram2', (1:np) + 2.5*np*((1:np)/np).^2)';
  pmono_max = max(pitchogram2(:));
  %}

  % Smooth and reverse the pitchogram.
%   pitchogram2 = smooth1d(pitchogram(:, end:-1:1)', 1)';
  %%%%%%%%%%%%%pitchogram2 = filter([1 4 6 4 1]/16, 1, pitchogram(:, end:-1:1)')';
  pitchogram2 = pitchogram
  np = 140;
  % Compress the pitch lag axis nonlinearly.
%   pitchogram2 = interp1(pitchogram2', (1:np) + 2.5*np*((1:np)/np).^2)';
  pitchogram2 = pitchogram2(:, floor((1:np) + 2.5*np*((1:np)/np).^2));
  pmono_max = max(pitchogram2(:));

max(0, nap_decim2')/mono_max;
max(0, pitchogram2')/pmono_max;

  % Display combined results for 1 ears:
  figure(fig_no)
  set(gca, 'Position', [.3, .1, .4, .8])
  image(63 * ([max(0, nap_decim')/mono_max; max(0, pitchogram')/pmono_max] .^ 0.5))
  title(['CARFAC ogram:  ', wav_fn])
  colormap(1 - gray);
%   set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  
  print('-deps', [dir, wav_fn, '.eps']);

end


% Display combined results for 1 ears:
%{
figure(fig_no)
set(gca, 'Position', [.1, .3, .8, .2])
image(63 * ([max(0, nap_decim2(1:2400, :)')/mono_max; max(0, pitchogram2(1:2400, :)')/pmono_max] .^ 0.5))
title(['CARFAC ogram:  ', wav_fn])
colormap(1 - gray);
set(gca, 'XTick', [])
set(gca, 'YTick', [])

print('-deps', [dir, 'KHM_student1.eps']);

figure(fig_no)
set(gca, 'Position', [.1, .3, .8, .2])
image(63 * ([max(0, nap_decim2(3200:5500, :)')/mono_max; max(0, pitchogram2(3200:5500, :)')/pmono_max] .^ 0.5))
title(['CARFAC ogram:  ', wav_fn])
colormap(1 - gray);
set(gca, 'XTick', [])
set(gca, 'YTick', [])

print('-deps', [dir, 'KHM_student2.eps']);

figure(fig_no)
set(gca, 'Position', [.1, .3, .8, .2])
image(63 * ([max(0, nap_decim2(6000:(end-100), :)')/mono_max; max(0, pitchogram2(6000:(end-100), :)')/pmono_max] .^ 0.5))
title(['CARFAC ogram:  ', wav_fn])
colormap(1 - gray);
set(gca, 'XTick', [])
set(gca, 'YTick', [])

print('-deps', [dir, 'KHM_student3.eps']);
}%
