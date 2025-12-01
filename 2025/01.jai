day1 :: (input: string) -> string, string
{
    part1, part2 : s64;
    dial := 50;

    while input {
        diff := ifx input[0] == "R" then 1 else -1;
        advance(*input);
        val := read_s64(*input);

        for 0..(val % 100)-1 {
            dial += diff;
            if dial > 99 dial -= 100;
            if dial < 00 dial += 100;
            part2 += ifx dial == 0 then 1;
        }

        part1 += ifx dial == 0 then 1;
        part2 += val / 100;
    }

    return tprint("%", part1), tprint("%", part2);
}