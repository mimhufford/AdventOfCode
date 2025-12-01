day1 :: (input: string) -> string, string
{
    part1, part2 : s64;
    position := 50;

    while input {
        diff := ifx input[0] == "R" then 1 else -1;
        advance(*input);
        val := read_s64(*input);
        for 0..val-1 {
            position += diff;
            position %= 100;
            part2 += ifx position == 0 then 1;
        }
        part1 += ifx position == 0 then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}