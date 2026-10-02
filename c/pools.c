/* Shared record-pool and random-word helpers. The cursors remain original DS offsets;
   GAME_PTR/GAME_OFFSET provide typed access without changing that stored representation.

   SEGMENT: CGAME
   OWNS: NextRandomWord FindFreeRecordPoolA FindFreeRecordPoolB
*/
#include "game.h"

/* The next word of the fixed 16-word CreditRandomWords cycle (the credit text read as
   words): the cursor steps by 2 and wraps at CreditRandomWords + 31. */
word next_random_word(void)
{
    RandomWordCursor += 2;
    if (RandomWordCursor >= GAME_OFFSET(CreditRandomWords + 31))
        RandomWordCursor = GAME_OFFSET(CreditRandomWords);
    return *GAME_PTR(word, RandomWordCursor);
}

/* Round robin from PoolACursor for a free record (REC_STATUS 0); it becomes the new
   PoolACursor but is not claimed. NO_RECORD when all POOL_A_COUNT records are busy. The
   wrap test is equality with PoolAEnd, as in the oracle. */
Record *find_free_record_pool_a(void)
{
    Record *r = GAME_PTR(Record, PoolACursor);
    word n = POOL_A_COUNT;

    do {
        if (r->status == 0) {
            PoolACursor = GAME_OFFSET(r);
            return r;
        }
        if (++r == (Record *)PoolAEnd) r = POOL_A;
    } while (--n != 0);
    return NO_RECORD;
}

/* Round robin from PoolBCursor for a free record, saved as the new cursor (not claimed);
   NO_RECORD when all POOL_B_COUNT are busy (the cursor is then unchanged). The wrap to
   PoolB is tested before each read, so a cursor equal to PoolBEnd is accepted. */
Record *find_free_record_pool_b(void)
{
    word at = PoolBCursor, n = POOL_B_COUNT;

    do {
        if (at == GAME_OFFSET(PoolBEnd)) at = GAME_OFFSET(PoolB);
        if (GAME_PTR(Record, at)->status == 0) {
            PoolBCursor = at;
            return GAME_PTR(Record, at);
        }
        at += RECORD_SIZE;
    } while (--n);
    return NO_RECORD;
}
