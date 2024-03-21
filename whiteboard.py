# The Hamming Distance is a measure of similarity between two strings of equal length. Complete the function so that it returns the number of differences between the two strings.

# Examples:
# a = "I like turtles"
# b = "I like turkeys"
# Result: 3

# a = "Hello World"
# b = "Hello World"
# Result: 0

#a = "espresso"
#b = "Expresso"
# Result: 2

# Notes:
# You can assume that the two inputs strings of equal length.

def solution(string_a, string_b):
    output = 0
    for i in range(len(string_a)):
        if string_a[i]  != string_b[i]:
            output += 1
    return output