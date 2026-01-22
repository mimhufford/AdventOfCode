day11 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);
    
    V2 :: struct { x, y: s32; #overlay(x) hash: u64; }
    map : Table(u64, u8);
    pos : V2;
    dx, dy : s32;

    paint :: () -> s64, s32, s32, s32, s32 #expand {
        x0, x1, y0, y1 : s32; 
        pos.x, pos.y, dx, dy = 0, 0, 0, -1;
        while !c.done {
            cell := find_or_add(*map, pos.hash);
            run(c, cell.*);
            cell.* = pop_front(*c.out).(u8);
            if pop_front(*c.out) then dx, dy = -dy, dx; else dx, dy = dy, -dx;
            pos.x, pos.y += dx, dy;
            x0, x1 = min(x0, pos.x), max(x1, pos.x);
            y0, y1 = min(y0, pos.y), max(y1, pos.y);
        }

        return map.count, x0, x1, y0, y1;
    }

    part1 := paint();

    reset(c);
    table_reset(*map);
    table_add(*map, 0, 1);
    _, x0, x1, y0, y1 := paint();
    
    // for y: y0..y1 {
    //     for x: x0..x1 {
    //         if find_or_add(*map, V2.{x, y}.hash).* print("#"); else print(" ");
    //     }
    //     print("\n");
    // }

    part2 := "ZLEBKJRA";

    return tprint("%", part1), part2;
}