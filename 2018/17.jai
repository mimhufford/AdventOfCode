day17 :: (input: string) -> string, string
{
    part1, part2 := 0;
    x_min, x_max, y_min, y_max := S64_MAX, S64_MIN, S64_MAX, S64_MIN;
    map := NewArray(2000*1000, u8);
    for * map it.* = ".";
    id :: (x, y) => y * 1000 + x;

    while input {
        x0, x1, y0, y1, x_or_y := 0, 0, 0, 0, input[0];
        advance(*input, 2); x0 = read_s64(*input); x1 = x0;
        advance(*input, 4); y0 = read_s64(*input);
        advance(*input, 2); y1 = read_s64(*input);
        if x_or_y == "y" x0, x1, y0, y1 = y0, y1, x0, x1;

        x_min, x_max = min(x_min, x0-1), max(x_max, x1+1);
        y_min, y_max = min(y_min, y0), max(y_max, y1);

        for y: y0..y1 for x: x0..x1 map[id(x,y)] = "#";
    }

    fill :: (map: []u8, x: s64, y: s64) {
        if map[id(x,y)] != "|" return;
        map[id(x,y)] = "~";
        fill(map, x - 1, y);
        fill(map, x + 1, y);
    }

    flood :: (map: []u8, x: s64, y: s64, dx: s64, y_max: s64) -> bool {
        if y > y_max return true;
        cell := *map[id(x,y)];
        if cell.* != "." return cell.* == "|";
        cell.* = "|";
        if flood(map, x, y + 1, 0, y_max) return true;
        overflow := false;
        overflow |= dx <= 0 && flood(map, x - 1, y, -1, y_max);
        overflow |= dx >= 0 && flood(map, x + 1, y, +1, y_max);
        if overflow return true;
        if dx == 0 fill(map, x, y);
        return false;
    }

    flood(map, 500, 0, 0, y_max);

    for y: y_min..y_max {
        for x: x_min..x_max {
            c := map[id(x,y)];
            part1 += ifx c == "|" || c == "~" then 1;
            part2 += ifx c == "~" then 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}