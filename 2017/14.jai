day14 :: (input: string) -> string, string
{
    part1, part2 := 0;

    grid : [128]string;
    for * grid it.* = hash(input, it_index);

    queue : [..] struct {r: u8; c: u8; };
    for row: 0..127 {
        for col: 0..127 {
            if grid[row][col] == "0" continue;
            part2 += 1;
            array_add(*queue, .{row.(u8), col.(u8)});
            while queue {
                part1 += 1;
                using pop(*queue);
                grid[r][c] = "0";
                if r < 127 && grid[r+1][c] == "1" array_add(*queue, .{r+1, c});
                if r > 000 && grid[r-1][c] == "1" array_add(*queue, .{r-1, c});
                if c < 127 && grid[r][c+1] == "1" array_add(*queue, .{r, c+1});
                if c > 000 && grid[r][c-1] == "1" array_add(*queue, .{r, c-1});
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

hash :: (input: string, suffix: s64) -> string {
    numbers : [256]u8;
    for * numbers it.* = it_index.(u8);

    lengths : [..]u8;
    for tprint("%-%", input, suffix) array_add(*lengths, it);
    array_add(*lengths, ..u8.[17, 31, 73, 47, 23]);

    index, skip := 0;
    for 1..64 {
        for l: lengths {
            lo, hi := index, index + l - 1;
            index += l + skip;
            skip += 1;
            while lo < hi {
                swap(*numbers[lo%numbers.count], *numbers[hi%numbers.count]);
                lo, hi = lo + 1, hi - 1;
            }
        }
    }

    dense : [16]u8;
    for * d, i: dense for b: 0..15 d.* ^= numbers[i*16 + b];
    row : String_Builder;
    for dense print(*row, "%0%",
        formatInt(it >> 4, base=2, minimum_digits=4),
        formatInt(it & 15, base=2, minimum_digits=4),
    );

    return builder_to_string(*row);
}