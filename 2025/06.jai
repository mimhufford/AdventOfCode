day6 :: (input: string) -> string, string
{
    part1, part2 : s64;

    numbers : [1000][4]s64;

    for row: 0..3 {
        for col: 0..999 {
            numbers[col][row] = read_s64(*input);
        }
    }

    for col: 0..999 {
        op := read_word(*input);
        answer := numbers[col][0];
        if op == "+" for 1..3 answer += numbers[col][it];
        else         for 1..3 answer *= numbers[col][it];
        part1 += answer;
    }

    return tprint("%", part1), tprint("%", part2);
}