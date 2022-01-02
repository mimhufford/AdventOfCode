day4 :: (data: string) -> string, string
{
    real_id_sum   := 0;
    north_pole_id := 0;

    while data.count
    {
        freq : [26]int;
        alphabet := u8.[97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122];
        id := 0;
        room_name : string = ---;
        checksum : string = ---;
        room_name.count = 0;
        room_name.data = data.data;
        checksum.count = 0;

        // read room name
        while data[0] < #char "0" || data[0] > #char "9"
        {
            if data[0] != #char "-" freq[data[0] - #char "a"] += 1;
            room_name.count += 1;
            advance(*data, 1);
        }

        // read id
        while data[0] >= #char "0" && data[0] <= #char "9"
        {
            id *= 10;
            id += data[0] - #char "0";
            advance(*data, 1);
        }
        advance(*data, 1);

        // read checksum
        checksum.data = data.data;
        while data[0] != #char "]"
        {
            checksum.count += 1;
            advance(*data, 1);
        }
        advance(*data, 2);

        // sort frequencies
        for j: 0..24 for i: 0..24-j
        {
            if freq[i] < freq[i+1]
            {
                Swap(*freq[i], *freq[i+1]);
                Swap(*alphabet[i], *alphabet[i+1]);
            }
        }

        // check if real room
        if memcmp(alphabet.data, checksum.data, 5) == 0  real_id_sum += id;

        if !north_pole_id
        {
            // caesar that shit
            for 0..room_name.count-2
            {
                if room_name[it] == #char "-" continue;
                room_name[it] -= 97;
                room_name[it] += xx (id % 26);
                room_name[it] %= 26;
                room_name[it] += 97;
            }

            if room_name == "northpole-object-storage-"  north_pole_id = id;
        }
    }

    return tprint("%", real_id_sum), tprint("%", north_pole_id);
}