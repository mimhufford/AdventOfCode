day25 :: (input: string) -> string, string
{
    keys, locks : [..][5]s64;

    while input
    {
        top := read_word(*input);
        schematic : *[5]s64;
        if top[0] == #char "#" schematic = array_add(*locks);
        else                   schematic = array_add(*keys);
        for 1..5 for read_word(*input) if it == #char "#" schematic.*[it_index] += 1;
        read_word(*input);
    }

    part1, part2 := 0;

    for l: locks
    {
        for k: keys
        {
            for i: 0..4 if l[i] + k[i] > 5 continue k;
            part1 += 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}