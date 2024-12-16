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
    cost: [..]u64;
    best: s64;
}

count_cells :: (best_score: s64) -> s64
{
    paths : [..] struct { score: s64; edges: [..]*Edge; };
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
            next.score = score + e.cost.count + ifx d != it 1000;
            array_add(*next.edges, ..edges);
            array_add(*next.edges, node_edges.data + it);
        }
    }

    used_nodes : [..]u64;
    for paths
    {
        if it.score > best_score continue;
        for it.edges for it.cost array_add_if_unique(*used_nodes, it);
    }

    return used_nodes.count + 1;
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

        node := Node.{x = x, y = y};
        node_edges := table_find_pointer(*graph, node.hash);
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
            array_add(*queue, .{ next_node.x, next_node.y, it, score + e.cost.count + ifx d != it 1000 });
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

        dirs :: []s32.[.[1,0],.[0,1],.[-1,0],.[0,-1]];
        for dir, d: dirs
        {
            if edges.*[d].best == S64_MAX continue;
            edges.*[d].best = S64_MAX;

            x, y := node.x, node.y;

            if map[(y+dir[1])*(SIZE+1) + x+dir[0]] == #char "#" continue;

            r, l : [2]s32;
            l[0] =  dir[1]; l[1] = -dir[0];
            r[0] = -dir[1]; r[1] =  dir[0];

            // walk until intersection
            while true
            {
                x, y += dir[0], dir[1];
                array_add(*edges.*[d].cost, Node.{x=x,y=y}.hash);;

                // intersection
                if map[(y+dir[1])*(SIZE+1) + x+dir[0]] == #char "#"
                || map[(y+l[1])*(SIZE+1) + x+l[0]] != #char "#"
                || map[(y+r[1])*(SIZE+1) + x+r[0]] != #char "#"
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