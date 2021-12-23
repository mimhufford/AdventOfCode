day23 :: (data : string) -> string, string
{
    /*
      The board is defined as 23 positions, 0-22.
      The 4 positions above rooms are not stored.
      The board for part 1 has ABCD in the bottom 2 rows.
      
          00 01  02  03  04  05 06
               07  08  09  10
               11  12  13  14
               15  16  17  18
               19  20  21  22
    */

    board1: [23]u8;                
    board1[ 7] = data[31];  board1[ 8] = data[33];  board1[ 9] = data[35];  board1[10] = data[37];         
    board1[11] = data[45];  board1[12] = data[47];  board1[13] = data[49];  board1[14] = data[51];         
    board1[15] = #char "A"; board1[16] = #char "B"; board1[17] = #char "C"; board1[18] = #char "D";        
    board1[19] = #char "A"; board1[20] = #char "B"; board1[21] = #char "C"; board1[22] = #char "D";        

    board2: [23]u8;
    board2[ 7] = data[31];  board2[ 8] = data[33];  board2[ 9] = data[35];  board2[10] = data[37];
    board2[11] = #char "D"; board2[12] = #char "C"; board2[13] = #char "B"; board2[14] = #char "A";
    board2[15] = #char "D"; board2[16] = #char "B"; board2[17] = #char "A"; board2[18] = #char "C";
    board2[19] = data[45];  board2[20] = data[47];  board2[21] = data[49];  board2[22] = data[51];

    return tprint("%", ""), tprint("%", "");
}