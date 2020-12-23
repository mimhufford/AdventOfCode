day23 :: (input: string) -> string, string
{
    cups1 : [9]Cup;

    for 0..8
    {
        cups1[it].i = input[it] - #char "0";
        cups1[it].n = *cups1[(it+1)%cups1.count];
        cups2[it].i = cups1[it].i;
        cups2[it].n = *cups2[it+1];
        i2i[cups2[it].i] = *cups2[it];
    }
    for 9..999999
    {
        cups2[it].i = xx (it + 1);
        cups2[it].n = *cups2[(it+1)%cups2.count];
        i2i[cups2[it].i] = *cups2[it];
    }

    c := *cups1[0];

    for 1..100
    {
        di := c.i - 1; if !di di = 9;
        while di == c.n.i || di == c.n.n.i || di == c.n.n.n.i { di -= 1; if !di di = 9; }
        d := c;
        while d.i != di d = d.n;
        t := c.n.n.n.n;
        c.n.n.n.n = d.n;
        d.n = c.n;
        c.n = t;
        c = t;
    }

    while c.i != 1 c = c.n;
    part1 : u64;
    for 1..8 { c = c.n; part1 *= 10; part1 += c.i; }

    i21 : Table(u32, u32);
    c = *cups2[0];

    for 1..10000000
    {
        di := c.i - 1; if !di di = 1000000;
        while di == c.n.i || di == c.n.n.i || di == c.n.n.n.i { di -= 1; if !di di = 1000000; }
        d := i2i[di];
        t := c.n.n.n.n;
        c.n.n.n.n = d.n;
        d.n = c.n;
        c.n = t;
        c = t;
    }

    part2 := cast(u64)i2i[1].n.i * cast(u64)i2i[1].n.n.i;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

cups2 : [1000000]Cup;
i2i   : [1000000]*Cup;

Cup :: struct
{
    i : u32;
    n : *Cup;
}