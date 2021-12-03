day3 :: (data: string) -> string, string
{
    all : [..]u16;
    oxy : [..]u16;
    co2 : [..]u16;

    while data.count
    {
        reading : u16;
        for 0..11
        {
            if data[0] - #char "0"  reading += xx (1 << (11 - it));
            advance(*data, 1);
        }
        array_add(*all, reading);
        array_add(*oxy, reading);
        array_add(*co2, reading);
        advance(*data, 1);
    }

    gamma   := 0;
    epsilon := 0;

    for < bit_index : 11 .. cast(u8)0
    {
        mcb := most_common_bit(all, bit_index);
        gamma   +=    mcb  << bit_index;
        epsilon += (1-mcb) << bit_index;
    
        if oxy.count > 1
        {
            mcb := most_common_bit(oxy, bit_index);
            for oxy  if it & (1 << bit_index) >> bit_index != mcb  remove it;
        }
    
        if co2.count > 1
        {
            lcb := 1 - most_common_bit(co2, bit_index);
            for co2  if it & (1 << bit_index) >> bit_index != lcb  remove it;
        }
    }

    return tprint("%", gamma * epsilon), tprint("%", oxy[0] * co2[0]);
}

most_common_bit :: (src : []u16, bit : u8) -> u16
{
    count : u16;

    for src  if it & (1 << bit)  count += 2;

    return xx ifx count >= src.count then 1 else 0;
}