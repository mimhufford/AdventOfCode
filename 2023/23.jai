day23 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    nodes := build_graph(map);

    for nodes print("%\n", it);

    // walk(map, 1, 0, 0, 1, slopes=true);
    // walk(map, 1, 0, 0, 1, slopes=false);

    part1, part2 := 0;
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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
                        if d.x == -dx && d.y == -dy       continue; // don't backtrack
                        if y+d.y < 0                      continue; // off the map
                        if y+d.y > map.count-1            continue; // off the map
                        if map[y+d.y][x+d.x] == #char "#" continue; // wall
                        array_add(*options, d);
                    }

                    if options.count == 1
                    {
                        // do it and go again
                        x += options[0].x;
                        y += options[0].y;
                        dx = options[0].x;
                        dy = options[0].y;
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

Direction :: struct
{
    x, y: s8;
}