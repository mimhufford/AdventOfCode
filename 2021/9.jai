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

    low_points := 0;

    for row: 1..map.count-2
    {
        for col: 1..map[0].count-2
        {
            if map[row][col] >= map[row][col+1] continue;
            if map[row][col] >= map[row][col-1] continue;
            if map[row][col] >= map[row+1][col] continue;
            if map[row][col] >= map[row-1][col] continue;
            low_points += map[row][col] + 1;
        }
    }

    return tprint("%", low_points), tprint("%", "");
}