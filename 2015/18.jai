day18 :: (data: string) -> string, string
{
    lights_1 := make_bit_array(102*102);
    lights_2 := make_bit_array(102*102);
    next     := *lights_1;
    prev     := *lights_2;

    for y: 1..100
    {
        for x: 1..100
        {
            if data[0] == #char "#" set(x, y);
            advance(*data, 1);
        }

        advance(*data, 1);
    }

    swap();

    swap :: () #expand { t := next; next = prev; prev = t; clear_all_bits(next); }
    set  :: (x: int, y: int)         #expand { set_bit(next, y*102 + x); }
    get  :: (x: int, y: int) -> bool #expand { return (<<prev)[y*102 + x]; }
    
    state :: (x: int, y: int) -> bool, int #expand
    {
        on := 0;

        for dx: -1..1
        {
            for dy: -1..1
            {
                if dx == 0 && dy == 0 continue;
                if get(x+dx, y+dy)  on += 1;
            }
        }

        return get(x, y), on;
    }

    for 1..100
    {
        for y: 1..100
        {
            for x: 1..100
            {
                self, on := state(x, y);

                if self && (on == 2 || on == 3) set(x, y);
                else if !self && on == 3        set(x, y);
            }
        }

        swap();
    }

    count := 0; for <<prev if it count += 1;

    return tprint("%", count), tprint("%", "");
}