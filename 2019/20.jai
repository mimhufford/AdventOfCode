day20 :: (input: string) -> string, string
{
    part1, part2 := 0;

    V2 :: struct { x, y: s32; #overlay(x) hash: s64; }
    portals : Table(string, [..]V2);

    get_portal :: (x: s64, y: s64) -> bool, string, s64, s64 #expand {
        if map[y-1][x] == "." return true, tprint("%", u8.[map[y][x], map[y+1][x]].(string)), x, y-1;
        if map[y+1][x] == "." return true, tprint("%", u8.[map[y-1][x], map[y][x]].(string)), x, y+1;
        if map[y][x-1] == "." return true, tprint("%", u8.[map[y][x], map[y][x+1]].(string)), x-1, y;
        if map[y][x+1] == "." return true, tprint("%", u8.[map[y][x-1], map[y][x]].(string)), x+1, y;
        return false, "", 0, 0;
    }
    
    aa, zz : V2;
    map := split(trim_right(input), "\n");
    for y: 1..map.count-2 {
        for x: 1..map[0].count-2 {
            if map[y][x] < "A" || map[y][x] > "Z" continue;
            ok, id, px, py := get_portal(x, y);
            if !ok continue;
            if id == "AA" aa = {px.(s32), py.(s32)};
            if id == "ZZ" zz = {px.(s32), py.(s32)};
            array_add(find_or_add(*portals, id), {px.(s32), py.(s32)});
        }
    }

    seen : [200][200]bool;
    queue : [..] struct { x: s32; y: s32; steps: s64; };
    edges : Table(s64, [..] struct { pos: V2; steps: s64; });

    bfs_portal :: (id: string, x: s64, y: s64) #expand {
        for y: 0..seen.count-1 for x: 0..seen[y].count-1 seen[y][x] = false;
        array_reset_keeping_memory(*queue);
        array_add(*queue, {x=x.(s32), y=y.(s32)});

        for c: queue {
            if seen[c.y][c.x] continue;
            seen[c.y][c.x] = true;
            cell := map[c.y][c.x];
            if cell == "#" continue;
            if cell >= "A" && cell <= "Z" {
                if c.steps == 1 continue;
                ok, other_id, other_x, other_y := get_portal(c.x, c.y);
                array_add(find_or_add(*edges, V2.{x.(s32), y.(s32)}.hash), { {other_x.(s32), other_y.(s32)}, c.steps });
            }
            if cell == "." {
                array_add(*queue, { c.x+1, c.y, c.steps + 1 });
                array_add(*queue, { c.x-1, c.y, c.steps + 1 });
                array_add(*queue, { c.x, c.y+1, c.steps + 1 });
                array_add(*queue, { c.x, c.y-1, c.steps + 1 });
            }
        }
    }

    for locations, id: portals {
        for locations bfs_portal(id, it.x, it.y);
        if locations.count == 1 continue;
        array_add(find_or_add(*edges, locations[0].hash), { locations[1], 1 });
        array_add(find_or_add(*edges, locations[1].hash), { locations[0], 1 });
    }

    for edges {
        start := V2.{hash = it_index};
        print("% - %\n", start, it);
    }

    print("TODO: shortest path from % to %\n", aa, zz);

    return tprint("%", part1), tprint("%", part2);
}