day9 :: (input: string) -> string, string
{
    part1 := frag_files(input);
    part2 := pack_files(input);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

pack_files :: (input: string) -> s64
{
    // parse input data into blocks
    Block :: struct
    {
        id, size, free, index : s64;
        prev, next : *Block;
    }

    id, index := 0;
    first, last : *Block;

    while input
    {
        block := New(Block);
        block.id = id;
        block.index = index;
        block.size = input[0] - #char "0";
        if input[1] != #char "\n" block.free = input[1] - #char "0";

        if !first first = block;
        if last last.next = block;
        block.prev = last;
        last = block;

        id += 1;
        index += block.size + block.free;
        advance(*input, 2);
    }

    // track where the last file of each size found a free block so we can start looking from there next time
    gap_start := *Block.[first, first, first, first, first, first, first, first, first, first];

    // try to move each file
    file := last;
    while file
    {
        prev := file.prev;
        defer file = prev;

        gap := gap_start[file.size];
        if gap.index > file.index continue;

        while gap
        {
            defer gap = gap.next;
            if gap == file break;
            if gap.free < file.size continue;

            // we're moving, so extend the free space of the previous block
            if file.prev  file.prev.free += file.size + file.free;

            // fiddle the pointers to move the block
            if file.prev  file.prev.next = file.next;
            if file.next  file.next.prev = file.prev;
            file.next = gap.next;
            gap.next.prev = file;
            gap.next = file;
            file.prev = gap;

            // set our new free space and stomp over the previous free block
            file.free = gap.free - file.size;
            gap.free = 0;

            // update our index
            file.index = file.prev.index + file.prev.size;

            // track the starting point for gap hunting for this size in future
            gap_start[file.size] = file;
            break;
        }
    }

    checksum, block := 0, first;
    while block
    {
        for 1..block.size checksum += block.id * (block.index + it - 1);
        block = block.next;
    }
    return checksum;
}

frag_files :: (input: string) -> s64
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