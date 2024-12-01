day1 :: (input: string) -> string, string
{
    part1, part2 := 0, 0;
    left, right : [..]s64;

    while input
    {
        array_add(*left,  read_s64(*input));
        array_add(*right, read_s64(*input));
    }

    quick_sort(left,  compare);
    quick_sort(right, compare);

    right_i := 0;

    for l, i: left
    {
        part1 += abs(l - right[i]);

        count := 0;
        while right_i < right.count-1 && right[right_i]  < l { right_i += 1; }
        while right_i < right.count-1 && right[right_i] == l { right_i += 1; count += 1; }
        part2 += l * count;
    }

    return tprint("%", part1), tprint("%", part2);
}

compare :: (a: s64, b: s64) -> s64
{
    if a < b return -1;
    if a > b return 1;
    return 0;
}