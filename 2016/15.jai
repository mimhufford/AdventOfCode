day15 :: (data: string) -> string, string
{
    discs : [..][2]int;

    lines := split(data, "\n");
    lines.count -= 1;

    for line: lines
    {
        advance(*line, 12);
        disc : [2]int;
        disc[0] = next_s64(*line);
        next_s64(*line);
        disc[1] = next_s64(*line);
        array_add(*discs, disc);
    }

    extra_disc := discs;
    array_add(*extra_disc, .[11, 0]);

    return tprint("%", find_alignment(discs)), tprint("%", find_alignment(extra_disc));
}

#scope_file;

find_alignment :: (discs: [][2]int) -> int
{
    for time: 0..S64_MAX
    {
        for disc, disc_index: discs
        {
            if (disc[1]+disc_index+time+1) % disc[0] != 0 continue time;
        }

        return time;
    }

    return 0;
}