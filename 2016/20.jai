day20 :: (data: string) -> string, string
{
    blacklist : [..][2]s64;

    while data.count
    {   
        range : [2]s64;
        range[0] = next_u32(*data);
        range[1] = next_u32(*data);
        array_add(*blacklist, range);
    }

    quick_sort(blacklist, (a, b) => ifx a[0] < b[0] then -1 else 1);

    first_allowed : s64 = 0;

    for blacklist
    {
        if first_allowed >= it[0]  first_allowed = it[1] + 1;
        else break;
    }

    return tprint("%", first_allowed), tprint("%", "");
}