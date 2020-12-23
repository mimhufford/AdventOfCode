day23 :: (input: string) -> string, string
{
    cups : [9]Cup;

    for 0..8
    {
        cups[it].n = *cups[(it+1)%cups.count];
        cups[it].i = input[it] - #char "0";
    }

    c := *cups[0];

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

    return tprint("%", part1), "";
}

#scope_file

print :: (cup : *Cup) { c := cup; for 1..9 { print("% ", c.i); c = c.n; } print("\n"); }

Cup :: struct
{
    i : u8;
    n : *Cup;
}