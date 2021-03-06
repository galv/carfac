// Copyright 2006-2010, Thomas Walters
//
// AIM-C: A C++ implementation of the Auditory Image Model
// http://www.acousticscale.org/AIMC
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

/*! \file
 *  \brief ERB calculations
 */

/*! \author: Thomas Walters <tom@acousticscale.org>
 *  \date 2010/01/23
 *  \version \$Id: ERBTools.h 51 2010-03-30 22:06:24Z tomwalters $
 */

#ifndef AIMC_SUPPORT_ERBTOOLS_H_
#define AIMC_SUPPORT_ERBTOOLS_H_

#include <cmath>

namespace aimc {
class ERBTools {
 public:
  static float Freq2ERB(float freq) {
    return 21.4f * log10(4.37f * freq / 1000.0f + 1.0f);
  }

  static float Freq2ERBw(float freq) {
    return 24.7f * (4.37f * freq / 1000.0f + 1.0f);
  }

  static float ERB2Freq(float erb) {
    return (pow(10, (erb / 21.4f)) - 1.0f) / 4.37f * 1000.0f;
  }
};
}

#endif  // AIMC_SUPPORT_ERBTOOLS_H_
