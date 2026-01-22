day13 :: (input: string) -> string, string
{
    part1, part2 := 0;
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);
    
    while !c.done {
        run(c);
        while c.out.count {
            x := pop_front(*c.out);
            y := pop_front(*c.out);
            t := pop_front(*c.out);
            part1 += ifx t == 2 then 1;
        }
    }

    reset(c);
    c.ram[0] = 2;
    ball, paddle := 0;

    while !c.done {
        run(c, ifx ball < paddle then -1 else ifx ball > paddle then 1);
        while c.out.count {
            x := pop_front(*c.out);
            y := pop_front(*c.out);
            t := pop_front(*c.out);
            if t ==  4 then ball   = x;
            if t ==  3 then paddle = x;
            if x == -1 then part2  = t;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}