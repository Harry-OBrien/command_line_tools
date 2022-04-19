#!/usr/bin/env python

import datetime
import sys
    
def save_activities(activity, score):
    with open("/Users/harryob/Documents/Mood_Log/mood_log.txt", "a") as log_file:
        output_text = str(datetime.datetime.now()) + "," + activity + "," + str(score)
        log_file.write(output_text + "\n")

def incorrect_usage():
    print("Usage: python3", sys.argv[0], "activity mood_score{0 -> 10}\n")
    exit(-1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        incorrect_usage()

    activity = sys.argv[1]
    score = None
    while True:
        # Check input is an int
        try:
            score = int(sys.argv[2])
        except ValueError:
            incorrect_usage()

        # Check input is in range
        if score >= 0 and score <= 10:
            break
        else:
            incorrect_usage()

    save_activities(activity, score)
