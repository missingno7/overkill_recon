#include "HISTORY.H"

void history_store_apply(History *h, const volatile Position *source,
                         volatile Position *const selected[2])
{
    history_store(h, source);
    history_apply(h, selected);
}

void history_update(History *h, const volatile Position *source,
                    volatile Position *const selected[2], u8 input,
                    u16 adjustment)
{
    history_advance(h, input, adjustment);
    history_store_apply(h, source, selected);
}
