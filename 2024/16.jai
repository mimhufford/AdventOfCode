day16 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1
    {
        for x: 0..SIZE-1
        {
            map[y][x] = ifx input[0] == #char "#" then 0 else S64_MAX;
            advance(*input);
        }   
        advance(*input);
    }

    walk(1, SIZE-2, .RIGHT, SIZE-2, 1);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Direction :: enum u8 { RIGHT; DOWN; LEFT; UP; };
dirs :: []s64.[.[1,0],.[0,1],.[-1,0],.[0,-1]];
SIZE :: 141;
map : [SIZE][SIZE]s64;

walk :: (x: s64, y: s64, d: Direction, tx: s64, ty: s64, score := 0)
{

}