day15 :: (input: string) -> string, string
{
    part1, part2 := 0;

    words := split(trim(input), ",");

    for word: words
    {
        value : u8;
        for 0..word.count-1
        {
            value += word[it];
            value *= 17;
        }
        part1 += value;
    }

    return tprint("%", part1), tprint("%", part2);
}