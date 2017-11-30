const input = `4   21  894
  419  794  987
  424  797  125
  651  305  558
  655  631  963
    2  628  436
  736   50  363
  657  707  408
  252  705   98
  532  173  878
  574  792  854
  157  737  303`
  
const isValidTriangle = (a, b, c) => a + b > c && b + c > a && c + a > b

// part 1
const triangles = input.split("\n").map(l => l.trim().split(" ").filter(i => i.length > 0).map(c => parseInt(c)))
const amountValid1 = triangles.filter(t => isValidTriangle(t[0], t[1], t[2])).length
console.log(amountValid1)

// part 2
const col1 = triangles.map(l => l[0])
const col2 = triangles.map(l => l[1])
const col3 = triangles.map(l => l[2])

