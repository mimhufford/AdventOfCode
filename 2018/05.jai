day5 :: (input: string) -> string, string
{
    react :: (input: string, ignore: u8 = 0) -> s64, []u8 {
        polymer : [..]u8;
        array_reserve(*polymer, input.count);

        for curr: input {
            if curr == ignore continue;
            if curr + 32 == ignore continue;
            if polymer.count == 0 { array_add(*polymer, curr); continue; }
            if curr ^ peek(polymer) == 32 { pop(*polymer); continue; }
            array_add(*polymer, curr);
        }

        return polymer.count, polymer;
    }

    part1, reduced := react(input);
    part2 := S64_MAX;
    for 97..122 part2 = min(part2, react(reduced.(string), it.(u8)));

    return tprint("%", part1), tprint("%", part2);
}