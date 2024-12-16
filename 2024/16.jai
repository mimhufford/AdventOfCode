day16 :: (input: string) -> string, string
{
    for y: 0..SIZE-1
    {
        for x: 0..SIZE-1
        {
            map[y][x] = ifx input[0] == #char "#" then WALL else S64_MAX;
            advance(*input);
        }   
        advance(*input);
    }

    build_graph();
    part1 := find_shortest_distance();
    part2 := count_unique_cells(part1);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

WALL :: -1;
SIZE :: 141;
map : [SIZE][SIZE]s64;

// Super slow approach at the moment, but it gets the right answer
count_unique_cells :: (max_score : s64) -> s64
{
    cache : [SIZE][SIZE][4]s64;
    for cache for it for * it it.* = S64_MAX;

    State :: struct { x, y, d, score : s64; positions : [..]u64; }
    queue : [..]State;
    unique_positions : [..]u64;

    item := array_add(*queue);
    item.x, item.y = 1, SIZE-2;

    while queue
    {
        defer
        {
            array_free(queue[0].positions);
            array_unordered_remove_by_index(*queue, 0);
        }

        using queue[0];

        if score > max_score continue;
        if cache[y][x][d] < score continue;
        cache[y][x][d] = score;

        array_add(*positions, (cast(u64)x << 32) | cast(u64)y);

        if x == SIZE-2 && y == 1
        {
            for positions array_add_if_unique(*unique_positions, it);
            continue;
        }

        for dir, dir_index: []s64.[.[1,0],.[0,1],.[-1,0],.[0,-1]]
        {
            if map[y+dir[1]][x+dir[0]] == WALL continue;
            if abs(d - dir_index) == 2 continue;
            cost := 1 + ifx dir_index != d then 1000;
            item := array_add(*queue);
            item.x = x+dir[0];
            item.y = y+dir[1];
            item.d = dir_index;
            item.score = score + cost;
            array_add(*item.positions, ..positions);
        }
    }

    return unique_positions.count;
}

find_shortest_distance :: () -> s64
{
    State :: struct { x, y, d, score : s64; }
    queue : [..]State;

    array_add(*queue, .{ 1, SIZE-2, 0, 0 });
    i := 0;

    while i < queue.count
    {
        defer i += 1;
        using queue[i];

        if map[y][x] <= score continue;
        map[y][x] = score;

        for dir, dir_index: []s64.[.[1,0],.[0,1],.[-1,0],.[0,-1]]
        {
            if map[y+dir[1]][x+dir[0]] == WALL continue;
            if abs(d - dir_index) == 2 continue;
            cost := 1 + ifx dir_index != d then 1000;
            array_add(*queue, .{ x+dir[0], y+dir[1], dir_index, score + cost });
        }
    }

    return map[1][SIZE-2];
}

// =================================================
// Start on a faster approach to replace the above
// =================================================

graph : Table(u64, [4]Edge);

Node :: struct
{
    x: s32;
    y: s32;
    #place x; hash: u64;
}

Edge :: struct
{
    dest: u64;
    cost: s64;
    done: bool;
}

build_graph :: () -> s64
{
    init(*graph, 10_000);
    queue : [..]Node;

    start : Node;
    start.x = 1;
    start.y = SIZE-2;
    array_add(*queue, start);

    i := 0;
    while i < queue.count
    {
        node := queue[i];
        i += 1;

        edges := find_or_add(*graph, node.hash);

        dirs :: []s32.[.[1,0],.[0,1],.[-1,0],.[0,-1]];
        for dir, d: dirs
        {
            if edges.*[d].done continue;
            edges.*[d].done = true;

            x, y := node.x, node.y;

            if map[y+dir[1]][x+dir[0]] == WALL continue;

            r, l : [2]s32;
            l[0] =  dir[1]; l[1] = -dir[0];
            r[0] = -dir[1]; r[1] =  dir[0];

            // walk until intersection
            while true
            {
                x, y += dir[0], dir[1];
                edges.*[d].cost += 1;

                // intersection
                if map[y+dir[1]][x+dir[0]] == WALL || map[y+l[1]][x+l[0]] != WALL || map[y+r[1]][x+r[0]] != WALL
                {
                    new_node : Node;
                    new_node.x = x;
                    new_node.y = y;
                    edges.*[d].dest = new_node.hash;
                    find_or_add(*graph, new_node.hash);
                    array_add(*queue, new_node);
                    break;
                }
            }
        }
    }

    return 0;
}

dump_graph :: ()
{
    for graph
    {
        n : Node;
        n.hash = it_index;
        print("%:\n", n);

        for it
        {
            dir :: string.["R", "D", "L", "U"];
            if it.dest == 0 continue;
            d : Node;
            d.hash = it.dest;
            print("- %, %, %\n", dir[it_index], it.cost, d);
        }
    }
}