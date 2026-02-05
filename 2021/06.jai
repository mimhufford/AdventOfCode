day6 :: (data : string) -> string, string
{
    counts : [9]u64;

    while data.count  counts[get(u8, *data)] += 1;

    for 1..80 do_one_day();
    part1 : u64; for counts part1 += it;

    for 81..256 do_one_day();
    part2 : u64; for counts part2 += it;

	return tprint("%", part1), tprint("%", part2);
}

do_one_day :: () #expand
{
    new := `counts[0];
    memcpy(`counts.data, `counts.data+1, (`counts.count-1)*size_of(u64));
    `counts[6] += new;
    `counts[8]  = new;
}