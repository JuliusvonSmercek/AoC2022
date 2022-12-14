#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  vector<vector<bool>> matrix(1000, vector<bool>(1000, false));

  for (string &line : lines) {
    int ox = -1, oy = -1;
    for (const string &pairs : split(line, " -> ")) {
      const vector<string> xy = split(pairs, ",");
      int x = stoi(xy[0]), y = stoi(xy[1]);
      if (ox != -1) {
        for (int xi = min(x, ox); xi <= max(x, ox); ++xi) {
          matrix[y][xi] = true;
        }
        for (int yi = min(y, oy); yi <= max(y, oy); ++yi) {
          matrix[yi][x] = true;
        }
      }
      ox = x, oy = y;
    }
  }

  int maxY = 0;
  for (int y = 0; y < matrix.size(); ++y)
    for (int x = 0; x < matrix.size(); ++x)
      if (matrix[y][x]) maxY = y;

  int spawnx = 500, spawny = 0;
  int posx = spawnx, posy = spawny;
  while (posy < maxY) {
    ++result;
    posx = spawnx, posy = spawny;
    bool success = true;
    while (success && posy < maxY) {
      if (matrix[posy + 1][posx] == false)
        ++posy;
      else if (matrix[posy + 1][posx - 1] == false)
        ++posy, --posx;
      else if (matrix[posy + 1][posx + 1] == false)
        ++posy, ++posx;
      else
        success = false;
    }
    matrix[posy][posx] = true;
  }
  --result;
  return result;
}