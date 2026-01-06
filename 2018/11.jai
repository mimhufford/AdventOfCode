day11 :: (input: string) -> string, string
{
    serial := get(s64, *input);
    grid : [301][301]s64;

    for y: 1..300 {
        for x: 1..300 {
            grid[y][x] = ((x + 10) * y + serial) * (x + 10) / 100 % 10 - 5;
            grid[y][x] += grid[y][x - 1];
            grid[y][x] += grid[y - 1][x];
            grid[y][x] -= grid[y - 1][x - 1];
        }
    }

    part1, part2 : string;
    best_sum, best_x, best_y, best_size := S64_MIN;
    for size: 1..300 {
        bs, bx, by := S64_MIN;
        for y: 1..300-size {
            for x: 1..300-size {
                sum := grid[y][x] + grid[y+size][x+size] - grid[y][x+size] - grid[y+size][x];
                if sum > bs then bs, bx, by = sum, x, y;
            }
        }
        if bs > best_sum then best_sum, best_x, best_y, best_size = bs, bx, by, size;
        if size == 3 part1 = tprint("%,%", bx+1, by+1);
    }

    part2 = tprint("%,%,%", best_x+1, best_y+1, best_size);

    return tprint("%", part1), tprint("%", part2);
}