day1 :: (input: string) -> string, string
{
    part1, part2 : s64;
    dial := 50;

    while input {
        delta := ifx input[0] == "R" then 1 else -1;
        advance(*input);
        ticks := read_s64(*input);

        part2 += ((100 + (delta * dial)) % 100 + ticks) / 100;

        dial += delta * ticks;
        dial %= 100;

        part1 += ifx dial == 0 then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}