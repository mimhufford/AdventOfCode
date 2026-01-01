day13 :: (input: string) -> string, string
{
    carts : [..] struct { x, y, dx, dy, i: s64; hit: bool; };
    map, cur : [150][150]u8;

    for y: 0..149 {
        for x: 0..149 {
            map[y][x] = input[y * 151 + x];
            if map[y][x] == {
                case "v"; cur[y][x] = 1; array_add(*carts, { x, y, 0, +1, 0, false });
                case "^"; cur[y][x] = 1; array_add(*carts, { x, y, 0, -1, 0, false });
                case ">"; cur[y][x] = 1; array_add(*carts, { x, y, +1, 0, 0, false });
                case "<"; cur[y][x] = 1; array_add(*carts, { x, y, -1, 0, 0, false });
            }
        }
    }

    part1, part2 : string;
    
    while true {
        quick_sort(carts, (a, b) => ifx a.y == b.y then a.x - b.x else a.y - b.y);
        for * c: carts {
            if c.hit continue;
            cur[c.y][c.x] = 0;
            c.x, c.y += c.dx, c.dy;
            if map[c.y][c.x] == {
                case "/";  c.dx, c.dy = -c.dy, -c.dx;
                case "\\"; c.dx, c.dy = +c.dy, +c.dx;
                case "+";
                if c.i == 0 c.dx, c.dy = +c.dy, -c.dx;
                if c.i == 2 c.dx, c.dy = -c.dy, +c.dx;
                c.i = (c.i + 1) % 3;
            }
            if cur[c.y][c.x] == 1 {
                if !part1 then part1 = tprint("%,%", c.x, c.y);
                for * carts it.hit |= it.x == c.x && it.y == c.y;
            }
            cur[c.y][c.x] = 1 - cur[c.y][c.x];
        }
        for carts if it.hit remove it;
        if carts.count > 1 continue;
        part2 = tprint("%,%", carts[0].x, carts[0].y);
        break;
    }

    return tprint("%", part1), tprint("%", part2);
}