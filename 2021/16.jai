day16 :: (data : string) -> string, string
{
    bits : Bit_Array;
    init_bit_array(*bits, data.count * 4);

    for 0..data.count-1
    {
        set :: (b: u8) #expand { set_bit(*bits, it*4+b); }

        if data[it] ==
        {
            case #char "1";                         set(3);
            case #char "2";                 set(2);
            case #char "3";                 set(2); set(3);
            case #char "4";         set(1);
            case #char "5";         set(1);         set(3);
            case #char "6";         set(1); set(2);
            case #char "7";         set(1); set(2); set(3);
            case #char "8"; set(0);
            case #char "9"; set(0);                 set(3);
            case #char "A"; set(0);         set(2);        
            case #char "B"; set(0);         set(2); set(3);
            case #char "C"; set(0); set(1);                
            case #char "D"; set(0); set(1);         set(3);
            case #char "E"; set(0); set(1); set(2);        
            case #char "F"; set(0); set(1); set(2); set(3);
        }
    }

    parse_packet :: (bits: Bit_Array, start := 0) -> (consumed: int, result: int)
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
            length_type := read_int(1);

            results : [..]int;

            if length_type ==
            {
                case 0;
                    length := read_int(15);
                    while length
                    {
                        consumed, sub_result := parse_packet(bits, base);
                        array_add(*results, sub_result);
                        base += consumed;
                        length -= consumed;
                    }
                case 1;
                    sub_packets := read_int(11);
                    while sub_packets
                    {
                        consumed, sub_result := parse_packet(bits, base);
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
                case 2; result := S64_MAX; for results if it < result result = it; return result;
                case 3; result := S64_MIN; for results if it > result result = it; return result;
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

        result := 0;

        if type ==
        {
            case 4; result = read_literal();
            case;   result = read_operator(type);
        }

        return base - start, result;
    }

    consumed, result := parse_packet(bits);

    return tprint("%", version_total), tprint("%", result);
}

version_total := 0;