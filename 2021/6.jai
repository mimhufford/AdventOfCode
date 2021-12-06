day6 :: (data : string) -> string, string
{
    counts : [9]u64;

    while data.count
    {
        counts[data[0] - #char "0"] += 1;
        advance(*data, 2);
    }

    for 1..80 do_one_day();
    part1 : u64; for counts part1 += it;

    for 81..256 do_one_day();
    part2 : u64; for counts part2 += it;

	return tprint("%", part1), tprint("%", part2);
}

do_one_day :: () #expand
{
    new_counts : [9]u64 = ---;
    for 0..8 new_counts[it] = `counts[(it+1)%9];
    new_counts[6] += `counts[0];
    memcpy(`counts.data, new_counts.data, new_counts.count * size_of(u64));
}