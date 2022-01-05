day19 :: (data: string) -> string, string
{
    input := string_to_int(data);

    input <<= 1;
    input |= 1;
    input &= ~(1 << (bit_scan_reverse(input)-1));

    return tprint("%", input), tprint("%", "");
}