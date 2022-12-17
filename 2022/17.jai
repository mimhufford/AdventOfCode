day17 :: (input: string) -> string, string
{
    filled : Table(u64, void);
    top    : s32;
    windex : s64;

    height_2022 : s32;
    lcm := shapes.count * (input.count-1);

    for i: 0..lcm
    {
        if i == 2022 height_2022 = top;

        s := shapes[i % shapes.count];
        x : s32 = 2;
        y : s32 = top + 3;

        // simulate rock
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

                if pos.x < 0 || pos.x > 6
                {
                    can_move_x = false;
                    break;
                }

                if table_find_pointer(*filled, pos.hash)
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

                if pos.y < 0
                {
                    can_move_y = false;
                    break;
                }

                if table_find_pointer(*filled, pos.hash)
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

    return tprint("%", height_2022), tprint("%", "");
}

Position :: struct
{
    x, y : s32;
    #place x;
    hash : u64;
}

Shape :: struct
{
    name  : string;
    cells : []Position;
    down  : []Position;
    left  : []Position;
    right : []Position;
}

shapes :: Shape.[
    .{ 
        "-",
        .[ .{ 0,  0}, .{ 1,  0}, .{ 2,  0}, .{ 3,  0} ],
        .[ .{ 0, -1}, .{ 1, -1}, .{ 2, -1}, .{ 3, -1} ],
        .[ .{-1,  0} ],
        .[ .{ 4,  0} ],
    },
    .{ 
        "+",
        .[ .{ 1,  0}, .{ 0,  1}, .{ 1,  1}, .{ 2,  1}, .{ 1,  2} ],
        .[ .{ 0,  0}, .{ 1, -1}, .{ 2,  0} ],
        .[ .{-1,  1}, .{ 0,  0}, .{ 0,  2} ],
        .[ .{ 3,  1}, .{ 2,  0}, .{ 2,  2} ],
    },
    .{
        "J",
        .[ .{ 0,  0}, .{ 1,  0}, .{ 2,  0}, .{ 2,  1}, .{ 2,  2} ],
        .[ .{ 0, -1}, .{ 1, -1}, .{ 2, -1} ],
        .[ .{-1,  0}, .{ 1,  1}, .{ 1,  2} ],
        .[ .{ 3,  0}, .{ 3,  1}, .{ 3,  2} ],
    },
    .{
        "|",
        .[ .{ 0,  0}, .{ 0,  1}, .{ 0,  2}, .{ 0,  3} ],
        .[ .{ 0, -1} ],
        .[ .{-1,  0}, .{-1,  1}, .{-1,  2}, .{-1,  3} ],
        .[ .{ 1,  0}, .{ 1,  1}, .{ 1,  2}, .{ 1,  3} ],
    },
    .{
        "□",
        .[ .{ 0,  0}, .{ 1,  0}, .{ 0,  1}, .{ 1,  1} ],
        .[ .{ 0, -1}, .{ 1, -1} ],
        .[ .{-1,  0}, .{-1,  1} ],
        .[ .{ 2,  0}, .{ 2,  1} ],
    },
];