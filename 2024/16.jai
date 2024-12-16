day16 :: (input: string) -> string, string
{
    build_graph(input);
    part1 := walk_graph();
    part2 := count_cells(part1);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 141;
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
    cells: [..]u64;
    best: s64;
}

count_cells :: (best_score: s64) -> s64
{
    paths : [..] struct { score: s64; edges: [..]*Edge; };
    queue : [..] struct { x: s32; y: s32; d: s64; score: s64; edges: [..]*Edge; };
    array_add(*queue, .{ x=1, y=SIZE-2, d=0, score=0 });

    i := 0;
    while i < queue.count
    {
        using curr := queue[i];
        i += 1;

        if score > best_score continue;

        node_edges := table_find_pointer(*graph, Node.{x=x, y=y}.hash);
        assert(node_edges != null);

        if node_edges.*[d].best < score continue;
        node_edges.*[d].best = score;

        if x == SIZE-2 && y == 1
        {
            array_add(*paths, .{score, edges});
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
            next.score = score + e.cells.count + ifx d != it 1000;
            array_add(*next.edges, ..edges);
            array_add(*next.edges, node_edges.data + it);
        }
    }

    used_cells : [..]u64;
    for paths
    {
        if it.score > best_score continue;
        for it.edges for it.cells array_add_if_unique(*used_cells, it);
    }

    return used_cells.count + 1;
}

walk_graph :: () -> s64
{
    best_score := S64_MAX;
    queue : [..]struct { x: s32; y: s32; d: s64; score: s64; };
    array_add(*queue, .{ x=1, y=SIZE-2, d=0, score=0 });

    i := 0;
    while i < queue.count
    {
        using curr := queue[i];
        i += 1;

        if score >= best_score continue;

        node_edges := table_find_pointer(*graph, Node.{x=x, y=y}.hash);
        assert(node_edges != null);

        if node_edges.*[d].best <= score continue;
        node_edges.*[d].best = score;

        if x == SIZE-2 && y == 1
        {
            best_score = min(best_score, score);
            continue;
        }

        for 0..3
        {
            e := node_edges.*[it];
            next_node := Node.{hash = e.dest};
            if e.dest == 0 continue; // nothing in this direction
            if abs(d - it) == 2 continue; // don't go backwards
            array_add(*queue, .{ next_node.x, next_node.y, it, score + e.cells.count + ifx d != it 1000 });
        }
    }

    return best_score;
}

build_graph :: (map: string) -> s64
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

        for f, d: []s32.[.[1,0],.[0,1],.[-1,0],.[0,-1]]
        {
            if edges.*[d].best == S64_MAX continue;
            edges.*[d].best = S64_MAX;

            if map[(node.y+f[1])*(SIZE+1) + node.x+f[0]] == #char "#" continue;

            l := s32.[ f[1], -f[0]];
            r := s32.[-f[1],  f[0]];
            using new_node := Node.{x=node.x, y=node.y};

            while true // walk until intersection
            {
                x, y += f[0], f[1];
                array_add(*edges.*[d].cells, hash);

                if map[(y+f[1])*(SIZE+1) + x+f[0]] == #char "#"
                || map[(y+l[1])*(SIZE+1) + x+l[0]] != #char "#"
                || map[(y+r[1])*(SIZE+1) + x+r[0]] != #char "#"
                {
                    edges.*[d].dest = hash;
                    find_or_add(*graph, hash);
                    array_add(*queue, new_node);
                    break;
                }
            }
        }
    }

    return 0;
}