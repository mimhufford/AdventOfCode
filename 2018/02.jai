day2 :: (input: string) -> string, string
{
    words := split(trim(input), "\n");
    twos, threes := 0;

    for w: words {
        counts : [26]u8;
        for w counts[it - "a"] += 1;
        two, three := false;
        for counts {
            two   |= it == 2;
            three |= it == 3;
        }
        twos   += ifx two   then 1;
        threes += ifx three then 1;
    }
    
    part1 := twos * threes;
    part2 : [..]u8;

    for i: 0..words.count-1 {
        a := words[i];
        for j: i+1..words.count-1 {
            b := words[j];
            diffs := 0;
            for 0..a.count-1 diffs += ifx a[it] != b[it] then 1;
            if diffs != 1 continue;
            for 0..a.count-1 if a[it] == b[it] array_add(*part2, a[it]);
            break;
        }
    }

    return tprint("%", part1), part2.(string);
}