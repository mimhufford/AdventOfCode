day16 :: (data : string) -> string, string
{
    bits : Bit_Array;
    init_bit_array(*bits, data.count * 4);

    for 0..data.count-1
    {
        set4 :: (v: u8) #expand { for b: 0..3 if v & (1 << b) set_bit(*bits, it*4 + 3 - b); }
        if      data[it] >= #char "1" && data[it] <= #char "9" set4(data[it] - #char "0");
        else if data[it] >= #char "A" && data[it] <= #char "F" set4(data[it] - #char "A" + 10);
    }

    parse_packet :: (bits: Bit_Array, start := 0) -> (result: int, consumed: int)
    {
        read_int :: (count: int) -> int #expand
        {
            value : int;
            for 0..count value |= (cast(int)bits[base+it]) << (count - it - 1);
            base += count;
            return value;
        }

        read_literal :: () -> int #expand
        {
            result : int;

            while true
            {
                more  := read_int(1);
                value := read_int(4);
                result = result << 4 | value;
                if !more break;
            }

            return result;
        }

        read_operator :: (type: int) -> int #expand
        {
            results : [..]int;

            length_type := read_int(1);
            if length_type ==
            {
                case 0;
                    length := read_int(15);
                    while length
                    {
                        sub_result, consumed := parse_packet(bits, base);
                        array_add(*results, sub_result);
                        base += consumed;
                        length -= consumed;
                    }
                case 1;
                    sub_packets := read_int(11);
                    while sub_packets
                    {
                        sub_result, consumed := parse_packet(bits, base);
                        array_add(*results, sub_result);
                        base += consumed;
                        sub_packets -= 1;
                    }
                case; assert(false);
            }

            if type ==
            {
                case 0; result := 0; for results result += it; return result;
                case 1; result := 1; for results result *= it; return result;
                case 2; return min(S64_MAX, ..results);
                case 3; return max(S64_MIN, ..results);
                case 5; return cast(int)(results[0]  > results[1]);
                case 6; return cast(int)(results[0]  < results[1]);
                case 7; return cast(int)(results[0] == results[1]);
            }

            assert(false);
        }

        base := start;

        version := read_int(3);
        version_total += version;
        type    := read_int(3);

        if type == 4 return read_literal(),      base - start;
        else         return read_operator(type), base - start;
    }

    result := parse_packet(bits);

    return tprint("%", version_total), tprint("%", result);
}

version_total := 0;