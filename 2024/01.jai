day1 :: (input: string) -> string, string
{
    left, right : [..]s64;

    array_reserve(*left, 1000);
    array_reserve(*right, 1000);

    while input
    {
        array_add(*left,  read_s64(*input));
        array_add(*right, read_s64(*input));
    }

    quick_sort(left,  compare_numbers);
    quick_sort(right, compare_numbers);

    right_i, part1, part2 : s64;

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