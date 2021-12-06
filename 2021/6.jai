day6 :: (data : string) -> string, string
{
    counts : [9]u64;

    while data.count
    {
        counts[data[0] - #char "0"] += 1;
        advance(*data, 2);
    }

    print("%\n", counts);

    for 1..80
    {
        new_counts : [9]u64 = ---;
        new_counts[0] = counts[1];
        new_counts[1] = counts[2];
        new_counts[2] = counts[3];
        new_counts[3] = counts[4];
        new_counts[4] = counts[5];
        new_counts[5] = counts[6];
        new_counts[6] = counts[0] + counts[7];
        new_counts[7] = counts[8];
        new_counts[8] = counts[0];
        memcpy(counts.data, new_counts.data, counts.count * size_of(u64));
    }

    part1 : u64;
    for counts part1 += it;

	return tprint("%", part1), "";
}