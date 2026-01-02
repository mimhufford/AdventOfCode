day15 :: (input: string) -> string, string
{
    part1, part2 := 0;

    Unit :: struct { x, y: s8; team: u8; a, h := 3, 200; }
    units : [..]Unit;
    map : [32][32]u8;

    for y: 0..31 for x: 0..31 {
        c := input[y * 33 + x];
        if c == "G" || c == "E" array_add(*units, {x = x.(s8), y = y.(s8), team = c});
        map[y][x] = c;
    }

    for map print("%\n", it.(string));

    V2 :: struct { x, y: s8; }
    seen, targets : [..]V2;
    queue : [..] struct { x, y: s8; steps: s16; };

    get_adjacent_enemy :: (u: *Unit) -> *Unit #expand {
        enemy: *Unit;
        for * e: units {
            if e.team == u.team continue;
            if e.h <= 0 continue;
            if abs(e.x - u.x) + abs(e.y - u.y) != 1 continue;
            if enemy && e.h > enemy.h continue;
            if enemy && e.h < enemy.h { enemy = e; continue; }
            if enemy && enemy.y < e.y continue;
            if enemy && enemy.y > e.y { enemy = e; continue; }
            if enemy && enemy.x < e.x continue;
            enemy = e;
        }
        return enemy;
    }

    for 1..1 {
        // put into correct turn order
        quick_sort(units, (a, b) => ifx a.y == b.y then a.x - b.x else a.y - b.y);

        // each unit takes a turn
        for * u: units {
            if u.h <= 0 continue;
            array_reset_keeping_memory(*seen);
            array_reset_keeping_memory(*queue);
            array_reset_keeping_memory(*targets);

            // check if already next to an enemy
            enemy := get_adjacent_enemy(u);

            // if not next to an enemy try to move closer to an enemy
            if enemy == null {
                // find all open cells which are adjacent to an enemy
                for * e: units {
                    if e.team == u.team continue;
                    if e.h <= 0 continue;
                    if map[e.y-1][e.x] == "." array_add(*targets, {e.x, e.y-1});
                    if map[e.y+1][e.x] == "." array_add(*targets, {e.x, e.y+1});
                    if map[e.y][e.x-1] == "." array_add(*targets, {e.x-1, e.y});
                    if map[e.y][e.x+1] == "." array_add(*targets, {e.x+1, e.y});
                }

                // bfs until we hit something from the target collection
                array_add(*queue, {u.x, u.y, 0});
                for c: queue {
                    if map[c.y][c.x] != "." continue;
                    // check if it's in the target collection
                    // keep track of min steps reading order just like with finding an enemy
                    // add to seen collection
                    // seen and targets needs to be a fast lookup, use a [1024]u8
                }
            }

            // update enemy if we didn't already have one
            enemy = ifx enemy then enemy else get_adjacent_enemy(u);

            // if we're next to an enemy now, attack
            if enemy {
            }

            break;
        }

        // remove any dead units
        for units if it.h <= 0 remove it;
    }

    return tprint("%", part1), tprint("%", part2);
}