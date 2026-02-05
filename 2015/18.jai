day18 :: (data: string) -> string, string
{
    orig     := make_bit_array(102*102);
    lights_1 := make_bit_array(102*102);
    lights_2 := make_bit_array(102*102);
    next     := *lights_1;
    prev     := *lights_2;
    
    swap :: () #expand { t := next; next = prev; prev = t; clear_all_bits(next); }
    set  :: (x: int, y: int)         #expand { set_bit(next, y*102 + x); }
    get  :: (x: int, y: int) -> bool #expand { return prev.*[y*102 + x]; }

    for y: 1..100
    {
        for x: 1..100
        {
            if data[0] == #char "#" set(x, y);
            advance(*data, 1);
        }

        advance(*data, 1);
    }

    for lights_1 if it set_bit(*orig, it_index);

    swap();

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

    count_1 := 0; for prev.* if it count_1 += 1;

    clear_all_bits(*lights_1);
    clear_all_bits(*lights_2);
    for orig if it set_bit(*lights_1, it_index);
    prev = *lights_1;
    next = *lights_2;

    for 1..100
    {
        for y: 1..100
        {
            for x: 1..100
            {
                set_bit(next,   1*102 +   1); set_bit(prev,   1*102 +   1);
                set_bit(next,   1*102 + 100); set_bit(prev,   1*102 + 100);
                set_bit(next, 100*102 +   1); set_bit(prev, 100*102 +   1);
                set_bit(next, 100*102 + 100); set_bit(prev, 100*102 + 100);
                self, on := state(x, y);

                if self && (on == 2 || on == 3) set(x, y);
                else if !self && on == 3        set(x, y);
            }
        }

        swap();
    }

    count_2 := 0; for prev.* if it count_2 += 1;

    return tprint("%", count_1), tprint("%", count_2);
}