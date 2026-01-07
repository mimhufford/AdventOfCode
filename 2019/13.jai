day13 :: (input: string) -> string, string
{
    part1, part2 := 0;
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := Computer.{ ram = ram };
    
    for 0..S64_MAX {
        run(*c, do_input = false, reset = !it);
        for 0..(c.out.count-1) / 3 {
            if c.out[it*3+2] == 2 then part1 += 1;
        }
        if c.done break;
    }

    c.ram[0] = 2;
    ball, paddle := 0;
    run(*c, do_input = false, reset = true);

    while !c.done {
        run(*c, input = ifx ball < paddle then -1 else ifx ball > paddle then 1, reset = false);
        for 0..(c.out.count-1) / 3 {
            if c.out[it*3+2] ==  4 then ball   = c.out[it*3+0];
            if c.out[it*3+2] ==  3 then paddle = c.out[it*3+0];
            if c.out[it*3+0] == -1 then part2  = c.out[it*3+2];
        }
        c.out.count = 0;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Computer :: struct {
    ram  : []s64;
    in   : [..]s64;
    ip   : s64;
    rb   : s64;
    out  : [..]s64;
    done : bool;
}

run :: (using c: *Computer, input := 0, reset := true, do_input := true) {
    if reset {
        in.count, out.count, ip, rb, done = 0, 0, 0, 0, false;
        array_resize(*ram, 1024*1024);
    }
    if do_input then array_add(*in, input);
    while ram[ip] != 99 {
        m1, m2, m3 := ram[ip]/100 % 10, ram[ip]/1000 % 10, ram[ip]/10000 % 10;
        a := ifx m1 == 0 then ram[ip + 1] else ifx m1 == 1 then ip + 1 else rb + ram[ip + 1];
        b := ifx m2 == 0 then ram[ip + 2] else ifx m2 == 1 then ip + 2 else rb + ram[ip + 2];
        c := ifx m3 == 0 then ram[ip + 3] else ifx m3 == 1 then ip + 3 else rb + ram[ip + 3];
        if ram[ip] % 100 == {
            case 1; ram[c] = ram[a] + ram[b]; ip += 4;
            case 2; ram[c] = ram[a] * ram[b]; ip += 4;
            case 3; if (in.count == 0) return; ram[a] = pop(*in); ip += 2;
            case 4; array_add(*out, ram[a]); ip += 2;
            case 5; ip = ifx ram[a] != 0 then ram[b] else ip + 3;
            case 6; ip = ifx ram[a] == 0 then ram[b] else ip + 3;
            case 7; ram[c] = ifx ram[a]  < ram[b] then 1; ip += 4;
            case 8; ram[c] = ifx ram[a] == ram[b] then 1; ip += 4;
            case 9; rb += ram[a]; ip += 2;
        }
    }
    done = true;
}