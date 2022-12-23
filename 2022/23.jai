day23 :: (input: string) -> string, string
{
    elves := parse_map(input);

    for round: 1..10
    {
        move := moves[round % 4];

        for * e: elves
        {

        }
    }

    return tprint("%", elves), tprint("%", "");
}

#scope_file

Elf :: struct
{
    x, y : s64;
}

moves :: ([][]s64).[
    .[ .[ 1,  0], .[ 1, -1], .[ 1,  1] ], // E
    .[ .[ 0, -1], .[ 1, -1], .[-1, -1] ], // N
    .[ .[ 0,  1], .[ 1,  1], .[-1,  1] ], // S
    .[ .[-1,  0], .[-1, -1], .[-1,  1] ], // W
];

parse_map :: (input: string) -> []Elf
{
    elves : [..]Elf;

    x, y := 0, 0;

    while input
    {
        if input[0] == #char "#"
        {
            elf := array_add(*elves);
            elf.x = x;
            elf.y = y;
            x += 1;
        }
        else if input[0] == #char "."
        {
            x += 1;
        }
        else if input[0] == #char "\n"
        {
            x = 50;
            y += 1;
        }

        advance(*input);
    }

    return elves;
}