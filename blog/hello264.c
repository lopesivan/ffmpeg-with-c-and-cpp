#include <stdio.h>
#include <stdlib.h>

/* SQCIF */
#define LUMA_WIDTH 128
#define LUMA_HEIGHT 96
#define CHROMA_WIDTH LUMA_WIDTH / 2
#define CHROMA_HEIGHT LUMA_HEIGHT / 2

/* YUV planar data, as written by ffmpeg */
typedef struct
{
    uint8_t Y[LUMA_HEIGHT][LUMA_WIDTH];
    uint8_t Cb[CHROMA_HEIGHT][CHROMA_WIDTH];
    uint8_t Cr[CHROMA_HEIGHT][CHROMA_WIDTH];
} __attribute__ ((__packed__)) frame_t;

frame_t frame;

/* H.264 bitstreams */
const uint8_t sps[] = { 0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x0a, 0xf8, 0x41, 0xa2 };
const uint8_t pps[] = { 0x00, 0x00, 0x00, 0x01, 0x68, 0xce, 0x38, 0x80 };
const uint8_t slice_header[] = { 0x00, 0x00, 0x00, 0x01, 0x05, 0x88, 0x84, 0x21, 0xa0 };
const uint8_t macroblock_header[] = { 0x0d, 0x00 };

/* Write a macroblock's worth of YUV data in I_PCM mode */
void macroblock (const int i, const int j)
{
    int x, y;

    if (! ((i == 0) && (j == 0)))
    {
        fwrite (&macroblock_header, 1, sizeof (macroblock_header), stdout);
    }

    for (x = i*16; x < (i+1)*16; x++)
        for (y = j*16; y < (j+1)*16; y++)
            fwrite (&frame.Y[x][y], 1, 1, stdout);
    for (x = i*8; x < (i+1)*8; x++)
        for (y = j*8; y < (j+1)*8; y++)
            fwrite (&frame.Cb[x][y], 1, 1, stdout);
    for (x = i*8; x < (i+1)*8; x++)
        for (y = j*8; y < (j+1)*8; y++)
            fwrite (&frame.Cr[x][y], 1, 1, stdout);
}

/* Write out PPS, SPS, and loop over input, writing out I slices */
int main (int argc, char **argv)
{
    int i, j;

    fwrite (sps, 1, sizeof (sps), stdout);
    fwrite (pps, 1, sizeof (pps), stdout);

    while (! feof (stdin))
    {
        fread (&frame, 1, sizeof (frame), stdin);
        fwrite (slice_header, 1, sizeof (slice_header), stdout);

        for (i = 0; i < LUMA_HEIGHT/16 ; i++)
            for (j = 0; j < LUMA_WIDTH/16; j++)
                macroblock (i, j);

        fputc (0x80, stdout); /* slice stop bit */
    }

    return 0;
}
