day13 :: (input: string) -> string, string
{
    part1, part2 := 0;
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);
    
    while !c.done {
        run(c);
        for 0..(c.out.count-1)/3  part1 += ifx c.out[it*3+2] == 2 then 1;
        if c.done break;
    }

    reset(c);
    c.ram[0] = 2;
    ball, paddle := 0;

    while !c.done {
        run(c, ifx ball < paddle then -1 else ifx ball > paddle then 1);
        for 0..(c.out.count-1)/3 {
            if c.out[it*3+2] ==  4 then ball   = c.out[it*3+0];
            if c.out[it*3+2] ==  3 then paddle = c.out[it*3+0];
            if c.out[it*3+0] == -1 then part2  = c.out[it*3+2];
        }
        c.out.count = 0;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file #load "intcode.jai";