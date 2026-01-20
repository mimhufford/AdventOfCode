day20 :: (input: string) -> string, string
{
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
    queue : [..]State;
    edges : Table(u32, [..] struct { pos: V2; steps: s64; depth_delta: s8; });

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
                array_add(find_or_add(*edges, V2.{x, y}.hash), { {other_x, other_y}, c.steps-1, 0 });
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
        is_inner :: (using pos: V2) -> bool { return x > 10 && x < 100 && y > 10 && y < 100; }
        array_add(find_or_add(*edges, locations[0].hash), { locations[1], 1, ifx is_inner(locations[0]) then cast(s8, 1) else cast(s8, -1) });
        array_add(find_or_add(*edges, locations[1].hash), { locations[0], 1, ifx is_inner(locations[1]) then cast(s8, 1) else cast(s8, -1) });
    }

    cache : Table(u64, s64);

    solve :: (depth: bool) -> s64 #expand {
        array_reset_keeping_memory(*queue);
        array_add(*queue, { aa.x, aa.y, 0, 0 });
        table_reset(*cache);
        while queue {
            c := extract_min(*queue);

            if c.x == zz.x && c.y == zz.y && c.depth == 0 return c.steps;

            best, new := find_or_add(*cache, c.hash);
            if !new && best.* <= c.steps continue;
            best.* = c.steps;

            pos := V2.{c.x, c.y};
            for table_find_pointer(*edges, pos.hash).* {
                new_depth : s32 = 0;
                if depth {
                    new_depth = c.depth + it.depth_delta;
                    if new_depth < 0 continue;
                }
                array_add(*queue, { it.pos.x, it.pos.y, new_depth, c.steps + it.steps });
            }
        }
    }

    part1 := solve(false);
    part2 := solve(true);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

State :: struct { x: s16; y: s16; depth: s32; steps: s64; #overlay(x) hash: u64; }

min_heap :: (a: []State, i: s64) {
    minimum := i; 

    l := 2 * i + 1; 
    if (l < a.count && a[l].steps < a[minimum].steps) minimum = l;

    r := 2 * i + 2; 
    if (r < a.count && a[r].steps < a[minimum].steps) minimum = r;

    if (minimum == i) return;

    swap(*a[i], *a[minimum]);
    min_heap(a, minimum);
}

extract_min :: (a: *[]State) -> State {
    value := a.*[0];
    array_unordered_remove_by_index(a, 0);
    min_heap(a.*, 0);
    return value;
}