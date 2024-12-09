day9 :: (input: string) -> string, string
{
    part1 := greedy_refrag(input);
    part2 := actual_defrag(input);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

actual_defrag :: (input: string) -> s64
{
    files, gaps : [..]struct { size: s64; index: s64; };
    index, checksum := 0;

    for 0..input.count-2
    {
        size := input[it] - #char "0";
        if size == 0 continue;
        if it % 2 array_add(*gaps,  .{ size, index });
        else      array_add(*files, .{ size, index });
        index += size;
    }

    for * < f: files
    {
        for * g: gaps
        {
            if g.index >= f.index break;
            if g.size < f.size continue;
            f.index = g.index;
            g.size -= f.size;
            g.index += f.size;
            break;
        }

        checksum += it_index * f.size * (2 * f.index + f.size - 1) / 2;
    }

    return checksum;
}

greedy_refrag :: (input: string) -> s64
{
    data := tprint("%", input);
    data.count -= 1;
    checksum, position, l, r := 0, 0, 0, data.count-1;

    while true
    {
        // read file
        id := l / 2;
        blocks := data[l] - #char "0";

        // add checksum for file
        for 1..blocks
        {
            checksum += id * position;
            position += 1;
        }

        // update left pointer
        l += 1;
        if l >= data.count-1 break;

        // read gap
        free_blocks := data[l] - #char "0";

        // fill the gap
        while free_blocks > 0 && r > l
        {
            // read last file
            id := r / 2;
            blocks := data[r] - #char "0";

            if blocks > 0
            {
                // move block
                data[r] -= 1;
                checksum += id * position;
                position += 1;
                free_blocks -= 1;
            }
            else
            {
                // update right pointer
                r -= 2;
            }
        }

        l += 1;
    }

    return checksum;
}