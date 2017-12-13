from data import day1 as data

level = 0
first = 0

for i, direction in enumerate(data):
    level += 1 if direction == '(' else -1
    if level == -1 and first == 0:
        first = i + 1

print(level, first)