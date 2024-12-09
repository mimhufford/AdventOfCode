day9 :: (input: string) -> string, string
{
    part1 := greedy_refrag(input);
    part2 := actual_defrag(input);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

actual_defrag :: (input: string) -> s64
{
    File :: struct
    {
        id: u16;
        size: u8;
        gap: u8;
        done: bool;
        prev, next: *File;
    }

    head, tail: *File;

    for 0..(input.count-1)/2
    {
        i := it * 2;
        f := New(File);
        f.id = xx it;
        f.size = input[i] - #char "0";
        f.gap = ifx i+1 < input.count-1 input[i+1] - #char "0";
        f.prev = tail;

        if tail tail.next = f;
        if i == 0 head = f;
        tail = f;
    }

    file := tail;
    while file
    {
        next_file := file.prev;
        defer file = next_file;

        if file.done continue;
        file.done = true;

        other := head;
        while other
        {
            defer other = other.next;
            if other == file break;
            if other.gap < file.size continue;

            // update the gaps
            file.prev.gap += file.size + file.gap;
            file.gap      =  other.gap - file.size;
            other.gap     =  0;

            // swizzle the pointers
            file.prev.next = file.next;
            if file.next file.next.prev = file.prev;
            file.prev = other;
            file.next = other.next;
            other.next.prev = file;
            other.next = file;

            break;
        }
    }

    checksum, position := 0;
    file = head;
    while file
    {
        mul := file.size * (position + position + file.size - 1) / 2;
        checksum += file.id * mul;
        position += file.size + file.gap;
        file = file.next;
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