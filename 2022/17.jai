day17 :: (input: string) -> string, string
{
    filled : Table(u64, void);
    top    : s64;
    windex : s64;

    height_2022 : s64;
    extra_height := 0;
    cycle_length := 0;
    cycle_growth := 0;
    cycle_history : [5]Table(s64, u64); // windex at drop => packed previous index + top

    for i: 0..1_000_000_000_000-1
    {
        if i == 2022 height_2022 = top;

        s := shapes[i % shapes.count];
        x : s32 = 2;
        y : s32 = cast(s32)top + 3;

        // try to find the cycle length so we can skip forward
        if !cycle_length && i > 5000 // wait until 5000 so the pattern can settle
        {
            t := *cycle_history[i % shapes.count];

            previous := table_find_pointer(t, windex);

            if previous
            {
                value := previous.*;
                prev_top := cast(s32)(value & 0xFFFFFFFF);
                prev_idx := cast(s32)(value >> 32);
                cycle_growth = top - prev_top;
                cycle_length = i - prev_idx;

                cycles_to_skip := (1_000_000_000_000 - i) / cycle_length;
                i += cycles_to_skip * cycle_length;
                extra_height += cycles_to_skip * cycle_growth;
            }
            else
            {
                value := cast(u64)i << 32 + cast(u64)top;
                table_add(t, windex, value);
            }
        }

        // simulate shape falling
        while true
        {
            dx := ifx input[windex] == #char "<" then cast(s32)-1 else 1;
            windex = (windex + 1) % (input.count - 1);

            can_move_x := true;
            to_check := ifx dx < 0 then s.left else s.right;
            for to_check
            {
                pos := it;
                pos.x += x;
                pos.y += y;

                if pos.x < 0 || pos.x > 6 || table_find_pointer(*filled, pos.hash)
                {
                    can_move_x = false;
                    break;
                }
            }

            if can_move_x then x += dx;

            can_move_y := true;
            for s.down
            {
                pos := it;
                pos.x += x;
                pos.y += y;

                if pos.y < 0 || table_find_pointer(*filled, pos.hash)
                {
                    can_move_y = false;
                    break;
                }
            }

            if can_move_y then y -= 1;
            else break;
        }

        // add final shape positions to set and update new top
        for s.cells
        {
            pos := it;
            pos.x += x;
            pos.y += y;
            find_or_add(*filled, pos.hash);

            top = max(top, pos.y+1);
        }
    }

    return tprint("%", height_2022), tprint("%", top + extra_height);
}

#scope_file

Position :: struct
{
    x, y : s32;
    #overlay(x) hash : u64;
}

Shape :: struct
{
    cells : []Position;
    down  : []Position;
    left  : []Position;
    right : []Position;
}

shapes :: Shape.[
    .{ 
        .[ .{ 0,  0}, .{ 1,  0}, .{ 2,  0}, .{ 3,  0} ],
        .[ .{ 0, -1}, .{ 1, -1}, .{ 2, -1}, .{ 3, -1} ],
        .[ .{-1,  0} ],
        .[ .{ 4,  0} ],
    },
    .{ 
        .[ .{ 1,  0}, .{ 0,  1}, .{ 1,  1}, .{ 2,  1}, .{ 1,  2} ],
        .[ .{ 0,  0}, .{ 1, -1}, .{ 2,  0} ],
        .[ .{-1,  1}, .{ 0,  0}, .{ 0,  2} ],
        .[ .{ 3,  1}, .{ 2,  0}, .{ 2,  2} ],
    },
    .{
        .[ .{ 0,  0}, .{ 1,  0}, .{ 2,  0}, .{ 2,  1}, .{ 2,  2} ],
        .[ .{ 0, -1}, .{ 1, -1}, .{ 2, -1} ],
        .[ .{-1,  0}, .{ 1,  1}, .{ 1,  2} ],
        .[ .{ 3,  0}, .{ 3,  1}, .{ 3,  2} ],
    },
    .{
        .[ .{ 0,  0}, .{ 0,  1}, .{ 0,  2}, .{ 0,  3} ],
        .[ .{ 0, -1} ],
        .[ .{-1,  0}, .{-1,  1}, .{-1,  2}, .{-1,  3} ],
        .[ .{ 1,  0}, .{ 1,  1}, .{ 1,  2}, .{ 1,  3} ],
    },
    .{
        .[ .{ 0,  0}, .{ 1,  0}, .{ 0,  1}, .{ 1,  1} ],
        .[ .{ 0, -1}, .{ 1, -1} ],
        .[ .{-1,  0}, .{-1,  1} ],
        .[ .{ 2,  0}, .{ 2,  1} ],
    },
];