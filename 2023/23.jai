day23 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    nodes := build_graph(map);

    for nodes print("%\n", it);

    // walk(map, 1, 0, 0, 1, slopes=true);
    // walk(map, 1, 0, 0, 1, slopes=false);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

part1, part2 := 0;

Node :: struct
{
    x, y : s64;
    checked : bool;
    // 0=L, 1=R, 2=U, 3=D
    uphill  : [4]bool;
    edges   : [4]*Node;
    steps   : [4]s64;
}

build_graph :: (map: []string) -> []Node
{
    nodes : [..]Node;
    array_reserve(*nodes, 500);
    {
        n := array_add(*nodes);
        n.x, n.y = 1, 0;
    }

    while true
    {
        done := true;

        for * start: nodes
        {
            if start.checked continue; // already checked
            start.checked = true;
            done = false;

            for dir: 0..3
            {
                dx, dy := direction_to_dx_dy(dir);

                print("Checking (%,%) in direction (%,%)\n", start.x, start.y, dx, dy);

                x, y := start.x + dx, start.y + dy;
                if y < 0                  continue; // off the map
                if y > map.count-1        continue; // off the map
                if map[y][x] == #char "#" continue; // wall
                if map[y][x] == #char ">" && dx == -1 start.uphill[dir] = true;
                if map[y][x] == #char "<" && dx ==  1 start.uphill[dir] = true;
                if map[y][x] == #char "^" && dy ==  1 start.uphill[dir] = true;
                if map[y][x] == #char "v" && dy == -1 start.uphill[dir] = true;

                start.steps[dir] += 1;

                while true
                {
                    options : [..]Direction;

                    for d: Direction.[.{-1, 0}, .{1, 0}, .{0, -1}, .{0, 1}]
                    {
                        if d.dx == -dx && d.dy == -dy       continue; // don't backtrack
                        if y+d.dy < 0                       continue; // off the map
                        if y+d.dy > map.count-1             continue; // off the map
                        if map[y+d.dy][x+d.dx] == #char "#" continue; // wall
                        array_add(*options, d);
                    }

                    if options.count == 1
                    {
                        // do it and go again
                        x += options[0].dx;
                        y += options[0].dy;
                        dx = options[0].dx;
                        dy = options[0].dy;
                        start.steps[dir] += 1;
                        if map[y][x] == #char ">" && dx == -1 start.uphill[dir] = true;
                        if map[y][x] == #char "<" && dx ==  1 start.uphill[dir] = true;
                        if map[y][x] == #char "^" && dy ==  1 start.uphill[dir] = true;
                        if map[y][x] == #char "v" && dy == -1 start.uphill[dir] = true;
                    }
                    else
                    {
                        print(" - Ended at (%,%) with options: %, uphill: %\n", x, y, options, start.uphill[dir]);

                        end : *Node;
                        for * other: nodes
                        {
                            if other.x == x && other.y == y
                            {
                                end = other;
                                break;
                            }
                        }
                        if !end end = array_add(*nodes);
                        end.x, end.y = x, y;

                        start.edges[dir] = end;
                        
                        break;
                    }
                }
            }
        }

        if done break;
    }

    return nodes;
}

direction_to_dx_dy :: (d: s64) -> s8, s8
{
    if d == 0 return -1,  0;
    if d == 1 return  1,  0;
    if d == 2 return  0, -1;
              return  0,  1;
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