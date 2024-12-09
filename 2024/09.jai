day9 :: (input: string) -> string, string
{
    part1 := greedy_refrag(input);
    part2 := actual_defrag(input);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

actual_defrag_linked_list :: (input: string) -> s64
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

    print_list :: (h: *Block)
    {
        print("==========\n");
        curr := h;
        while curr
        {
            print("% % % %\n", curr.id, curr.type, curr.size, curr.attempted_move);
            curr = curr.next;
        }
        print("==========\n");
    }

    // print_list(head);

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

            gap.size -= file.size;

            // move the file
            new_gap := New(Block);
            new_gap.type = .GAP;
            new_gap.size = file.size;
            new_gap.prev = file.prev;
            new_gap.next = file.next;

            gap.prev.next = file;
            file.prev.next = new_gap;
            if file.next file.next.prev = new_gap;
            file.prev = gap.prev;
            file.next = gap;
            gap.prev = file;

            break;
        }
    }

    // print_list(head);

    checksum, position := 0;
    block := head;
    while block
    {
        if block.type == .GAP
        {
            position += block.size;
        }
        else
        {
            // TODO: can do some triangular number equation thing here
            for 1..block.size
            {
                checksum += block.id * position;
                position += 1;
            }
        }

        block = block.next;
    }

    return checksum;
}

actual_defrag :: (input: string) -> s64
{
    Block :: struct
    {
        id: u16;
        type: enum u8 { FILE; GAP; };
        size: u8;
        attempted_move: bool;
    }

    blocks : [..]Block;
    array_reserve(*blocks, input.count);

    for i: 0..input.count-2 array_add(*blocks, .{ xx(i/2), ifx i%2 then .GAP else .FILE, input[i] - #char "0", false });

    right := blocks.count-1;

    while right > 0
    {
        defer right -= 1;

        if blocks[right].type == .GAP continue;
        if blocks[right].attempted_move continue;
        blocks[right].attempted_move = true;

        for * gap, gap_index: blocks if gap.type == .GAP
        {
            if gap_index < right && gap.size >= blocks[right].size
            {
                file := blocks[right];

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

    checksum, position := 0;
    for block: blocks
    {
        if block.type == .GAP
        {
            position += block.size;
        }
        else
        {
            // TODO: can do some triangular number equation thing here
            for 1..block.size
            {
                checksum += block.id * position;
                position += 1;
            }
        }
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