#include "utils.h"
#include "Directory.h"

long long rec(shared_ptr<Directory> directory,
              const long long upperLimit = 100'000) {
  long long result = (directory->size() <= upperLimit) ? directory->size() : 0;
  for (const auto &[name, dir] : directory->getDirs()) {
    if (".." != name) {
      result += rec(dir);
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
  return rec(dir);
}

// while ((len = getline(&buf, &bufsz, f)) > 1) switch (buf[0]) {
//     case '$':             // command
//       if (buf[2] == 'c')  // no action for command "ls", only for "cd"
//         switch (buf[5]) {
//           case '/':
//             cur = root = append(NULL, 0);
//             break;  // $ cd /
//           case '.':
//             cur = cur->up;
//             break;  // $ cd ..
//           default:
//             cur = append(cur, 0);
//             break;  // $ cd dirname
//         }
//     case 'd':
//       break;  // no action for listing "dir dirname"
//     default:
//       append(cur, strtoul(buf, NULL, 10));
//       break;  // listing "123 filename"
//   }