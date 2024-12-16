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

    part1 := find_minimum_score();
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
    best: s64;
}

find_minimum_score :: () -> s64
{
    build_graph();

    paths : [..] struct { score: s64; edges: [..]*Edge; };

    best_score := S64_MAX;
    queue : [..]struct { x: s32; y: s32; d: s64; score: s64; edges: [..]*Edge; };
    array_add(*queue, .{ x=1, y=SIZE-2, d=0, score=0 });

    i := 0;

    while i < queue.count
    {
        using curr := queue[i];
        i += 1;

        if score > best_score continue;

        node := Node.{x = x, y = y};
        node_edges := table_find_pointer(*graph, node.hash);
        assert(node_edges != null);

        if node_edges.*[d].best < score continue;
        node_edges.*[d].best = score;

        if x == SIZE-2 && y == 1
        {
            best_score = min(best_score, score);
            array_add(*paths, .{score = score, edges = edges});
            continue;
        }

        for 0..3
        {
            e := node_edges.*[it];
            next_node := Node.{hash = e.dest};
            if e.dest == 0 continue; // nothing in this direction
            if abs(d - it) == 2 continue; // don't go backwards
            next := array_add(*queue);
            next.x = next_node.x;
            next.y = next_node.y;
            next.d = it;
            next.score = score + e.cost + ifx d != it 1000;
            array_add(*next.edges, ..edges);
            array_add(*next.edges, node_edges.data + it);
        }
    }

    used_edges : [..]*Edge;
    for paths
    {
        if it.score > best_score continue;
        for it.edges array_add_if_unique(*used_edges, it);
    }
    total_used := 0;
    for used_edges total_used += it.cost;
    print("%\n", total_used);

    return best_score;
}

build_graph :: () -> s64
{
    init(*graph, 10_000);
    queue : [..]Node;
    array_add(*queue, .{x = 1, y = SIZE-2 });

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
            edges.*[d].best = S64_MAX;

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