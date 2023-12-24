day23 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    // TODO: collapse the graph down
    build_graph(map);

    // TODO: The graph is collapsed down but I'm manually de-duplicating repeat edges.
    //       I should change build_graph to only go down each path once
    for nodes
    {
        print("= %,% =\n", it.x, it.y);
        for it.edges
        {
            print(" - %,% to %,%, steps:%\n", it.a.x, it.a.y, it.b.x, it.b.y, it.steps);
        }
    }

    // walk(map, 1, 0, 0, 1, slopes=true);
    // walk(map, 1, 0, 0, 1, slopes=false);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

part1, part2 := 0;
nodes : Table(u64, *Node);

hash :: (x: s64, y: s64) -> u64
{
    return ((cast(u64)(x)) << 32) | (cast(u64)(y));
}

build_graph :: (map: []string)
{
    table_reset(*nodes);
    n := New(Node);
    n.x, n.y = 1, 0;
    table_add(*nodes, hash(1, 0), n);
    visited : [..]u64;
    build_graph(map, 1, 0, 0, 1, n, 0, visited);
}

build_graph :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64, start_node: *Node, _steps: s64, _visited: []u64)
{
    x, y, dx, dy, steps := _x, _y, _dx, _dy, _steps;
    visited : [..]u64; array_copy(*visited, _visited);

    while true
    {
        options : [..]Direction;

        for d: Direction.[.{-1, 0}, .{1, 0}, .{0, -1}, .{0, 1}]
        {
            if d.dx == -dx && d.dy == -dy       continue; // don't backtrack
            if map[y+d.dy][x+d.dx] == #char "#" continue; // wall
            array_add(*options, d);
        }

        if options.count == 1
        {
            next := hash(x+options[0].dx, y+options[0].dy);
            // TODO: slow?
            if array_find(visited, next) break;
            
            x += options[0].dx;
            y += options[0].dy;
            dx = options[0].dx;
            dy = options[0].dy;
            steps += 1;

            if y == map.count - 1
            {
                // COPY-PASTE from below
                np, new := find_or_add(*nodes, next);
                if new np.* = New(Node);
                n := np.*;
                n.x, n.y = x, y;
                duplicate := false;
                for start_node.edges
                {
                    if it.a != start_node continue;
                    if it.b != n continue;
                    if it.steps != steps continue;
                    duplicate = true;
                    break;
                }
                if !duplicate
                {
                    e := array_add(*start_node.edges);
                    e.a = start_node;
                    e.b = n;
                    e.steps = steps;
                }
                break;
            }
        }
        else
        {
            curr := hash(x, y);
            array_add(*visited, curr);

            // COPY-PASTE from above
            np, new := find_or_add(*nodes, curr);
            if new np.* = New(Node);
            n := np.*;
            n.x, n.y = x, y;
            duplicate := false;
            for start_node.edges
            {
                if it.a != start_node continue;
                if it.b != n continue;
                if it.steps != steps continue;
                duplicate = true;
                break;
            }
            if !duplicate
            {
                e := array_add(*start_node.edges);
                e.a = start_node;
                e.b = n;
                e.steps = steps;
            }

            for options
            {
                next := hash(x+it.dx, y+it.dy);
                if array_find(visited, next) continue;
                array_add(*visited, next);
                build_graph(map, x+it.dx, y+it.dy, it.dx, it.dy, n, 1, visited);
            }
            break;
        }
    }
}

walk :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64, slopes: bool)
{
    visited : [..]u64;
    walk(map, _x, _y, _dx, _dy, slopes, 0, visited);
}

walk :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64, slopes: bool, _steps: s64, _visited: []u64)
{
    x, y, dx, dy, steps := _x, _y, _dx, _dy, _steps;
    visited : [..]u64; array_copy(*visited, _visited);

    while true
    {
        options : [..]Direction;

        for d: Direction.[.{-1, 0}, .{1, 0}, .{0, -1}, .{0, 1}]
        {
            // don't backtrack
            if d.dx == -dx && d.dy == -dy continue;

            // wall
            if map[y+d.dy][x+d.dx] == #char "#" continue;

            // trying to go left onto a >
            if slopes && map[y+d.dy][x+d.dx] == #char ">" && d.dx == -1 continue;

            // trying to go right onto a <
            if slopes && map[y+d.dy][x+d.dx] == #char "<" && d.dx == 1 continue;

            // trying to go down onto a ^
            if slopes && map[y+d.dy][x+d.dx] == #char "^" && d.dy == 1 continue;

            // trying to go up onto a v
            if slopes && map[y+d.dy][x+d.dx] == #char "v" && d.dy == -1 continue;

            array_add(*options, d);
        }

        if options.count == 1
        {
            next := ((cast(u64)(x+options[0].dx)) << 32) | (cast(u64)(y+options[0].dy));
            // TODO: slow?
            if array_find(visited, next) break;
            
            x += options[0].dx;
            y += options[0].dy;
            dx = options[0].dx;
            dy = options[0].dy;
            steps += 1;

            if y == map.count - 1
            {
                p := ifx slopes then *part1 else *part2;
                if !slopes && p.* < steps print("%\n", steps);
                p.* = max(p.*, steps);
                break;
            }
        }
        else
        {
            curr := ((cast(u64)(x)) << 32) | (cast(u64)(y));
            array_add(*visited, curr);

            for options
            {
                next := ((cast(u64)(x+it.dx)) << 32) | (cast(u64)(y+it.dy));
                if array_find(visited, next) continue;
                array_add(*visited, next);
                walk(map, x+it.dx, y+it.dy, it.dx, it.dy, slopes, steps+1, visited);
            }
            break;
        }
    }
}

Direction :: struct
{
    dx, dy: s8;
}

Node :: struct
{
    x, y: s64;
    edges: [..]Edge;
}

Edge :: struct
{
    a, b: *Node;
    steps: s64;
}

/*

X - intersection
 
#x#####################
#.......#########...###
#######.#########.#.###
###.....#..x..###.#.###
###.#####.#.#.###.#.###
###x....#.#.#.....#...#
###.###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########.#
#.#...#...#...###....x#
#.#.#.#######.###.###.#
#...#x..#....x..#.###.#
#####.#.#.###.#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###.#####.###
#...#...#.#..x..#..x###
#.###.###.#.###.#.#.###
#.....###...###...#...#
#####################x#


*/