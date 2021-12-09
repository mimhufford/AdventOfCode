day9 :: (data : string) -> string, string
{
    map : [..][..]u8;

    array_add(*map, <<New([..]u8));     // create top padding row

    while data.count
    {
        y := map.count;
        array_add(*map, <<New([..]u8)); // create row
        array_add(*map[y], 9);          // add padding 9 to left
        while data.count && data[0] != #char "\n"
        {
            array_add(*map[y], data[0] - #char "0");
            advance(*data, 1);
        }
        array_add(*map[y], 9);          // add padding 9 to right
        advance(*data, 1);              // skip the newline character
    }

    array_add(*map, <<New([..]u8));     // create bottom padding row

    for 1..map[1].count                 // fill top and bottom rows with padding 9s
    {
        array_add(*map[0], 9);
        array_add(*map[map.count-1], 9);
    }

    low_points : [..]Point;
    risk_total := 0;

    for row: 1..map.count-2
    {
        for col: 1..map[0].count-2
        {
            if map[row][col] >= map[row][col+1] continue;
            if map[row][col] >= map[row][col-1] continue;
            if map[row][col] >= map[row+1][col] continue;
            if map[row][col] >= map[row-1][col] continue;
            low_point : Point = ---;
            low_point.row = row;
            low_point.col = col;
            array_add(*low_points, low_point);
            risk_total += map[row][col] + 1;
        }
    }

    basins : [..]int;

    for low_points
    {
        basin := 0;
        queue : [..]Point;
        array_add(*queue, it);
        while queue.count
        {
            p := queue[queue.count-1];
            queue.count -= 1;
            if map[p.row][p.col] != 9 basin += 1;
            map[p.row][p.col] = 9;

            if map[p.row][p.col+1] != 9 { new_p : Point; new_p.row = p.row; new_p.col = p.col+1; array_add(*queue, new_p); }
            if map[p.row][p.col-1] != 9 { new_p : Point; new_p.row = p.row; new_p.col = p.col-1; array_add(*queue, new_p); }
            if map[p.row+1][p.col] != 9 { new_p : Point; new_p.row = p.row+1; new_p.col = p.col; array_add(*queue, new_p); }
            if map[p.row-1][p.col] != 9 { new_p : Point; new_p.row = p.row-1; new_p.col = p.col; array_add(*queue, new_p); }
        }
        array_add(*basins, basin);
    }

    quick_sort(basins, (a, b) => b - a);

    return tprint("%", risk_total), tprint("%", basins[0]*basins[1]*basins[2]);
}

Point :: struct
{
    row : int;
    col : int;
}