day23 :: (input: string) -> string, string
{
    for 0..7
    {
        i := input[it  ] - #char "0";
        n := input[it+1] - #char "0";
        if it == 0 cups1[0] = i;
        cups1[i] = n;
        if it == 7 cups1[n] = cups1[0];
    }

    play(cups1, 100);
    p1: [8]u32;
    p1[0] = cups1[1];
    for 1..7 p1[it] = cups1[p1[it-1]];
    part1: u64;
    for p1 part1 = part1 * 10 + it;

    for 0..999998
    {
        i := ifx it < 9 then input[it  ] - #char "0" else cast(u32)(it+1);
        n := ifx it < 8 then input[it+1] - #char "0" else cast(u32)(it+2);
        if it == 0 cups2[0] = i;
        cups2[i] = n;
        if it == 999998 cups2[n] = cups2[0];
    }

    play(cups2, 10000000);
    part2 := cast(u64)cups2[1] * cast(u64)cups2[cups2[1]];

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

play :: (cups: []u32, rounds: u32)
{
    c : u32 = cups[0];
    max : u32 = xx (cups.count-1);

    for 1..rounds
    {
        d := c - 1; if !d d = max;
        n := cups[c];
        nn := cups[n];
        nnn := cups[nn];
        while d == n || d == nn || d == nnn { d -= 1; if !d d = max; }
        nnnn := cups[nnn];
        cups[nnn] = cups[d];
        cups[d] = n;
        cups[c] = nnnn;
        c = nnnn;
    }
}

cups1 : [10]u32;      // pos 0 tells us first cup id, otherwise index is cup id and value is next cup
cups2 : [1000001]u32; // pos 0 tells us first cup id, otherwise index is cup id and value is next cup