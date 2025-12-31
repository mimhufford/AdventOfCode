day5 :: (input: string) -> string, string
{
    react :: (input: string, ignore: u8 = 0) -> s64, []u8 {
        polymer : [..]u8;

        for input {
            if it == ignore continue;
            if it + 32 == ignore continue;
            array_add(*polymer, it);
        }

        for < 0..polymer.count-2 {
            a, b := polymer[it], polymer[it+1];
            if a ^ b != 32 continue;

            for i : it..polymer.count-3 {
                polymer[i] = polymer[i+2];
            }
            polymer.count -= 2;
        }

        return polymer.count, polymer;
    }

    part1, reduced := react(input);
    part2 := S64_MAX;
    for 97..122 part2 = min(part2, react(reduced.(string), it.(u8)));

    return tprint("%", part1), tprint("%", part2);
}