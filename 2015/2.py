from data import day2 as data

data = data.splitlines()
data = list(map(lambda dim: dim.split('x'), data))

print(data)