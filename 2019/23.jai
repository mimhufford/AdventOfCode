day23 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    computers : [50]*Computer;
    for i: 0..49 {
        computers[i] = computer(array_copy(ram));
        run(computers[i], i);
    }

    while loop := true {
        for c: computers {
            while c.out.count {
                id, x, y := pop_front(*c.out), pop_front(*c.out), pop_front(*c.out);
                if id == 255 {
                    part1 = y;
                    break loop;
                } else {
                    push_back(*computers[id].in, x);
                    push_back(*computers[id].in, y);
                }
            }

            if c.in.count then run(c); else run(c, -1);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}