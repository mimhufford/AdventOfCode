day18 :: (input: string) -> string, string
{
    part1, part2 := S64_MAX, 0;

    Edge :: struct {
        steps : u16;
        doors : u32;
    }

    edges : [27][27]Edge; // 0-25 are keys, 26 is bot
    map : [81][81]u8;

    for y: 0..80 {
        for x: 0..80 {
            map[y][x] = input[y * 82 + x];
        }
    }

    queue : [..] struct { x: s32; y: s32; steps: u16; doors: u32; };
    seen : [81][81]bool;

    for y: 0..80 {
        for x: 0..80 {
            key := map[y][x];
            if key > "z" continue;
            if key < "a" continue;

            for y: 0..80 for x: 0..80 seen[y][x] = false;
            array_reset_keeping_memory(*queue);
            array_add(*queue, {x=x.(s32), y=y.(s32)});

            for c: queue {
                if seen[c.y][c.x] continue;
                seen[c.y][c.x] = true;
                cell := map[c.y][c.x];
                if cell == "#" continue;
                doors := c.doors;
                if cell >= "A" && cell <= "Z" {
                    doors |= cast(u32, 1) << (cell - "A");
                } else if cell == "@" {
                    edges[26][key-"a"].steps = c.steps;
                    edges[26][key-"a"].doors = doors;
                } else if cell >= "a" && cell <= "z" {
                    edges[key-"a"][cell-"a"].steps = c.steps;
                    edges[key-"a"][cell-"a"].doors = doors;
                }

                array_add(*queue, { c.x+1, c.y, c.steps + 1, doors });
                array_add(*queue, { c.x-1, c.y, c.steps + 1, doors });
                array_add(*queue, { c.x, c.y+1, c.steps + 1, doors });
                array_add(*queue, { c.x, c.y-1, c.steps + 1, doors });
            }
        }
    }

    {
        best : Table(u64, s64);
        queue : [..] struct { node: s32; keys: u32; steps: u16; #overlay(node) hash: u64; };
        array_add(*queue, { node = 26 });

        while queue {
            c := pop(*queue);

            if c.keys == 0b11111111111111111111111111 {
                part1 = min(part1, c.steps);
                continue;
            }

            best_steps, new := find_or_add(*best, c.hash);
            if !new && c.steps >= best_steps.* continue;
            best_steps.* = c.steps;

            for other: 0..25 {
                if c.node == other continue; // don't visit ourself

                got := (cast(u32, 1) << other) & c.keys;
                if got continue; // don't go back to one we've already got

                e := edges[c.node][other];

                blocked := e.doors & ~c.keys;
                if blocked continue; // don't visit keys behind locked doors

                q := array_add(*queue);
                q.node = other.(s8);
                q.steps = c.steps + e.steps;
                q.keys = c.keys | (cast(u32, 1) << other);
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}