//
//  main.cpp
//  todo
//
//  Created by Harry O'Brien on 23/02/2020.
//  Copyright © 2020 Harry O'Brien. All rights reserved.
//

#include <iostream>
#include <fstream>

char fileName[] = "/Users/HarryOB/Todo/TodoList.txt";
char tempFileName[] = "/Users/HarryOB/Todo/temp.txt";

static void show_usage(std::string name = "./todo")
{
    std::cerr << "Usage: " << name << " <option(s)> TASK"
              << "Options:\n"
              << "\t-l, --list ITEM\t\tList all todo items\n"
              << "\t-a, --add ITEM\t\tAdd item to list\n"
              << "\t-d,--del INDEX OF ITEM\tDelete the item at the given index\n"
              << "\t-h,--help \tShow this usage message\n"
              << std::endl;
}

bool is_empty(std::ifstream& pFile)
{
    return pFile.peek() == std::ifstream::traits_type::eof();
}

void listAll() {
  std::string line;
  std::ifstream todoFile(fileName, std::ios::in);

  if (is_empty(todoFile))
    std::cerr << "Todo list is empty!" << std::endl;
  else {
    int index = 1;
    std::cout << "Here's your to-do list..." << std::endl;
    while(getline(todoFile, line)) std::cout << "\t" << index++ << ": " << line << std::endl;
    std::cout << std::endl;
  }

  todoFile.close();
}

void add(std::string item) {
  std::ofstream todoFile(fileName, std::ios::app | std::ios::out);

  if(todoFile.is_open()) todoFile << item << std::endl;

  todoFile.close();
}

void deleteItemAt(int index) {
  if(index == 0) {
    show_usage();
    return;
  }

  // open file in read mode or in mode
  std::ifstream todoFile(fileName);

  // open file in write mode or out mode
  std::ofstream ofs;
  ofs.open(tempFileName, std::ofstream::out);

  // loop getting single characters
  int line_no = 1;
  bool itemRemoved = false;
  std::string line;
  while(getline(todoFile, line)) {
    if (line_no++ != index) ofs << line << std::endl;
    else itemRemoved = true;
  }

  // closing output file
  ofs.close();

  // closing input file
  todoFile.close();

  // remove the original file
  remove(fileName);

  // rename the file
  rename(tempFileName, fileName);

  if (!itemRemoved) {
    std::cerr << "No item existed at index " << index << std::endl;
  }
}

int main(int argc, char* argv[]) {

  // Validate correct no. of args
  if (argc > 3) {
    show_usage(argv[0]);
    return 1;
  }

  // If no CLIs, just list the todo items
  if (argc == 1) {
    listAll();
    return 0;
  }

  // Parse CLI
  for (int i = 1; i < argc; ++i) {
      std::string arg = argv[i];
      if ((arg == "-h") || (arg == "--help")) {
          show_usage(argv[0]);
          return 0;
      }
      else if ((arg == "-d") || (arg == "--del")) {
          if (i + 1 < argc) { // Make sure we aren't at the end of argv!
              deleteItemAt(atoi(argv[++i])); // Increment 'i' so we don't get the argument as the next argv[i].
          } else {
              // No args for -d
              std::cerr << "--del requires a numerical argument." << std::endl;
              return 1;
          }
      }
      else if ((arg == "-a") || (arg == "--add")) {
          if (i + 1 < argc) { // Make sure we aren't at the end of argv!
               add(argv[++i]); // Increment 'i' so we don't get the argument as the next argv[i].
          } else {
              // No args for -a
              std::cerr << "--add requires one argument." << std::endl;
              return 1;
          }
      }
      else if ((arg == "-l") || (arg == "--list")) {
          listAll();
      }
      else {
        show_usage(argv[0]);
      }
  }

  return 0;
}
