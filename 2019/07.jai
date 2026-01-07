day7 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    part1 := 0;
    settings : [..]s64; for 0..4 array_add(*settings, it);
    amp : [5]*Computer;
    for * amp it.* = computer(array_copy(ram));
    for :permutations p: settings {
        for amp reset(it);
        run(amp[0], 0,             p[0]);
        run(amp[1], amp[0].out[0], p[1]);
        run(amp[2], amp[1].out[0], p[2]);
        run(amp[3], amp[2].out[0], p[3]);
        run(amp[4], amp[3].out[0], p[4]);
        part1 = max(part1, amp[4].out[0]);
    }

    part2 := 0;
    for * settings it.* += 5;
    for :permutations p: settings {
        for a, id: amp { reset(a); run(a, p[id]); }
        while !amp[4].done {
            run(amp[0], ifx amp[4].out then amp[4].out[0]); amp[4].out.count = 0;
            run(amp[1], amp[0].out[0]);                     amp[0].out.count = 0;
            run(amp[2], amp[1].out[0]);                     amp[1].out.count = 0;
            run(amp[3], amp[2].out[0]);                     amp[2].out.count = 0;
            run(amp[4], amp[3].out[0]);                     amp[3].out.count = 0;
        }
        part2 = max(part2, amp[4].out[0]);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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