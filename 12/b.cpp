#include "utils.h"

long long solve(vector<string> &lines) {
  vector<vector<char>> data = readMatrix(lines);

  const int X = data[0].size(), Y = data.size();
  int start, end;
  for (size_t y = 0; y < data.size(); ++y)
    for (size_t x = 0; x < data[y].size(); ++x) {
      if ('S' == data[y][x]) {
        start = zip(X, x, y);
        data[y][x] = 'a';
      } else if ('E' == data[y][x]) {
        end = zip(X, x, y);
        data[y][x] = 'z';
      }
      data[y][x] -= 'a';
    }

  const vector<ll> dists = dijkstra(
      [&](const int vertex) {
        int ox, oy;
        tie(ox, oy) = unzip(X, vertex);

        vector<pair<int, ll>> result;
        for (const auto &[x, y] : {pii(ox - 1, oy), pii(ox + 1, oy),
                                   pii(ox, oy - 1), pii(ox, oy + 1)})
          if (0 <= x && x < X && 0 <= y && y < Y)
            if (data[oy][ox] - data[y][x] <= 1)
              result.push_back({zip(X, x, y), 1});
        return result;
      },
      Y * X, end);

  ll min1 = LONG_LONG_MAX;
  for (size_t y = 0; y < data.size(); ++y)
    for (size_t x = 0; x < data[y].size(); ++x) {
      if (data[y][x] == 0) min1 = min(min1, dists[zip(X, x, y)]);
    }
  return min1;
}