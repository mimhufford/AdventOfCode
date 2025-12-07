day7 :: (input: string) -> string, string
{
    part1, part2 : s64;

    cols := read_up_to(*trim(input), "\n").count;
    rows := input.count / cols - 1;
    beams := NewArray(cols, s64);

    for col: 0..cols-1 if input[col] == "S" then beams[col] = 1;

    for row: 1..rows-2 {
        for col: 0..cols-1 {
            if beams[col] == 0 continue;
            if input[row * (cols + 1) + col] != "^" continue;
            beams[col-1] += beams[col];
            beams[col+1] += beams[col];
            beams[col] = 0;
            part1 += 1;
        }
    }
    
    for beams part2 += it;

    return tprint("%", part1), tprint("%", part2);
}