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

    id :: (x: s64, y: s64) -> s64 { return y * 32 + x; }
    seen, targets : [32*32]u8;
    BFS :: struct { x, y: s8; steps := S16_MAX; }
    queue : [..]BFS;

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

    get_best_target :: (x: s8, y: s8) -> BFS #expand {
        array_reset_keeping_memory(*queue);
        for * seen it.* = 0;

        chosen : BFS;
        array_add(*queue, {x, y, 0});
        for c: queue {
            if c.steps > chosen.steps continue;
            if c.steps && map[c.y][c.x] != "." continue;
            if seen[id(c.x, c.y)] continue c;
            seen[id(c.x, c.y)] = 1;
            if !seen[id(c.x + 1, c.y)] array_add(*queue, {c.x + 1, c.y, c.steps + 1});
            if !seen[id(c.x - 1, c.y)] array_add(*queue, {c.x - 1, c.y, c.steps + 1});
            if !seen[id(c.x, c.y + 1)] array_add(*queue, {c.x, c.y + 1, c.steps + 1});
            if !seen[id(c.x, c.y - 1)] array_add(*queue, {c.x, c.y - 1, c.steps + 1});
            if !targets[id(c.x, c.y)] continue;
            if c.steps < chosen.steps { chosen = c; continue; }
            assert(chosen.steps == c.steps);
            if chosen.y < c.y { continue; }
            if chosen.y > c.y { chosen = c; continue; }
            if chosen.x > c.x { chosen = c; continue; }
        }

        return chosen;
    }

    for round: 0..S64_MAX {
        // put into correct turn order
        quick_sort(units, (a, b) => ifx a.y == b.y then a.x - b.x else a.y - b.y);

        // each unit takes a turn
        for * u: units {
            if u.h <= 0 continue;

            // check if already next to an enemy
            enemy := get_adjacent_enemy(u);

            // if not next to an enemy try to move closer to an enemy
            if enemy == null {
                // mark all open cells which are adjacent to an enemy
                for * targets it.* = 0;
                for * e: units {
                    if e.team == u.team continue;
                    if e.h <= 0 continue;
                    if map[e.y-1][e.x] == "." targets[id(e.x, e.y-1)] = 1;
                    if map[e.y+1][e.x] == "." targets[id(e.x, e.y+1)] = 1;
                    if map[e.y][e.x-1] == "." targets[id(e.x-1, e.y)] = 1;
                    if map[e.y][e.x+1] == "." targets[id(e.x+1, e.y)] = 1;
                }

                // bfs to get closest open cell
                enemy_adj := get_best_target(u.x, u.y);
                if enemy_adj.steps == S16_MAX continue;

                // mark all open cells which are adjacent to the unit
                for * targets it.* = 0;
                if map[u.y-1][u.x] == "." targets[id(u.x, u.y-1)] = 1;
                if map[u.y+1][u.x] == "." targets[id(u.x, u.y+1)] = 1;
                if map[u.y][u.x-1] == "." targets[id(u.x-1, u.y)] = 1;
                if map[u.y][u.x+1] == "." targets[id(u.x+1, u.y)] = 1;

                // bfs to get closest open cell
                unit_adj := get_best_target(enemy_adj.x, enemy_adj.y);

                // step towards chosen
                map[u.y][u.x] = ".";
                u.y, u.x = unit_adj.y, unit_adj.x;
                map[u.y][u.x] = u.team;
            }

            // update enemy if we didn't already have one
            enemy = ifx enemy then enemy else get_adjacent_enemy(u);

            // if we're next to an enemy now, attack
            if !enemy continue;
            enemy.h -= u.a;
            if enemy.h <= 0 map[enemy.y][enemy.x] = ".";
        }

        // remove any dead units
        for units if it.h <= 0 remove it;

        // check for done
        gob, elf := false;
        for units gob, elf |= it.team == "G", it.team == "E";
            if !gob || !elf {   
            total_hp := 0;
            for units total_hp += it.h;
            part1 += round * total_hp;
            break;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}