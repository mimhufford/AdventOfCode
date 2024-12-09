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
        type: enum u8 { FILE; GAP; };
        size: u8;
        attempted_move: bool;
        prev, next: *Block;
    }

    head, tail: *Block;

    for i: 0..input.count-2
    {
        b := New(Block);
        b.id = xx(i/2);
        b.type = ifx i % 2 then .GAP else .FILE;
        b.size = input[i] - #char "0";
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

        if file.type == .GAP continue;
        if file.attempted_move continue;
        file.attempted_move = true;

        gap := head;
        while gap
        {
            defer gap = gap.next;
            if gap == file break;
            if gap.type != .GAP continue;
            if gap.size < file.size continue;

            if gap.size == file.size
            {
                // simple switcheroo without having to create new blocks

                gap.type = .FILE;
                gap.id = file.id;
                gap.attempted_move = true;
                file.type = .GAP;
            }
            else
            {
                // more of a complex operation where a new gap block needs creating

                // shrink the gap
                gap.size -= file.size;

                // create a new gap
                new_gap := New(Block);
                new_gap.type = .GAP;
                new_gap.size = file.size;
                new_gap.prev = file.prev;
                new_gap.next = file.next;

                // swizzle all the pointers
                gap.prev.next = file;
                file.prev.next = new_gap;
                if file.next file.next.prev = new_gap;
                file.prev = gap.prev;
                file.next = gap;
                gap.prev = file;
            }

            break;
        }
    }

    checksum, position := 0;
    block := head;
    while block
    {
        if block.type == .FILE
        {
            mul := block.size * (position + position + block.size - 1) / 2;
            checksum += block.id * mul;
        }

        position += block.size;
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