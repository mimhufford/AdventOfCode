day18 :: (input: string) -> string, string
{
    drops : [..]Drop;

    while input
    {
        d := array_add(*drops);
        d.x = read_u8(*input); advance(*input);
        d.y = read_u8(*input); advance(*input);
        d.z = read_u8(*input);
    }

    sides := 0;

    for i: 0..drops.count-1
    {
        a := drops[i];
        sides += 6;

        for j: i+1..drops.count-1
        {
            b := drops[j];
            if a.x + 1 == b.x && a.y == b.y && a.z == b.z { sides -= 2; continue; }
            if a.x - 1 == b.x && a.y == b.y && a.z == b.z { sides -= 2; continue; }
            if a.y + 1 == b.y && a.x == b.x && a.z == b.z { sides -= 2; continue; }
            if a.y - 1 == b.y && a.x == b.x && a.z == b.z { sides -= 2; continue; }
            if a.z + 1 == b.z && a.y == b.y && a.x == b.x { sides -= 2; continue; }
            if a.z - 1 == b.z && a.y == b.y && a.x == b.x { sides -= 2; continue; }
        }
    }

    return tprint("%", sides), tprint("%", "");
}

#scope_file

Drop :: struct
{
    x: u8;
    y: u8;
    z: u8;
}