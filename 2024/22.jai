day22 :: (input: string) -> string, string
{
    part1 := 0;
    while input part1 += generate(read_s64(*input));
    part2 := best_price;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

best_price, index := 0;
price_for_seq : [19*19*19*19]u16;
last_update : [19*19*19*19]u16;

generate :: (seed: s64) -> s64
{
    index += 1;
    v3, v4 := 0, seed;
    d1, d2, d3, d4 := 0, 0, 0, 0;

    for 1..2000
    {
        v3 = v4;
        v4 ^= v4 << 6;  v4 &= 0xFFFFFF;
        v4 ^= v4 >> 5;
        v4 ^= v4 << 11; v4 &= 0xFFFFFF;
        d1, d2, d3, d4 = d2, d3, d4, (v4 % 10 - v3 % 10) + 9;

        if it > 3
        {
            seq := d1*19*19*19 + d2*19*19 + d3*19 + d4;
            if last_update[seq] == index continue;
            last_update[seq] = xx index;
            price_for_seq[seq] += xx (v4 % 10);
            best_price = max(best_price, price_for_seq[seq]);
        }
    }

    return v4;
}

wip_simd_version :: (data: string) -> s64, s64
{
    result := 0;

    while data
    {
        mask : s32 = 0xFFFFFF; mask_ptr := *mask;
        curr : [8]s32; curr_ptr := curr.data;
        for 0..7 curr[it] = read_s32(*data);

        for 1..2000
        {
            #asm AVX, AVX2 {
                pbroadcastd m:, [mask_ptr];  // broadcast the mask into m
                movdqu      v:, [curr_ptr];  // load curr into v
                pslld       t:, v, 6;        // t = v << 6
                pxor        v, v, t;         // v ^= t
                pand        v, v, m;         // v &= 0xFFFFFF
                psrld       t, v, 5;         // t = v >> 5
                pxor        v, v, t;         // v ^= t
                pslld       t, v, 11;        // t = v << 11
                pxor        v, v, t;         // v ^= t
                pand        v, v, m;         // v &= 0xFFFFFF
                movdqu      [curr_ptr], v;   // save v back into curr
            }
        }

        for curr result += it;
    }
    
    return result, 0;
}