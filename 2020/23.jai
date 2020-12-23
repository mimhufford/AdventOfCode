day23 :: (input: string) -> string, string
{
    for 0..8
    {
        cups1[it].i = input[it] - #char "0";
        cups1[it].n = *cups1[(it+1)%cups1.count];
        i2i[cups1[it].i] = *cups1[it];
    }

    play(cups1, 100);
    c := i2i[1]; part1: u64; for 1..8 { c = c.n; part1 *= 10; part1 += c.i; }

    for 0..999999
    {
        cups2[it].i = ifx it < 9 then input[it] - #char "0" else cast(u32)(it + 1);
        cups2[it].n = *cups2[(it+1)%cups2.count];
        i2i[cups2[it].i] = *cups2[it];
    }

    play(cups2, 10000000);
    part2 := cast(u64)i2i[1].n.i * cast(u64)i2i[1].n.n.i;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

play :: (cups: []Cup, rounds: u32)
{
    c := *cups[0];
    max_id : u32 = xx cups.count;

    for 1..rounds
    {
        di := c.i - 1; if !di di = max_id;
        while di == c.n.i || di == c.n.n.i || di == c.n.n.n.i { di -= 1; if !di di = max_id; }
        d := i2i[di];
        t := c.n.n.n.n;
        c.n.n.n.n = d.n;
        d.n = c.n;
        c.n = t;
        c = t;
    }
}

cups1 : [9]Cup;
cups2 : [1000000]Cup;
i2i   : [1000001]*Cup;

Cup :: struct
{
    i : u32;
    n : *Cup;
}