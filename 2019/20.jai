day20 :: (input: string) -> string, string
{
    part1, part2 := 0;

    V2 :: struct { x, y: s32; #overlay(x) hash: s64; }
    Portal :: struct { steps: s64; index: s64; dir: s8; }
    edges : Table(s64, [..]Portal); // V2 hash to connections
    seen : [200][200]bool;
    queue : [..] struct { x: s32; y: s32; steps: s64; };
    
    // parse the map and build connections between portals
    map := split(trim_right(input), "\n");
    for y: 1..map.count-2 {
        for x: 1..map[0].count-2 {
            if map[y][x] < "A" || map[y][x] > "Z" continue;

            get_portal :: (x: s64, y: s64) -> bool, string, s64, s64 #expand {
                if map[y-1][x] == "." return true, u8.[map[y][x], map[y+1][x]].(string), x, y-1;
                if map[y+1][x] == "." return true, u8.[map[y-1][x], map[y][x]].(string), x, y+1;
                if map[y][x-1] == "." return true, u8.[map[y][x], map[y][x+1]].(string), x-1, y;
                if map[y][x+1] == "." return true, u8.[map[y][x-1], map[y][x]].(string), x+1, y;
                return false, "", 0, 0;
            }

            bfs_portal :: (id: string, x: s64, y: s64) #expand {
                print("=== % at %, % ===\n", id, x, y);
                for y: 0..seen.count-1 for x: 0..seen[y].count-1 seen[y][x] = false;
                array_reset_keeping_memory(*queue);
                array_add(*queue, {x=x.(s32), y=y.(s32)});

                for c: queue {
                    if seen[c.y][c.x] continue;
                    seen[c.y][c.x] = true;
                    cell := map[c.y][c.x];
                    if cell == "#" continue;
                    if cell >= "A" && cell <= "Z" {
                        ok, other_id, other_x, other_y := get_portal(c.x, c.y);
                        assert(ok == true);
                        if c.steps == 1 continue;
                        print(" - % % steps away\n", other_id, c.steps);
                    }
                    if cell == "." {
                        array_add(*queue, { c.x+1, c.y, c.steps + 1 });
                        array_add(*queue, { c.x-1, c.y, c.steps + 1 });
                        array_add(*queue, { c.x, c.y+1, c.steps + 1 });
                        array_add(*queue, { c.x, c.y-1, c.steps + 1 });
                    }
                }
            }

            ok, id, px, py := get_portal(x, y);
            if ok bfs_portal(id, px, py);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}