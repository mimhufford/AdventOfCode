day7 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    amp : [5]*Computer;
    for * amp it.* = computer(array_copy(ram));

    part1 := 0;
    settings : [..]s64; for 0..4 array_add(*settings, it);
    for :permutations p: settings {
        for amp reset(it);
        run(amp[0], p[0], 0);
        run(amp[1], p[1], pop_front(*amp[0].out));
        run(amp[2], p[2], pop_front(*amp[1].out));
        run(amp[3], p[3], pop_front(*amp[2].out));
        run(amp[4], p[4], pop_front(*amp[3].out));
        part1 = max(part1, pop_front(*amp[4].out));
    }

    part2 := 0;
    for * settings it.* += 5;
    for :permutations p: settings {
        for a, id: amp { reset(a); run(a, p[id]); }
        while !amp[4].done {
            run(amp[0], ifx amp[4].out.count then pop_front(*amp[4].out));
            run(amp[1], pop_front(*amp[0].out));
            run(amp[2], pop_front(*amp[1].out));
            run(amp[3], pop_front(*amp[2].out));
            run(amp[4], pop_front(*amp[3].out));
        }
        part2 = max(part2, pop_front(*amp[4].out));
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

// TODO: pull this out to a common module :permutations:
permutations :: (n: *[..]s64, body: Code, flags: For_Flags) #expand
{
    `it, `it_index, i, a := n.*, 0, 0, NewArray(n.count, s64);

    #insert body;
    it_index += 1;

    while i < n.count {
        if a[i] < i {
            swap(n.data + ifx i % 2 then a[i], n.data + i);
            #insert body;
            it_index += 1;
            a[i] += 1;
            i = 0;
        } else {
            a[i] = 0;
            i += 1;
        }
    }
}