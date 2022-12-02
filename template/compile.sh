# in bashrc
compile() {
  g++ -Wall -Wno-unknown-pragmas -Wextra -Wconversion -Wshadow -fsanitize=undefined,address -D_GLIBCXX_DEBUG -std=c++20 -g $1 -o program.out && ./program.out ./sample.txt && ./program.out ./input.txt && rm program.out
}

compileFast() { # -O2 not used for compile speed
  g++ -Wall -Wno-unknown-pragmas -Wextra -Wconversion -Wshadow -std=c++20 -g $1 -o program.out && ./program.out ./sample.txt && ./program.out ./input.txt && rm program.out
}