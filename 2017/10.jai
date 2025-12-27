day10 :: (input: string) -> string, string
{
    lengths1, lengths2 : [..]s64;

    for trim(input) array_add(*lengths2, it);
    array_add(*lengths2, ..s64.[17, 31, 73, 47, 23]);

    while input {
        array_add(*lengths1, read_s64(*input));
        if input advance(*input);
    }

    result1 := hash(lengths1, 1);
    part1 := result1[0].(s64) * result1[1].(s64);

    result2 := hash(lengths2, 64);
    dense : [16]u8;
    for * d, i: dense for b: 0..15 d.* ^= result2[i*16 + b];
    part2 : String_Builder;
    for dense print(*part2, "%", formatInt(it, base=16, minimum_digits=2));

    return tprint("%", part1), builder_to_string(*part2);
}

#scope_file

hash :: (lengths: []s64, rounds: s64) -> []u8 {
    numbers : [256]u8;
    for * numbers it.* = it_index.(u8);

    index, skip := 0;
    for 1..rounds {
        for l: lengths {
            lo, hi := index, index + l - 1;
            index += l + skip;
            skip += 1;
            while lo < hi {
                swap(*numbers[lo%numbers.count], *numbers[hi%numbers.count]);
                lo, hi = lo + 1, hi - 1;
            }
        }
    }

    return numbers;
}