day11 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := Computer.{ ram = ram };
    
    V2 :: struct { x, y: s32; #overlay(x) hash: u64; }
    map : Table(u64, u8);
    pos : V2;
    dx, dy : s32;

    paint :: () -> s32, s32, s32, s32 #expand {
        x0, x1, y0, y1 : s32; 
        pos.x, pos.y, dx, dy = 0, 0, 0, -1;
        run(*c, do_input = false);
        while true {
            cell := find_or_add(*map, pos.hash);
            run(*c, input = cell.*, reset = false);
            cell.* = c.out.(u8);
            run(*c, do_input = false, reset = false);
            if c.out then dx, dy = -dy, dx; else dx, dy = dy, -dx;
            pos.x, pos.y += dx, dy;
            x0, x1 = min(x0, pos.x), max(x1, pos.x);
            y0, y1 = min(y0, pos.y), max(y1, pos.y);
            if c.done break;
        }

        return x0, x1, y0, y1;
    }

    paint();
    part1 := map.count;

    table_reset(*map);
    table_add(*map, 0, 1);
    x0, x1, y0, y1 := paint();
    
    // for y: y0..y1 {
    //     for x: x0..x1 {
    //         if find_or_add(*map, V2.{x, y}.hash).* print("#"); else print(" ");
    //     }
    //     print("\n");
    // }

    part2 := "ZLEBKJRA";

    return tprint("%", part1), part2;
}

#scope_file

Computer :: struct {
    ram  : []s64;
    in   : [..]s64;
    ip   : s64;
    rb   : s64;
    out  : s64;
    done : bool;
}

run :: (using c: *Computer, input := 0, reset := true, do_input := true) {
    if reset {
        in.count, ip, rb, out, done = 0, 0, 0, 0, false;
        array_resize(*ram, 1024*1024);
    }
    if do_input then array_add(*in, input);
    while true {
        m1, m2, m3 := ram[ip]/100 % 10, ram[ip]/1000 % 10, ram[ip]/10000 % 10;
        a := ifx m1 == 0 then ram[ip + 1] else ifx m1 == 1 then ip + 1 else rb + ram[ip + 1];
        b := ifx m2 == 0 then ram[ip + 2] else ifx m2 == 1 then ip + 2 else rb + ram[ip + 2];
        c := ifx m3 == 0 then ram[ip + 3] else ifx m3 == 1 then ip + 3 else rb + ram[ip + 3];
        if ram[ip] % 100 == {
            case 1; ram[c] = ram[a] + ram[b]; ip += 4;
            case 2; ram[c] = ram[a] * ram[b]; ip += 4;
            case 3; if (in.count == 0) return; ram[a] = pop(*in); ip += 2;
            case 4; out = ram[a]; ip += 2; return;
            case 5; ip = ifx ram[a] != 0 then ram[b] else ip + 3;
            case 6; ip = ifx ram[a] == 0 then ram[b] else ip + 3;
            case 7; ram[c] = ifx ram[a]  < ram[b] then 1; ip += 4;
            case 8; ram[c] = ifx ram[a] == ram[b] then 1; ip += 4;
            case 9; rb += ram[a]; ip += 2;
            case 99; done = true; return;
        }
    }
}