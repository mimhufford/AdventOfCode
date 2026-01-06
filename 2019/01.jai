day1 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        mass := get(s64, *input) / 3 - 2;
        part1 += mass;
        while mass > 0 {
            part2 += mass;
            mass = mass / 3 - 2;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}