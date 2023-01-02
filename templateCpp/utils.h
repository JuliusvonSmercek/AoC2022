#include <bits/stdc++.h>
using namespace std;

#define cin ss
typedef long long ll;
typedef long long ull;
typedef pair<int, int> pii;

// TODO: printQ
// TODO: split, splitLines
// TODO: multiple samples

long long solve(vector<string> &lines);

bool isSample;

int main(int argc, char **argv) {
  ios::sync_with_stdio(false);
  if (argc != 2) {
    cerr << "error: missing input file" << endl;
    return 1;
  } else if ("./sample.txt" != string(argv[1]) &&
             "./input.txt" != string(argv[1])) {
    cerr << "error: input file should be './sample.txt' or './inut.txt'"
         << endl;
    return 1;
  }
  isSample = ("./sample.txt" == string(argv[1]));
  ifstream infile(argv[1]);
  if (!infile) {
    cerr << "error opening file" << endl;
    return 1;
  }

  string line;
  vector<string> lines;
  while (getline(infile, line, '\n')) {  // THIS WORKS ONLY FOR LF NOT CRLF !!!
    lines.push_back(line);
  }
  cout << solve(lines) << endl;
  infile.close();
}

template <typename T>
ostream &operator<<(ostream &os, const vector<T> &container) {
  os << '[';
  bool isNotFirst = false;
  for (const auto &data : container) {
    if (isNotFirst) os << ", ";
    isNotFirst = true;
    os << data;
  }
  os << ']';
  return os;
}

template <typename T>
ostream &operator<<(ostream &os, const list<T> &container) {
  os << '[';
  bool isNotFirst = false;
  for (const auto &data : container) {
    if (isNotFirst) os << ", ";
    isNotFirst = true;
    os << data;
  }
  os << ']';
  return os;
}

template <typename F, typename G>
ostream &operator<<(ostream &os, const set<F, G> &container) {
  os << '{';
  bool isNotFirst = false;
  for (const auto &data : container) {
    if (isNotFirst) os << ", ";
    isNotFirst = true;
    os << data;
  }
  os << '}';
  return os;
}

template <typename F, typename G>
ostream &operator<<(ostream &os, const map<F, G> &container) {
  os << '[';
  bool isNotFirst = false;
  for (const auto &[k, v] : container) {
    if (isNotFirst) os << ", ";
    isNotFirst = true;
    os << k << ": " << v;
  }
  os << ']';
  return os;
}

template <typename T>
ostream &operator<<(ostream &os, const stack<T> &container) {
  os << '<';
  bool isNotFirst = false;
  while (!container.empty()) {
    if (isNotFirst) os << ", ";
    isNotFirst = true;
    os << container.top();
    container.pop();
  }
  os << '>';
  return os;
}

template <typename T>
ostream &operator<<(ostream &os, const queue<T> &container) {
  os << '<';
  bool isNotFirst = false;
  while (!container.empty()) {
    if (isNotFirst) os << ", ";
    isNotFirst = true;
    os << container.front();
    container.pop();
  }
  os << '>';
  return os;
}

template <typename F, typename G>
ostream &operator<<(ostream &os, const pair<F, G> &container) {
  os << '(';
  os << get<0>(container);
  os << ", ";
  os << get<1>(container);
  os << ')';
  return os;
}

template <typename T>
vector<vector<T>> readInput(const vector<string> &lines) {
  vector<vector<T>> result;
  vector<T> temp;
  for (const string &line : lines) {
    if (0 == line.size()) {
      if (0 < temp.size()) {
        result.push_back(temp);
      }
      temp.clear();
    } else {
      stringstream ss(line);
      T item;
      while (ss >> item) temp.push_back(item);
    }
  }
  if (0 < temp.size()) {
    result.push_back(temp);
  }
  return result;
}

vector<vector<char>> readMatrix(const vector<string> &lines) {
  vector<vector<char>> result(lines.size(), vector<char>(lines[0].size(), '%'));
  for (size_t row = 0; row < lines.size(); ++row)
    for (size_t col = 0; col < lines[row].size(); ++col)
      result[row][col] = lines[row][col];
  return result;
}

set<char> chars(const string &str) { return set<char>(str.begin(), str.end()); }

template <typename F, typename G>
vector<char> intersection(const F &container1, const G &container2) {
  vector<char> result;
  set_intersection(container1.begin(), container1.end(), container2.begin(),
                   container2.end(), std::back_inserter(result));
  return result;
}

template <typename T>
set<T> range(const T a, const T b) {
  set<T> result;
  for (T i = a; i <= b; ++i) {
    result.insert(i);
  }
  return result;
}

vector<string> split(const string &str, const string &delimiter = " ") {
  vector<string> result;
  size_t last = 0, next = 0;
  while ((next = str.find(delimiter, last)) != string::npos) {
    result.push_back(str.substr(last, next - last));
    last = next + 1;
  }
  result.push_back(str.substr(last));
  return result;
}

void printQ(queue<ll> q) {
  vector<ll> v;
  while (!q.empty()) {
    v.emplace_back(move(q.front()));
    q.pop();
  }
  cout << v << endl;
}

vector<ll> dijkstra(const function<vector<pair<int, ll>>(int)> neighbours,
                    const int N, const int start) {
  vector<ll> dist(N, numeric_limits<ll>::max() / 2);
  priority_queue<pair<ll, int>, vector<pair<ll, int>>, greater<pair<ll, int>>>
      pq;

  pq.push({0, start});
  while (pq.size()) {
    ll d;
    int v;
    tie(d, v) = pq.top();
    pq.pop();
    if (dist[v] <= d) continue;
    dist[v] = d;
    for (const auto &[id, distance] : neighbours(v))
      pq.push({d + distance, id});
  }
  return dist;
}

int zip(const int N, const int x, const int y) { return N * y + x; }

pair<int, int> unzip(const int N, const int vertex) {
  return {vertex % N, vertex / N};
}