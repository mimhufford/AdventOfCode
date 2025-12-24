day1 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for 0..input.count-2 {
        if input[it] == input[(it+1)             % (input.count-1)] part1 += input[it] - "0";
        if input[it] == input[(it+input.count/2) % (input.count-1)] part2 += input[it] - "0";
    }

    return tprint("%", part1), tprint("%", part2);
}