day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    depths : [..][2]s64;

    while input {
        d := array_add(*depths);
        d.*[0] = read_s64(*input);
        advance(*input, 2);
        d.*[1] = read_s64(*input);
    }

    quick_sort(depths, a => a[1]);
    curr_lcm := 1;
    curr, next : [..]s64;
    array_add(*curr, 1);

    for depths {
        t, d := it[0], it[1];
        period := 2 * (d - 1);
        if t % period == 0 then part1 += t * d;
        next_lcm := lcm(curr_lcm, period);

        extra := 0;
        while extra < next_lcm {
            defer extra += curr_lcm;
            for delay: curr {
                if (delay + extra + t) % period == 0 continue;
                array_add(*next, delay + extra);
            }
        }

        curr_lcm = next_lcm;
        curr, next = next, curr;
        array_reset_keeping_memory(*next);
        part2 = curr[0];
    }

    return tprint("%", part1), tprint("%", part2);
}