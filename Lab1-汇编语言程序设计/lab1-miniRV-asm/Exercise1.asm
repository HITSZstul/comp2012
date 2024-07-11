MAIN:
    li   sp, 0x10000            # Initialize stack pointer
    csrrwi zero, 0x300, 0x8     # enable externel interrupt

    lui  s1, 0xFFFFF

    li   a0, 0x12345678
    ecall                       # Test ecall

TEST:
    lw   s0, 0x70(s1)           # Read switches
    sw   s0, 0x60(s1)           # Write LEDs
    sw   s0, 0x00(s1)           # Write 7-seg LEDs
    jal  TEST
