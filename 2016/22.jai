day22 :: (data: string) -> string, string
{
    nodes := read_nodes(*data);

    grid : [50][50]*Node;

    for * nodes grid[it.x][it.y] = it;

    viable := 0;

    for * a: nodes for * b: nodes
        if a != b && a.used && a.used < b.size - b.used
            viable += 1;

    // calculated by hand by printing:
    #if false
    for x: 0..35 {
        for y: 0..35 {
            if !grid[y][x] continue;
            if      x == 0 && y ==  0     print("X");
            else if x == 0 && y == 31     print("G"); 
            else if grid[y][x].used == 0  print("0");
            else if grid[y][x].used > 100 print("#");
            else print(".");
        }
        print("\n");
    }

    return tprint("%", viable), tprint("%", 195);
}

#scope_file

Node :: struct
{
    x, y, size, used: s16;
}

read_nodes :: (s: *string) -> []Node
{
    nodes : [..]Node;

    advance(s, 92);
    while s.count
    {
        n : Node;
        n.x    = next_s16(s);
        n.y    = next_s16(s);
        n.size = next_s16(s);
        n.used = next_s16(s);
        next_s16(s);
        next_s16(s);
        array_add(*nodes, n);
    }

    return nodes;
}