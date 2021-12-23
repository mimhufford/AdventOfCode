day23 :: (data : string) -> string, string
{
    board1: [23]u8;                
    board1[ 7] = data[31];  board1[ 8] = data[33];  board1[ 9] = data[35];  board1[10] = data[37];         
    board1[11] = data[45];  board1[12] = data[47];  board1[13] = data[49];  board1[14] = data[51];         
    board1[15] = #char "A"; board1[16] = #char "B"; board1[17] = #char "C"; board1[18] = #char "D";        
    board1[19] = #char "A"; board1[20] = #char "B"; board1[21] = #char "C"; board1[22] = #char "D";        
    for * board1 if <<it { <<it -= #char "A" - 1; }

    board2: [23]u8;
    board2[ 7] = data[31];  board2[ 8] = data[33];  board2[ 9] = data[35];  board2[10] = data[37];
    board2[11] = #char "D"; board2[12] = #char "C"; board2[13] = #char "B"; board2[14] = #char "A";
    board2[15] = #char "D"; board2[16] = #char "B"; board2[17] = #char "A"; board2[18] = #char "C";
    board2[19] = data[45];  board2[20] = data[47];  board2[21] = data[49];  board2[22] = data[51];
    for * board2 if <<it { <<it -= #char "A" - 1; }

    solve :: (b : []u8)
    {
        for hallway: 0..6 for room: 7..22
        {
            if valid_hallway_to_room(hallway, room)
            {
                // make new state and recurse
            }
            if valid_room_to_hallway(room, hallway)
            {
                // make new state and recurse
            }
        }

        valid_room_to_hallway :: (src: int, dst: int) -> bool #expand
        {
            if b[src] == 0 || b[dst] != 0   return false;
            if homed_and_not_blocking(src)  return false;

            // TODO: check path isn't blocked
            return true;
        }

        valid_hallway_to_room :: (src: int, dst: int) -> bool #expand
        {
            if b[src] == 0 || b[dst] != 0   return false;
            if wrong_room(dst, b[src])      return false;
            if room_not_ready(b[src])       return false;
            if dst != next_room_pos(b[src]) return false;

            // TODO: check path isn't blocked
            return true;
        }

        homed_and_not_blocking :: (i: int) -> bool #expand { if wrong_room(i, b[i]) return false; for < rooms[b[i]-1] if it > i && b[it] != b[i] return false; return true; }
        next_room_pos :: (r: u8) -> u8 #expand { for < rooms[r-1] if b[it] == 0 return it; return 0; }
        room_not_ready :: (r: u8) -> bool #expand { for rooms[r-1] if b[it] != r && b[it] != 0 return true; return false; }
        wrong_room :: (i: int, r: u8) -> bool #expand { return (((i % 4) + 1) % 4) + 1 != r; }
    }

    return tprint("%", board1), tprint("%", "");
}

/*
    00 01  02  03  04  05 06
        07  08  09  10
        11  12  13  14
        15  16  17  18
        19  20  21  22
*/

rooms : [4][4]u8 : .[
    .[ 7, 11, 15, 19], // room 1 / A
    .[ 8, 12, 16, 20], // room 2 / B
    .[ 9, 13, 17, 21], // room 3 / C
    .[10, 14, 18, 22], // room 4 / D
];