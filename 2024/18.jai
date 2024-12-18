day18 :: (input: string) -> string, string
{
    for 1..1024
    {
        x := read_s64(*input); advance(*input);
        y := read_s64(*input);
        map[y][x] = true;
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 71;
map : [SIZE][SIZE]bool;