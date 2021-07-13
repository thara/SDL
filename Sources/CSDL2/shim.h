#if (__arm64__ && __APPLE__)
#include "/opt/homebrew/include/SDL2/SDL.h"
#elif __APPLE__
#include "/usr/local/include/SDL2/SDL.h"
#else
#include <SDL2/SDL.h>
#endif
