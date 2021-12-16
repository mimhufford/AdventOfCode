day16 :: (data : string) -> string, string
{
    hex := "D2FE28\n";
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

    parse_packet :: (bits: Bit_Array)
    {
        read_3_bit_u8 :: () -> u8 #expand
        {
            value : u8;
            value |= (cast(u8)bits[base+0]) << 2;
            value |= (cast(u8)bits[base+1]) << 1;
            value |= (cast(u8)bits[base+2]) << 0;
            base += 3;
            bits_read += 3;
            return value;
        }

        read_literal :: () -> u64 #expand
        {
            result : u64;

            while true
            {
                finished := !bits[base];
                base += 1;

                value : u8;
                value |= (cast(u8)bits[base+0]) << 3;
                value |= (cast(u8)bits[base+1]) << 2;
                value |= (cast(u8)bits[base+2]) << 1;
                value |= (cast(u8)bits[base+3]) << 0;
                base += 4;

                result <<= 4;
                result |= value;

                bits_read += 5;

                if finished break;
            }

            padding := (4 - bits_read % 4) % 4;
            base += padding;
            print("padding: %\n", padding);

            return result;
        }

        bits_read := 0;
        base := 0;

        version := read_3_bit_u8(); print("version: %\n", version);
        type    := read_3_bit_u8(); print("   type: %\n", type);

        if type ==
        {
            case 4; literal := read_literal(); print("literal: %\n", literal);
        }

    }

    parse_packet(bits);

    return tprint("%", ""), tprint("%", "");
}