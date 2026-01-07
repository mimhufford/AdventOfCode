day9 :: (input: string) -> string, string
{
    Computer :: struct {
        ram  : []s64;
        in   : [..]s64;
        ip   : s64;
        rb   : s64;
        out  : s64;
        done : bool;
    }

    run :: (using c: *Computer, input: s64, reset := true) {
        if reset {
            in.count, ip, rb, out, done = 0, 0, 0, 0, false;
            array_resize(*ram, 1024*1024);
        }
        array_add(*in, input);
        while true {
            m1, m2, m3 := ram[ip]/100 % 10, ram[ip]/1000 % 10, ram[ip]/10000 % 10;
            a := ifx m1 == 0 then ram[ip + 1] else ifx m1 == 1 then ip + 1 else rb + ram[ip + 1];
            b := ifx m2 == 0 then ram[ip + 2] else ifx m2 == 1 then ip + 2 else rb + ram[ip + 2];
            c := ifx m3 == 0 then ram[ip + 3] else ifx m3 == 1 then ip + 3 else rb + ram[ip + 3];
            if ram[ip] % 100 == {
                case 1; ram[c] = ram[a] + ram[b]; ip += 4;
                case 2; ram[c] = ram[a] * ram[b]; ip += 4;
                case 3; if (in.count == 0) return; ram[a] = pop(*in); ip += 2;
                case 4; out = ram[a]; ip += 2;
                case 5; ip = ifx ram[a] != 0 then ram[b] else ip + 3;
                case 6; ip = ifx ram[a] == 0 then ram[b] else ip + 3;
                case 7; ram[c] = ifx ram[a]  < ram[b] then 1; ip += 4;
                case 8; ram[c] = ifx ram[a] == ram[b] then 1; ip += 4;
                case 9; rb += ram[a]; ip += 2;
                case 99; done = true; return;
            }
        }
    }

    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    c := Computer.{ ram = array_copy(ram) };
    run(*c, 1);
    part1 := c.out;
    run(*c, 2);
    part2 := c.out;

    return tprint("%", part1), tprint("%", part2);
}