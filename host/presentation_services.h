#ifndef OVERKILL_HOST_PRESENTATION_SERVICES_H
#define OVERKILL_HOST_PRESENTATION_SERVICES_H

#include "platform_services.h"

/* Native implementations of original DOS presentation entries and their C bridges. */
int presentation_dispatch(word token, HostRegisters *registers);
void presentation_title_draw_logo_piece(word row_column, word image_index);
word presentation_title_merge_reveal_cell(void);
void presentation_title_flash_reveal_cell(void);
void presentation_title_show_reveal_cell(void);
dword presentation_raw_print_text_char(word bp, word es, word character,
                                       word di, word *result_di);
void presentation_draw_panel(word row_column, word image_index);
void presentation_draw_panel_row(word image_index, word copies,
                                 word screen_offset, word *result_screen_offset);
void presentation_capture_screen_row(word screen_segment, word workspace_segment,
                                     word source_offset, word workspace_offset,
                                     word adapter);
void presentation_finish_screen_capture(word adapter);
void presentation_draw_stretch_frame(word drawer, word source_segment,
                                     word screen_segment, word bp,
                                     word state_segment,
                                     word *result_bp, word *result_es);
int presentation_text_mode_active(void);
word presentation_text_segment(void);
void presentation_text_mode_leave(void);
void presentation_set_text_mode3(word hide_cursor);
void presentation_text_set_cursor(word row, word column);
void presentation_text_get_cursor(word *row, word *column);
int presentation_text_cursor_visible(void);
void presentation_print_dos_string_at_bp(word bp);
void presentation_present_exit_order(void);
void presentation_draw_hiscore_entry(void);
void presentation_draw_quit_prompt(void);

#endif
