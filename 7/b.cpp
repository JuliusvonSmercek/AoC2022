#include "utils.h"
#include "Directory.h"

long long rec(shared_ptr<Directory> directory, const long long lowerLimit) {
  long long result =
      (lowerLimit <= directory->size()) ? directory->size() : LONG_LONG_MAX;
  for (const auto &[name, dir] : directory->getDirs()) {
    if (".." != name) {
      result = min(result, rec(dir, lowerLimit));
    }
  }
  return result;
}

long long solve(vector<string> &lines) {
  Directory root;
  shared_ptr<Directory> dir(&root);
  for (const string &line : lines) {
    switch (line[0]) {
      case '$': {
        if ("cd" == split(line)[1]) {
          const string path = split(line)[2];
          dir = ("/" == path) ? dir->rootFolder() : dir->getFolder(path);
        }
        break;
      }
      case 'd': {
        dir->makeFolder(split(line)[1]);
        break;
      }
      default: {
        dir->addFile(stoll(line));
        break;
      }
    }
  }
  dir = dir->rootFolder();
  dir->resize();
  return rec(dir, 30000000 - (70000000 - dir->size()));
}