day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    depth : [256]u8;
    last := 0;

    while input {
        pos := read_s64(*input);
        advance(*input, 2);
        depth[pos] = read_u8(*input);
        last = pos;
    }

    for t: 0..last {
        d := depth[t];
        if !d continue;
        if t % (2 * (d - 1)) continue;
        part1 += t * d;
    }

    for delay: 1..S64_MAX {
        for t: 0..last {
            d := depth[t];
            if !d continue;
            if (t + delay) % (2 * (d - 1)) continue;
            continue delay;
        }
        part2 = delay;
        break;
    }

    return tprint("%", part1), tprint("%", part2);
}