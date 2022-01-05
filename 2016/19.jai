day19 :: (data: string) -> string, string
{
    part_1 := string_to_int(data);

    part_1 <<= 1;
    part_1 |= 1;
    part_1 &= ~(1 << (bit_scan_reverse(part_1)-1));

    part_2 := string_to_int(data);
    i := 1;
    while i*3 < part_2 i *= 3;
    part_2 -= i;

    return tprint("%", part_1), tprint("%", part_2);
}