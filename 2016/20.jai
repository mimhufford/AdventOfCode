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

    while true
    {
        done := true;

        for 0..blacklist.count-2
        {
            if blacklist[it+1][0] <= blacklist[it][1]+1
            {
                blacklist[it][1] = max(blacklist[it][1], blacklist[it+1][1]);
                array_ordered_remove_by_index(*blacklist, it+1);
                done = false;
                break;
            }
        }

        if done break;
    }

    first_allowed := blacklist[0][1] + 1;
    total_allowed := blacklist.count - 1;

    return tprint("%", first_allowed), tprint("%", total_allowed);
}