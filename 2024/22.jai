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
    best_price, index := 0;
    price_for_seq : [19*19*19*19]u16;
    last_update : [19*19*19*19]u16;

    while data
    {
        dv10 : float32 = 10.0; dv10_ptr := *dv10;
        imm9 : float32 = 9.0;  imm9_ptr := *imm9;
        mask : s32 = 0xFFFFFF; mask_ptr := *mask;
        curr : [8]s32; curr_ptr := curr.data;
        dif1 : [8]s32; dif1_ptr := dif1.data;
        dif2 : [8]s32; dif2_ptr := dif2.data;
        dif3 : [8]s32; dif3_ptr := dif3.data;
        dif4 : [8]s32; dif4_ptr := dif4.data;
        for 0..7 curr[it] = read_s32(*data);

        for 1..2000
        {
            #asm AVX, AVX2 {
                pbroadcastd m:, [mask_ptr];  // broadcast the mask into m
                movdqu      v:, [curr_ptr];  // load curr into v
                movdqu      p:, v;           // copy curr into p
                pslld       t:, v, 6;        // t = v << 6
                pxor        v, v, t;         // v ^= t
                pand        v, v, m;         // v &= 0xFFFFFF
                psrld       t, v, 5;         // t = v >> 5
                pxor        v, v, t;         // v ^= t
                pslld       t, v, 11;        // t = v << 11
                pxor        v, v, t;         // v ^= t
                pand        v, v, m;         // v &= 0xFFFFFF
                movdqu      [curr_ptr], v;   // save v back into curr

                movdqu      d1:, [dif1_ptr];
                movdqu      d2:, [dif2_ptr];
                movdqu      d3:, [dif3_ptr];
                movdqu      d4:, [dif4_ptr];

                movdqu      [dif1_ptr], d2;
                movdqu      [dif2_ptr], d3;
                movdqu      [dif3_ptr], d4;

                // d4 = (v % 10 - p % 10) + 9;

                broadcastss d:, [dv10_ptr];  // broadcast 10.0 into d
                cvtdq2ps    d4, v;           // d4 = v as float 32s
                divps       d410:, d4, d;    // d410 = d4 / 10
                roundps     d410, d410, 1;   // d410 = floor(d410)
                mulps       d410, d410, d;   // d410 *= 10
                subps       d4, d4, d410;    // d4 -= d410

                cvtdq2ps    t, p;            // t = p as float 32s
                divps       d410, t, d;      // d410 = t / 10
                roundps     d410, d410, 1;   // d410 = floor(d410)
                mulps       d410, d410, d;   // d410 *= 10
                subps       t, t, d410;      // t -= d410

                broadcastss d, [imm9_ptr];   // broadcast 9.0 into d
                subps       d4, d4, t;
                addps       d4, d4, d;

                cvtps2dq    d4, d4;          // d4 = d4 as int 32s

                movdqu      [dif1_ptr], d1;
                movdqu      [dif2_ptr], d2;
                movdqu      [dif3_ptr], d3;
                movdqu      [dif4_ptr], d4;
            }

            if it < 4 continue;

            for 0..7
            {
                seq := dif1[it]*19*19*19 + dif2[it]*19*19 + dif3[it]*19 + dif4[it];
                if last_update[seq] == index continue;
                last_update[seq] = xx index;
                price_for_seq[seq] += xx (curr[it] % 10);
                best_price = max(best_price, price_for_seq[seq]);
            }
        }

        for curr result += it;
    }

    return result, best_price;
}