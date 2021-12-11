day11 :: (data : string) -> string, string
{
    map : [10][10]u64;

    for row: 0..9
    {
        for col: 0..9
        {
            map[row][col] = data[0] - #char "0";
            advance(*data, 1);
        }
        advance(*data, 1);
    }

    increase :: (map: [][10]u64, row: int, col: int)
    {
        if row < 0 || row > 9 || col < 0 || col > 9 return;
        if map[row][col] == 10 return;

        map[row][col] += 1;

        if map[row][col] == 10
        {
            increase(map, row - 1, col - 1);
            increase(map, row - 1, col    );
            increase(map, row - 1, col + 1);
            increase(map, row    , col - 1);
            increase(map, row    , col + 1);
            increase(map, row + 1, col - 1);
            increase(map, row + 1, col    );
            increase(map, row + 1, col + 1);
        }
    }

    register_flash :: (row: int, col: int) #expand
    {
        if map[row][col] != 10 return;
        map[row][col] = 0;
        flashes += 1;
    }

    step := 0;
    flashes := 0;
    flashes_on_100th := 0;

    while true
    {
        step += 1;
        pre_flashes := flashes;
        for row: 0..9 for col: 0..9 increase(map, row, col);
        for row: 0..9 for col: 0..9 register_flash(row, col);
        if step == 100 flashes_on_100th = flashes;
        if flashes == pre_flashes + 100 break;
    }

	return tprint("%", flashes_on_100th), tprint("%", step);
}