day16 :: (data : string) -> string, string
{
    // hex := "D2FE28\n";
    // hex := "38006F45291200\n";
    // hex := "EE00D40C823060\n";
    hex := data;
    hex.count -= 1; // remove \n

    #import "Bit_Array";
    bits : Bit_Array;
    init_bit_array(*bits, hex.count * 4);

    for 0..hex.count-1
    {
        set :: (b: u8) #expand { set_bit(*bits, it*4+b); }

        if hex[it] ==
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

    parse_packet :: (bits: Bit_Array, start := 0) -> int
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

                result <<= 4;
                result |= value;

                if !more break;
            }

            // The padding is only on the main packet, so I think I can just ignore it (for now?)
            // if start == 0  // only outmost packet is padded
            // {
            //     padding := (4 - ((base - start) % 4)) % 4;
            //     base += padding;
            //     print("padding: %\n", padding);
            // }

            return result;
        }

        read_operator :: () #expand
        {
            length_type := read_int(1);
            // print("len typ: %\n", length_type);

            if length_type ==
            {
                case 0;
                    length := read_int(15);
                    // print(" length: %\n", length);
                    while length
                    {
                        consumed := parse_packet(bits, base);
                        // print("consumed: %\n", consumed);
                        base += consumed;
                        length -= consumed;
                    }
                case 1;
                    sub_packets := read_int(11);
                    // print("sub pks: %\n", sub_packets);
                    while sub_packets
                    {
                        consumed := parse_packet(bits, base);
                        // print("consumed: %\n", consumed);
                        base += consumed;
                        sub_packets -= 1;
                    }
                case; assert(false);
            }
        }

        base := start;

        version := read_int(3);
        // print("version: %\n", version);
        version_total += version;
        type    := read_int(3);
        //print("   type: %\n", type);

        if type ==
        {
            case 4;
                literal := read_literal();
                //print("literal: %\n", literal);
            case  ; read_operator();
        }

        return base - start;
    }

    parse_packet(bits);

    return tprint("%", version_total), tprint("%", "");
}

version_total := 0;