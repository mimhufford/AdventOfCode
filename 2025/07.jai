day7 :: (input: string) -> string, string
{
    part1, part2 : s64;

    length := read_up_to(*trim(input), "\n").count;

    for row: 0..S64_MAX {
        for col: 0..length-1 {
            index := row * (length + 1) + col;
            if index >= input.count break row;
            if input[index] == "." continue;
            if input[index] == "^" continue;
            below := index + length + 1;
            if below >= input.count break row;
            if input[below] == "." || input[below] == "|" {
                input[below] = "|";
            } else {
                input[below-1] = "|";
                input[below+1] = "|";
                part1 += 1;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}