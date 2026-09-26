; PC hardware facts: ports, bit masks and BIOS data used by the game.

; 8253/8254 PIT. Channel 2 drives the PC speaker; InstallTimerVector08 sets the INT08 rate.
PIT_CHANNEL0_PORT equ 040h
PIT_CHANNEL2_PORT equ 042h
PIT_COMMAND_PORT equ 043h
; Channel 2, low byte then high byte, mode 3 (square wave), binary.
PIT_CH2_SQUARE_WAVE equ 0B6h
; Channel 0 (system timer), low byte then high byte, mode 3.
PIT_CH0_SQUARE_WAVE equ 036h
; InstallTimerVector08 divisor: 1193182/4000h = about 72.8 Hz, four times the BIOS rate.
TIMER_DIVISOR equ 04000h

; 8255 PPI port B: bit 0 gates PIT channel 2, bit 1 enables the speaker, bit 7
; acknowledges the keyboard.
PPI_PORT_B equ 061h
PPI_SPEAKER_BITS equ 003h
PPI_SPEAKER_OFF_MASK equ 0FCh
PPI_KBD_ACK equ 080h

; 8259 PIC and the keyboard controller used by the IRQ1 handler.
PIC1_COMMAND_PORT equ 020h
PIC_EOI_IRQ1 equ 061h
KBD_DATA_PORT equ 060h

; Absolute 0000:041A/041C BIOS keyboard buffer head/tail words (ES=0 at FlushBiosKeyboardBuffer).
BIOS_KBD_BUFFER_HEAD equ 041Ah
BIOS_KBD_BUFFER_TAIL equ 041Ch

; CGA-compatible CRT status register; bit 3 is vertical retrace.
CRT_STATUS_PORT equ 03DAh
CRT_STATUS_VRETRACE equ 008h

; Game port 201h: axes are one-shot bits; buttons read 0 while pressed.
GAME_PORT equ 0201h
GAME_PORT_A_AXES equ 03h
GAME_PORT_A_BUTTON1 equ 010h
GAME_PORT_A_BUTTON2 equ 020h
GAME_PORT_B_BUTTON1 equ 040h
GAME_PORT_B_BUTTON2 equ 080h
