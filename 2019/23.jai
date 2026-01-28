day23 :: (input: string) -> string, string
{
    part1, part2 := 0, S64_MAX;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    nat_x, nat_y : s64;
    computers : [50]*Computer;
    for i: 0..49 {
        computers[i] = computer(array_copy(ram));
        run(computers[i], i);
    }

    while true {
        idle := true;
        for c: computers {
            if c.in.count then run(c); else run(c, -1);
            while c.out.count {
                idle = false;
                id, x, y := pop_front(*c.out), pop_front(*c.out), pop_front(*c.out);
                if id == 255 {
                    nat_x, nat_y = x, y;
                    ifx !part1 then part1 = y;
                } else {
                    push_back(*computers[id].in, x);
                    push_back(*computers[id].in, y);
                }
            }
        }

        if idle {
            if part2 == nat_y break;
            part2 = nat_y;
            push_back(*computers[0].in, nat_x);
            push_back(*computers[0].in, nat_y);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}