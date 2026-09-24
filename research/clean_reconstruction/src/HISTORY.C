#include "HISTORY.H"

void history_init(History *h, const volatile Position *source)
{
    unsigned i;
    volatile Position *dst;
    for (i = 0; i < HISTORY_COUNT; ++i) {
        dst = &h->samples[i];
        dst->y = (u16)(source->y + 8);
        dst->x = (u16)(source->x + 9);
    }
    h->cursor[HISTORY_WRITE] = 0;
    h->cursor[HISTORY_DELAY_15] = HISTORY_COUNT - 15;
    h->cursor[HISTORY_DELAY_31] = HISTORY_COUNT - 31;
    h->cursor[HISTORY_OTHER_47] = HISTORY_COUNT - 47;
}

void history_advance(History *h, u8 input, u16 adjustment)
{
    unsigned i;
    if (!(input & 15) && !adjustment) return;
    for (i = 0; i < HISTORY_CURSORS; ++i) {
        ++h->cursor[i];
        if (h->cursor[i] == HISTORY_COUNT) h->cursor[i] = 0;
    }
}

void history_store(History *h, const volatile Position *source)
{
    volatile Position *dst = &h->samples[h->cursor[HISTORY_WRITE]];
    dst->y = (u16)(source->y + 8);
    dst->x = (u16)(source->x + 8);
}

void history_apply(History *h, volatile Position *const selected[2])
{
    const volatile Position *sample;
    if (selected[0]) {
        sample = &h->samples[h->cursor[HISTORY_DELAY_15]];
        selected[0]->y = sample->y;
        selected[0]->x = sample->x;
    }
    if (selected[1]) {
        sample = &h->samples[h->cursor[HISTORY_DELAY_31]];
        selected[1]->y = sample->y;
        selected[1]->x = sample->x;
    }
}
