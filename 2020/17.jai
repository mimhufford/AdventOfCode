day17 :: (input: string) -> string, string
{
    grid3D := *grid3D1; dest3D := *grid3D2;
    grid4D := *grid4D1; dest4D := *grid4D2;

    {
        x := DIM/2-4; y := DIM/2-4; z := DIM/2-4; w := DIM/2-4;

        while input.count
        {
            x += 1;
            if input[0] == #char "#"
            {
                grid3D.grid[z][y][x] = true;
                grid4D.grid[w][z][y][x] = true;
            }
            if input[0] == #char "\n" { x = DIM/2-4; y += 1; }
            advance(*input);
        }
    }

    for 1..6
    {
        // expand search bounds by 1 each generation
        min := 7-it; max := DIM-min-1; 
        for z: min..max { for y: min..max { for x: min..max
        {
            neighbours := 0;

            for dz: -1..1 { for dy: -1..1 { for dx: -1..1
            {
                if dz == 0 && dy == 0 && dx == 0 continue;
                if grid3D.grid[z+dz][y+dy][x+dx] neighbours += 1;
            } } }

            if grid3D.grid[z][y][x] dest3D.grid[z][y][x] = neighbours == 2 || neighbours == 3;
            else dest3D.grid[z][y][x] = neighbours == 3;
        } } }

        temp3D := grid3D;
        grid3D = dest3D;
        dest3D = temp3D;
    }

    for 1..6
    {
        // expand search bounds by 1 each generation
        min := 7-it; max := DIM-min-1; 
        for w: min..max { for z: min..max { for y: min..max { for x: min..max
        {
            neighbours := 0;

            for dw: -1..1 { for dz: -1..1 { for dy: -1..1 { for dx: -1..1
            {
                if dw == 0 && dz == 0 && dy == 0 && dx == 0 continue;
                if grid4D.grid[w+dw][z+dz][y+dy][x+dx] neighbours += 1;
            } } } }

            if grid4D.grid[w][z][y][x] dest4D.grid[w][z][y][x] = neighbours == 2 || neighbours == 3;
            else dest4D.grid[w][z][y][x] = neighbours == 3;
        } } } }

        temp4D := grid4D;
        grid4D = dest4D;
        dest4D = temp4D;
    }

    return tprint("%", count_active(grid3D)), tprint("%", count_active(grid4D));
}

#scope_file

DIM :: 22; // 8x8 start can only grow out 6 steps

Grid3D :: struct
{
    grid : [DIM][DIM][DIM]bool;
}

Grid4D :: struct
{
    grid : [DIM][DIM][DIM][DIM]bool;
}

count_active :: (grid: *Grid3D) -> u64
{
    count : u64;
    for z: grid.grid for y: z for y if it count += 1;
    return count;
}

count_active :: (grid: *Grid4D) -> u64
{
    count : u64;
    for w: grid.grid for z: w for y: z for y if it count += 1;
    return count;
}

grid3D1, grid3D2 : Grid3D;
grid4D1, grid4D2 : Grid4D;