day16 :: (input: string) -> string, string
{
    build_graph(input);
    part1, part2 := walk_graph();

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 141;
graph : Table(u64, [4]Edge);

Node :: struct
{
    x: s32;
    y: s32;
    #overlay(x) hash: u64;
}

Edge :: struct
{
    dest: u64;
    best: s64;
    cells: [..]u64;
}

walk_graph :: () -> s64, s64
{
    best_score := S64_MAX;
    paths : [..]s64;
    queue : [..] struct { x: s32; y: s32; d: s64; score: s64; edge: *Edge; prev := -1; };
    array_reserve(*queue, 250000);
    array_add(*queue, .{ x=1, y=SIZE-2, d=0, score=0 });

    for queue
    {
        using curr := it;

        node_edges := table_find_pointer(*graph, Node.{x=x, y=y}.hash);
        if node_edges.*[d].best < score continue;
        node_edges.*[d].best = score;

        if x == SIZE-2 && y == 1
        {
            best_score = min(best_score, score);
            array_add(*paths, it_index);
            continue;
        }

        for 0..3
        {
            if abs(d - it) == 2 continue; // don't go backwards
            e := node_edges.*[it];
            if e.dest == 0 continue; // nothing in this direction
            next_score := score + e.cells.count + ifx d != it 1000;
            next_node := Node.{hash = e.dest};
            array_add(*queue, .{next_node.x, next_node.y, it, next_score, node_edges.data+it, it_index});
        }
    }

    used_cells : Table(u64, void);
    for paths if queue[it].score == best_score
    {
        curr := it;
        while curr > 0
        {
            for queue[curr].edge.cells find_or_add(*used_cells, it);
            curr = queue[curr].prev;
        }
    }

    return best_score, used_cells.count + 1;
}

build_graph :: (map: string) -> s64
{
    init(*graph, 10_000);
    queue : [..]Node;
    array_add(*queue, .{x = 1, y = SIZE-2 });

    for queue
    {
        node := it;

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