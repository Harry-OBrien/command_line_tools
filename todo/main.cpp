//
//  main.cpp
//  todo
//
//  Created by Harry O'Brien on 23/02/2020.
//  Copyright © 2020 Harry O'Brien. All rights reserved.
//

#include <iostream>
#include <fstream>

// TODO: Edit a current todo item (i.e. for spelling)
// TODO: Make certain tasks important (Will stand out when list is outputted)
// TODO: Make certain tasks blocked by others -> Parent child esque
// TODO: Have 'undo' tool which removes the last action done
// TODO: Ability to have multiple to-do lists, and cmd to change between them

char fileName[] = "/Users/HarryOB/Todo/TodoList.txt";
char tempFileName[] = "/Users/HarryOB/Todo/temp.txt";

static void show_usage(std::string name = "./todo") {
	std::cerr << "Usage: " << name << " [<option(s)>] TASK\n"
	<< "Default (No arguments): -l\n"
	<< "Default (No params): -a ITEM\n"
	<< "Options:\n"
	<< "\t-l, --list ITEM\t\t\t\tList all to-do items\n"
	<< "\t-a, --add ITEM\t\t\t\tAdd item to list\n"
	<< "\t-d, --del INDEX OF ITEM\t\t\tDelete the item at the given index\n"
	<< "\t-c, --clear \t\t\t\tClear the to-do list\n"
	<< "\t-m, --move [SRC INDEX] [TARGET INDEX]\tMove item at given index to target index\n"
	<< "\t-h, --help \t\t\t\tShow this usage message\n"
	<< std::endl;
}

bool is_empty(std::ifstream& pFile){
	return pFile.peek() == std::ifstream::traits_type::eof();
}

void listAll() {
	std::string line;
	std::ifstream todoFile(fileName, std::ios::in);

	if (is_empty(todoFile))
		std::cerr << "\e[1mTodo list is empty!\e[0m" << std::endl;
	else {
		int index = 1;
		std::cout << "\e[1mHere's your to-do list...\e[0m" << std::endl;
		while(getline(todoFile, line)) std::cout << "\t" << index++ << ": " << line << std::endl;
		std::cout << std::endl;
	}

	todoFile.close();
}

void add(char** item, int argc) {
	std::ofstream todoFile(fileName, std::ios::app | std::ios::out);

	if(todoFile.is_open()) {
		for (int i = 0; i < argc; i++)
			todoFile << item[i] << " ";

		todoFile << std::endl;
	}

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
		std::cerr << "No item existed at index " << index << "." << std::endl;
	}
}

void moveItemAtIndex(int srcIndex, int destIndex) {
	if(srcIndex == 0 || destIndex == 0) {
		std::cerr << "Invalid position given." << std::endl;
		show_usage();
		return;
	}

	if (srcIndex == destIndex) {
		return;
	}

	// open file in read mode or 'in' mode
	std::ifstream iFile(fileName);

	// loop getting single characters
	int line_no = 0;
	bool itemDoesExist = false;
	std::string lineToMove;
	std::string line;
	while(getline(iFile, line)) {
		if (++line_no == srcIndex) {
			lineToMove = line;
			itemDoesExist = true;
		}
	}

  int lineCount = line_no;

	if (!itemDoesExist) {
		iFile.close();
		std::cerr << "No item existed at index " << srcIndex << "." << std::endl;
		return;
	}

	iFile.clear();
	iFile.seekg(0, std::ios::beg);

	// make sure we have a reasonable destination
	if(destIndex > lineCount || destIndex < 1) {
		destIndex = lineCount;
		std::cerr << "Destination was out of range, moving item to end of list..." << std::endl;
	}

	// open file in write mode or 'out' mode
	std::ofstream ofs;
	ofs.open(tempFileName, std::ofstream::out);

	// Now write the new list
	line_no = 0;
	while(getline(iFile, line)) {
		line_no++;
		if (line_no == srcIndex)
      continue;

    if (line_no == destIndex)
      if (lineCount == destIndex) {
        ofs << line << std::endl;
        ofs << lineToMove << std::endl;
      }
      else {
        ofs << lineToMove << std::endl;
        ofs << line << std::endl;
      }

    else
  		ofs << line << std::endl;


	}

	// closing output file
	ofs.close();

	// closing input file
	iFile.close();

	// remove the original file
	remove(fileName);

	// rename the file
	rename(tempFileName, fileName);

	listAll();
}

int main(int argc, char* argv[]) {

	// If no CLIs, just list the todo items
	if (argc == 1) {
		listAll();
		return 0;
	}

	// Parse CLI
	std::string arg = argv[1];
	// Show usage
	if ((arg == "-h") || (arg == "--help")) {
		show_usage(argv[0]);
		return 0;
	}

	// Clearing list
	else if ((arg == "-c") || (arg == "--clear")) {
		char result;
		std::cout << "\e[1mAre you sure you want to clear the list? [Y/N]\e[0m" << std::endl;
		std::cin >> result;
		if (result == 'Y' || result == 'y') {
			remove(fileName);
			return 0;
		}
		else {
			std::cout << "Cancelling!" << std::endl;
			return 0;
		}
	}

	// Removing task
	else if ((arg == "-d") || (arg == "--del")) {
		if (argc > 2) { // Make sure we aren't at the end of argv!
			deleteItemAt(atoi(argv[2])); // Increment 'i' so we don't get the argument as the next argv[i].
			return 0;
		} else {
			// No args for -d
			std::cerr << "--del requires a numerical argument." << std::endl;
			return 1;
		}
	}

	// Moving task
	else if ((arg == "-m") || (arg == "--move")) {
		if (argc > 3) { // Make sure we aren't at the end of argv!
			moveItemAtIndex(atoi(argv[2]), atoi(argv[3]));
			return 0;
		} else {
			// No args for -m
			std::cerr << "--move requires two numerical arguments." << std::endl;
			return 1;
		}
	}

	// List all items
	else if ((arg == "-l") || (arg == "--list")) {
		listAll();
		return 0;
	}

	// Adding new task
	else if ((arg == "-a") || (arg == "--add")) {
		if (argc > 2) { // Make sure we aren't at the end of argv!
			add(&argv[2], argc - 2);
			return 0;
		} else {
			// No args for -a
			std::cerr << "--add requires at least argument." << std::endl;
			return 1;
		}
	}
	else {
		//By default, we add a task
		add(&argv[1], argc - 1);
		return 0;
	}
}
