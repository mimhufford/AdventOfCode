day1 :: (input: string) -> string, string
{
    part1, part2 : s64;
    dial := 50;

    while input {
        diff := ifx input[0] == "R" then 1 else -1;
        advance(*input);
        val := read_s64(*input);

        part2 += ((100 + (diff * dial)) % 100 + val) / 100;

        dial += diff * val;
        dial %= 100;

        part1 += ifx dial == 0 then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}