day9 :: (input: string) -> string, string
{
    part1 := greedy_refrag(input);
    part2 := actual_defrag(input);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

actual_defrag :: (input: string) -> s64
{
    Block :: struct
    {
        id: u16;
        size: u8;
        gap: u8;
        done: bool;
        prev, next: *Block;
    }

    head, tail: *Block;

    for 0..(input.count-1)/2
    {
        i := it * 2;
        b := New(Block);
        b.id = xx it;
        b.size = input[i] - #char "0";
        b.gap = ifx i+1 < input.count-1 input[i+1] - #char "0";
        b.prev = tail;

        if tail tail.next = b;
        if i == 0 head = b;
        tail = b;
    }

    file := tail;
    while file
    {
        next := file.prev;
        defer file = next;

        if file.done continue;
        file.done = true;

        gap := head;
        while gap
        {
            defer gap = gap.next;
            if gap == file break;
            if gap.gap < file.size continue;

            // update the gaps
            file.prev.gap += file.size + file.gap;
            file.gap      =  gap.gap - file.size;
            gap.gap       =  0;

            // swizzle the pointers
            file.prev.next = file.next;
            if file.next file.next.prev = file.prev;
            file.prev = gap;
            file.next = gap.next;
            gap.next.prev = file;
            gap.next = file;

            break;
        }
    }

    checksum, position := 0;
    block := head;
    while block
    {
        mul := block.size * (position + position + block.size - 1) / 2;
        checksum += block.id * mul;
        position += block.size + block.gap;
        block = block.next;
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