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

    paths : [7][23]Path;
    paths[0][ 7] = .{ cost =  3, path = .[ 1 ] };
    paths[0][11] = .{ cost =  4, path = .[ 1, 7 ] };
    paths[0][15] = .{ cost =  5, path = .[ 1, 7, 11 ] };
    paths[0][19] = .{ cost =  6, path = .[ 1, 7, 11, 15 ] };
    paths[1][ 7] = .{ cost =  2, path = .[ ] };
    paths[1][11] = .{ cost =  3, path = .[ 7 ] };
    paths[1][15] = .{ cost =  4, path = .[ 7, 11 ] };
    paths[1][19] = .{ cost =  5, path = .[ 7, 11, 15 ] };
    paths[2][ 7] = .{ cost =  2, path = .[ ] };
    paths[2][11] = .{ cost =  3, path = .[ 7 ] };
    paths[2][15] = .{ cost =  4, path = .[ 7, 11 ] };
    paths[2][19] = .{ cost =  5, path = .[ 7, 11, 15 ] };
    paths[3][ 7] = .{ cost =  4, path = .[ 2 ] };
    paths[3][11] = .{ cost =  5, path = .[ 2, 7 ] };
    paths[3][15] = .{ cost =  6, path = .[ 2, 7, 11 ] };
    paths[3][19] = .{ cost =  7, path = .[ 2, 7, 11, 15 ] };
    paths[4][ 7] = .{ cost =  6, path = .[ 3, 2 ] };
    paths[4][11] = .{ cost =  7, path = .[ 3, 2, 7 ] };
    paths[4][15] = .{ cost =  8, path = .[ 3, 2, 7, 11 ] };
    paths[4][19] = .{ cost =  9, path = .[ 3, 2, 7, 11, 15 ] };
    paths[5][ 7] = .{ cost =  8, path = .[ 4, 3, 2 ] };
    paths[5][11] = .{ cost =  9, path = .[ 4, 3, 2, 7 ] };
    paths[5][15] = .{ cost = 10, path = .[ 4, 3, 2, 7, 11 ] };
    paths[5][19] = .{ cost = 11, path = .[ 4, 3, 2, 7, 11, 15 ] };
    paths[6][ 7] = .{ cost =  9, path = .[ 5, 4, 3, 2 ] };
    paths[6][11] = .{ cost = 10, path = .[ 5, 4, 3, 2, 7 ] };
    paths[6][15] = .{ cost = 11, path = .[ 5, 4, 3, 2, 7, 11 ] };
    paths[6][19] = .{ cost = 12, path = .[ 5, 4, 3, 2, 7, 11, 15 ] };
    paths[0][ 8] = .{ cost =  5, path = .[ 1, 2 ] };
    paths[0][12] = .{ cost =  6, path = .[ 1, 2, 8 ] };
    paths[0][16] = .{ cost =  7, path = .[ 1, 2, 8, 12 ] };
    paths[0][20] = .{ cost =  8, path = .[ 1, 2, 8, 12, 16 ] };
    paths[1][ 8] = .{ cost =  4, path = .[ 2 ] };
    paths[1][12] = .{ cost =  5, path = .[ 2, 8 ] };
    paths[1][16] = .{ cost =  6, path = .[ 2, 8, 12 ] };
    paths[1][20] = .{ cost =  7, path = .[ 2, 8, 12, 16 ] };
    paths[2][ 8] = .{ cost =  2, path = .[ ] };
    paths[2][12] = .{ cost =  3, path = .[ 8 ] };
    paths[2][16] = .{ cost =  4, path = .[ 8, 12 ] };
    paths[2][20] = .{ cost =  5, path = .[ 8, 12, 16 ] };
    paths[3][ 8] = .{ cost =  2, path = .[ ] };
    paths[3][12] = .{ cost =  3, path = .[ 8 ] };
    paths[3][16] = .{ cost =  4, path = .[ 8, 12 ] };
    paths[3][20] = .{ cost =  5, path = .[ 8, 12, 16 ] };
    paths[4][ 8] = .{ cost =  4, path = .[ 3 ] };
    paths[4][12] = .{ cost =  5, path = .[ 3, 8 ] };
    paths[4][16] = .{ cost =  6, path = .[ 3, 8, 12 ] };
    paths[4][20] = .{ cost =  7, path = .[ 3, 8, 12, 16 ] };
    paths[5][ 8] = .{ cost =  6, path = .[ 4, 3 ] };
    paths[5][12] = .{ cost =  7, path = .[ 4, 3, 8 ] };
    paths[5][16] = .{ cost =  8, path = .[ 4, 3, 8, 12 ] };
    paths[5][20] = .{ cost =  9, path = .[ 4, 3, 8, 12, 16 ] };
    paths[6][ 8] = .{ cost =  7, path = .[ 5, 4, 3 ] };
    paths[6][12] = .{ cost =  8, path = .[ 5, 4, 3, 8 ] };
    paths[6][16] = .{ cost =  9, path = .[ 5, 4, 3, 8, 12 ] };
    paths[6][20] = .{ cost = 10, path = .[ 5, 4, 3, 8, 12, 16 ] };
    paths[0][ 9] = .{ cost =  7, path = .[ 1, 2, 3 ] };
    paths[0][13] = .{ cost =  8, path = .[ 1, 2, 3, 9 ] };
    paths[0][17] = .{ cost =  9, path = .[ 1, 2, 3, 9, 13 ] };
    paths[0][21] = .{ cost = 10, path = .[ 1, 2, 3, 9, 13, 17 ] };
    paths[1][ 9] = .{ cost =  6, path = .[ 2, 3 ] };
    paths[1][13] = .{ cost =  7, path = .[ 2, 3, 9 ] };
    paths[1][17] = .{ cost =  8, path = .[ 2, 3, 9, 13 ] };
    paths[1][21] = .{ cost =  9, path = .[ 2, 3, 9, 13, 17 ] };
    paths[2][ 9] = .{ cost =  4, path = .[ 3 ] };
    paths[2][13] = .{ cost =  5, path = .[ 3, 9 ] };
    paths[2][17] = .{ cost =  6, path = .[ 3, 9, 13 ] };
    paths[2][21] = .{ cost =  7, path = .[ 3, 9, 13, 17 ] };
    paths[3][ 9] = .{ cost =  2, path = .[ ] };
    paths[3][13] = .{ cost =  3, path = .[ 9 ] };
    paths[3][17] = .{ cost =  4, path = .[ 9, 13 ] };
    paths[3][21] = .{ cost =  5, path = .[ 9, 13, 17 ] };
    paths[4][ 9] = .{ cost =  2, path = .[ ] };
    paths[4][13] = .{ cost =  3, path = .[ 9 ] };
    paths[4][17] = .{ cost =  4, path = .[ 9, 13 ] };
    paths[4][21] = .{ cost =  5, path = .[ 9, 13, 17 ] };
    paths[5][ 9] = .{ cost =  4, path = .[ 4 ] };
    paths[5][13] = .{ cost =  5, path = .[ 4, 9 ] };
    paths[5][17] = .{ cost =  6, path = .[ 4, 9, 13 ] };
    paths[5][21] = .{ cost =  7, path = .[ 4, 9, 13, 17 ] };
    paths[6][ 9] = .{ cost =  5, path = .[ 5, 4 ] };
    paths[6][13] = .{ cost =  6, path = .[ 5, 4, 9 ] };
    paths[6][17] = .{ cost =  7, path = .[ 5, 4, 9, 13 ] };
    paths[6][21] = .{ cost =  8, path = .[ 5, 4, 9, 13, 17 ] };
    paths[0][10] = .{ cost =  9, path = .[ 1, 2, 3, 4 ] };
    paths[0][14] = .{ cost = 10, path = .[ 1, 2, 3, 4, 9 ] };
    paths[0][18] = .{ cost = 11, path = .[ 1, 2, 3, 4, 9, 13 ] };
    paths[0][22] = .{ cost = 12, path = .[ 1, 2, 3, 4, 9, 13, 17 ] };
    paths[1][10] = .{ cost =  8, path = .[ 2, 3, 4 ] };
    paths[1][14] = .{ cost =  9, path = .[ 2, 3, 4, 9 ] };
    paths[1][18] = .{ cost = 10, path = .[ 2, 3, 4, 9, 13 ] };
    paths[1][22] = .{ cost = 11, path = .[ 2, 3, 4, 9, 13, 17 ] };
    paths[2][10] = .{ cost =  6, path = .[ 3, 4 ] };
    paths[2][14] = .{ cost =  7, path = .[ 3, 4, 9 ] };
    paths[2][18] = .{ cost =  8, path = .[ 3, 4, 9, 13 ] };
    paths[2][22] = .{ cost =  9, path = .[ 3, 4, 9, 13, 17 ] };
    paths[3][10] = .{ cost =  4, path = .[ 4 ] };
    paths[3][14] = .{ cost =  5, path = .[ 4, 9 ] };
    paths[3][18] = .{ cost =  6, path = .[ 4, 9, 13 ] };
    paths[3][22] = .{ cost =  7, path = .[ 4, 9, 13, 17 ] };
    paths[4][10] = .{ cost =  2, path = .[ ] };
    paths[4][14] = .{ cost =  3, path = .[ 9 ] };
    paths[4][18] = .{ cost =  4, path = .[ 9, 13 ] };
    paths[4][22] = .{ cost =  5, path = .[ 9, 13, 17 ] };
    paths[5][10] = .{ cost =  2, path = .[ ] };
    paths[5][14] = .{ cost =  3, path = .[ 9 ] };
    paths[5][18] = .{ cost =  4, path = .[ 9, 13 ] };
    paths[5][22] = .{ cost =  5, path = .[ 9, 13, 17 ] };
    paths[6][10] = .{ cost =  3, path = .[ 5 ] };
    paths[6][14] = .{ cost =  4, path = .[ 5, 9 ] };
    paths[6][18] = .{ cost =  5, path = .[ 5, 9, 13 ] };
    paths[6][22] = .{ cost =  6, path = .[ 5, 9, 13, 17 ] };

    return tprint("%", board1), tprint("%", "");
}

#scope_file

/*
   00 01  02  03  04  05 06
        07  08  09  10
        11  12  13  14
        15  16  17  18
        19  20  21  22
*/

Path :: struct
{
    path : []u8;
    cost : int;
}

rooms : [4][4]u8 : .[
    .[ 7, 11, 15, 19], // room 1 / A
    .[ 8, 12, 16, 20], // room 2 / B
    .[ 9, 13, 17, 21], // room 3 / C
    .[10, 14, 18, 22], // room 4 / D
];