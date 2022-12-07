#pragma once
#include <bits/stdc++.h>
using namespace std;

class Directory : public std::enable_shared_from_this<Directory> {
 private:
  map<string, shared_ptr<Directory>> dirs;
  long long fileSize = 0, dirSize;

 public:
  Directory() {}

  Directory(shared_ptr<Directory> root) { dirs.insert({"..", root}); }

  shared_ptr<Directory> rootFolder() {
    return dirs.contains("..") ? dirs.at("..")->rootFolder()
                               : shared_from_this();
  }

  shared_ptr<Directory> getFolder(const string &path) { return dirs.at(path); }

  void makeFolder(const string &path) {
    dirs.insert({path, make_shared<Directory>(shared_from_this())});
  }

  void addFile(const long long size) { fileSize += size; }

  long long resize() {
    dirSize = fileSize;
    for (const auto &[name, dir] : dirs)
      if (".." != name) dirSize += dir->resize();
    return dirSize;
  }

  long long size() { return dirSize; }

  const map<string, shared_ptr<Directory>> &getDirs() const { return dirs; }

  void debug() {
    cout << "files: " << fileSize << ", dirs: {";
    bool isNotFirst = false;
    for (const auto &[key, value] : dirs) {
      if (isNotFirst) cout << ", ";
      isNotFirst = true;
      cout << key;
    }
    cout << "}" << endl;
  }
};