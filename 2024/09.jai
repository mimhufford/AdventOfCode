day9 :: (input: string) -> string, string
{
    part1 := greedy_defrag(input);
    part2 := actual_defrag(input);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

actual_defrag :: (input: string) -> s64
{
    Block :: struct
    {
        id: s64;
        type: enum u8 { FILE; GAP; };
        size: s64;
        attempted_move: bool;
    }

    blocks : [..]Block;
    array_reserve(*blocks, input.count*10);

    for i: 0..input.count-2 array_add(*blocks, .{ i/2, ifx i%2 then .GAP else .FILE, input[i] - #char "0", false });

    for blocks print("%\n", it);

    print("===============\n");

    right := blocks.count-1;

    while right > 0
    {
        defer right -= 1;

        file := blocks[right];
        if file.type == .GAP continue;
        if file.attempted_move continue;

        file.attempted_move = true;

        for * gap, gap_index: blocks if gap.type == .GAP
        {
            if gap.size >= file.size
            {
                // reduce the gap size
                gap.size -= file.size;

                // move the file
                array_ordered_remove_by_index(*blocks, right);
                array_insert_at(*blocks, file, gap_index);

                // insert a gap where the file used to be
                array_insert_at(*blocks, .{0, .GAP, file.size, false}, right+1);

                break;
            }
        }
    }

    for blocks print("%\n", it);

    checksum, position := 0;
    for block: blocks
    {
        if block.id % 2
        {
            position += block.size;
        }
        else
        {
            for 1..block.size
            {
                checksum += block.id * position;
                position += 1;
            }
        }
    }

    return checksum;
}

// 6272445324928 too low
// 7775234723467 too high

greedy_defrag :: (input: string) -> s64
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