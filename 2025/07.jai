day7 :: (input: string) -> string, string
{
    part1, part2 : s64;

    cols := read_up_to(*trim(input), "\n").count;
    rows := input.count / cols - 1;
    grid := NewArray(rows * cols, s64);

    for row: 0..rows-1 {
        for col: 0..cols-1 {
            char := input[row * (cols + 1) + col];
            if char == "S" grid[row * cols + col] = 1;
            if char == "^" grid[row * cols + col] = -1;
        }
    }

    for row: 0..rows-2 {
        for col: 0..cols-1 {
            index := row * cols + col;
            if grid[index] <= 0 continue;
            below := index + cols;
            if grid[below] >= 0 {
                grid[below] += grid[index];
            } else {
                grid[below-1] += grid[index];
                grid[below+1] += grid[index];
                part1 += 1;
            }
        }
    }
    
    for col: 0..cols-1 {
        index := (rows-1) * cols + col;
        part2 += grid[index];
    }

    return tprint("%", part1), tprint("%", part2);
}