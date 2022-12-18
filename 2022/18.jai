day18 :: (input: string) -> string, string
{
    drops : Table(u32, void);

    while input
    {
        d : Drop;
        d.x = read_u8(*input); advance(*input);
        d.y = read_u8(*input); advance(*input);
        d.z = read_u8(*input);
        v : drops.Value_Type;
        table_add(*drops, d.hash, v);
    }

    sides := 0;

    for drops
    {
        sides += 6;
        d : Drop;
        d.hash = it_index;
        d.x += 1; if table_find_pointer(*drops, d.hash) sides -= 1; d.x -= 1;
        d.x -= 1; if table_find_pointer(*drops, d.hash) sides -= 1; d.x += 1;
        d.y += 1; if table_find_pointer(*drops, d.hash) sides -= 1; d.y -= 1;
        d.y -= 1; if table_find_pointer(*drops, d.hash) sides -= 1; d.y += 1;
        d.z += 1; if table_find_pointer(*drops, d.hash) sides -= 1; d.z -= 1;
        d.z -= 1; if table_find_pointer(*drops, d.hash) sides -= 1; d.z += 1;
    }

    return tprint("%", sides), tprint("%", "");
}

#scope_file

Drop :: struct
{
    x: u8;
    y: u8;
    z: u8;
    #place x;
    hash: u32;
}