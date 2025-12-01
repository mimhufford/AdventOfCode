day1 :: (input: string) -> string, string
{
    part1, part2 : s64;
    position := 50;

    while input {
        dir := input[0] == "R";
        advance(*input);
        val := read_s64(*input);
        position += ifx dir then val else -val;
        position %= 100;
        part1 += ifx position == 0 then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}