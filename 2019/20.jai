day20 :: (input: string) -> string, string
{
    part1, part2 := S64_MAX;

    V2 :: struct { x, y: s16; #overlay(x) hash: u32; }
    portals : Table(string, [..]V2);

    get_portal :: (x: s16, y: s16) -> bool, string, s16, s16 #expand {
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
            ok, id, px, py := get_portal(x.(s16), y.(s16));
            if !ok continue;
            if id == "AA" aa = {px, py};
            if id == "ZZ" zz = {px, py};
            array_add(find_or_add(*portals, id), {px, py});
        }
    }

    seen : [200][200]bool;
    queue : [..] struct { x: s16; y: s16; depth: s32; steps: s64; #overlay(x) hash: u64; };
    edges : Table(u32, [..] struct { pos: V2; steps: s64; });

    bfs_portal :: (id: string, x: s16, y: s16) #expand {
        for y: 0..seen.count-1 for x: 0..seen[y].count-1 seen[y][x] = false;
        array_reset_keeping_memory(*queue);
        array_add(*queue, {x=x, y=y});

        for c: queue {
            if seen[c.y][c.x] continue;
            seen[c.y][c.x] = true;
            cell := map[c.y][c.x];
            if cell == "#" continue;
            if cell >= "A" && cell <= "Z" {
                if c.steps == 1 continue;
                ok, other_id, other_x, other_y := get_portal(c.x, c.y);
                array_add(find_or_add(*edges, V2.{x, y}.hash), { {other_x, other_y}, c.steps-1 });
            }
            if cell == "." {
                array_add(*queue, { x = c.x+1, y= c.y,   steps = c.steps + 1 });
                array_add(*queue, { x = c.x-1, y= c.y,   steps = c.steps + 1 });
                array_add(*queue, { x = c.x,   y= c.y+1, steps = c.steps + 1 });
                array_add(*queue, { x = c.x,   y= c.y-1, steps = c.steps + 1 });
            }
        }
    }

    for locations, id: portals {
        for locations bfs_portal(id, it.x, it.y);
        if locations.count == 1 continue;
        array_add(find_or_add(*edges, locations[0].hash), { locations[1], 1 });
        array_add(find_or_add(*edges, locations[1].hash), { locations[0], 1 });
    }

    array_reset_keeping_memory(*queue);
    array_add(*queue, { aa.x, aa.y, 0, 0 });
    cache : Table(u64, s64);
    while queue {
        c := pop(*queue);

        if c.x == zz.x && c.y == zz.y {
            part1 = min(part1, c.steps);
        }

        best, new := find_or_add(*cache, c.hash);
        if !new && best.* <= c.steps continue;
        best.* = c.steps;

        pos := V2.{c.x, c.y};
        for table_find_pointer(*edges, pos.hash).* {
            array_add(*queue, { it.pos.x, it.pos.y, 0, c.steps + it.steps });
        }
    }

    return tprint("%", part1), tprint("%", part2);
}