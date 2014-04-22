/*****************************************************************************
 * x264: h264 encoder/decoder testing program.
 *****************************************************************************
 * Copyright (C) 2003 Laurent Aimar
 * $Id: x264.c,v 1.1 2004/06/03 19:24:12 fenrir Exp $
 *
 * Authors: Laurent Aimar <fenrir@via.ecp.fr>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
 *****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <math.h>

#include <signal.h>
#define _GNU_SOURCE
//#include <getopt.h>

#ifdef _MSC_VER
#include <io.h>     /* _setmode() */
#include <fcntl.h>  /* _O_BINARY */
#endif

#ifdef AVIS_INPUT
#include <windows.h>
#include <vfw.h>
#endif

#ifdef MP4_OUTPUT
#include <gpac/m4_author.h>
#endif

#include "common/common.h"
//#include "config.h"
#include "x264.h"

#define DATA_MAX 3000000
uint8_t data[DATA_MAX];

typedef void *hnd_t;

/* Ctrl-C handler */
static int     i_ctrl_c = 0;
static void    SigIntHandler(int a)
{
	i_ctrl_c = 1;
}

static int  write_frame_yuv(x264_t *h, x264_picture_t *p_pic, hnd_t handle);

static int  Decode(x264_param_t  *param, FILE *fh26l, hnd_t hout);

/****************************************************************************
 * main:
 ****************************************************************************/
int main(int argc, char **argv)
{
	x264_param_t param;

	FILE   *hout;
	FILE   *hin;

	int     b_decompress = 1;
	//int     b_progress;
	int     i_ret;

#ifdef _MSC_VER
	_setmode(_fileno(stdin), _O_BINARY);    /* thanks to Marcos Morais <morais at dee.ufcg.edu.br> */
	_setmode(_fileno(stdout), _O_BINARY);
#endif

	x264_param_default(&param);

#if 0

	/* Parse command line */
	if (Parse(argc, argv, &param, &hin, &hout, &b_decompress, &b_progress) < 0) {
		return -1;
	}

#else
	hin = fopen(argv[1], "rb");

	if (!hin) {
		printf("cannot open file\n");
		return -1;
	}

	hout = fopen(argv[2], "wb");

	if (!hout) {
		printf("cannot write file\n");
		return -1;
	}

#endif

	/* Control-C handler */
	//signal( SIGINT, SigIntHandler );

	i_ret = Decode(&param, hin, hout);
	//getchar();

	return i_ret;
}

/*****************************************************************************
 * Decode:
 *****************************************************************************/
static int  Decode(x264_param_t  *param, FILE *fh26l, hnd_t hout)
{
	x264_t *h;
	x264_nal_t nal;
	x264_picture_t *pic;
	int i_data;
	int b_eof;

	//param.cpu = 0;
	if ((h = x264_decoder_open(param)) == NULL) {
		fprintf(stderr, "x264_decoder_open failed\n");
		return -1;
	}

	b_eof = 0;
	i_data  = 0;
	nal.p_payload = malloc(DATA_MAX);

	while (!i_ctrl_c) {
		uint8_t *p, *p_next, *end;
		int i_size;

		/* fill buffer */
		if (i_data < DATA_MAX && !b_eof) {
			int i_read = fread(&data[i_data], 1, DATA_MAX - i_data, fh26l);

			if (i_read <= 0) {
				b_eof = 1;
			}

			else {
				i_data += i_read;
			}
		}

		if (i_data < 3) {
			break;
		}

		end = &data[i_data];

		/* extract one nal */
		p = &data[0];

		while (p < end - 3) {
			if (p[0] == 0x00 && p[1] == 0x00 && p[2] == 0x01) {
				break;
			}

			p++;
		}

		if (p >= end - 3) {
			fprintf(stderr, "garbage (i_data = %d)\n", i_data);
			i_data = 0;
			continue;
		}

		p_next = p + 3;

		while (p_next < end - 3) {
			if (p_next[0] == 0x00 && p_next[1] == 0x00 && p_next[2] == 0x01) {
				break;
			}

			p_next++;
		}

		if (p_next == end - 3 && i_data < DATA_MAX) {
			p_next = end;
		}

		/* decode this nal */
		i_size = p_next - p - 3;

		if (i_size <= 0) {
			if (b_eof) {
				break;
			}

			fprintf(stderr, "nal too large (FIXME) ?\n");
			i_data = 0;
			continue;
		}

		x264_nal_decode(&nal, p + 3, i_size);
		//fprintf( stderr, "idc %d type %d\n", nal.i_ref_idc, nal.i_type);

		/* decode the content of the nal */
		x264_decoder_decode(h, &pic, &nal);

		if (pic) {
			write_frame_yuv(h, pic, hout);
		}

		memmove(&data[0], p_next, end - p_next);
		i_data -= p_next - &data[0];
	}

	x264_flush_dpb(h , &pic);

	if (pic) {
		write_frame_yuv(h, pic, hout);
	}

	//i_end = x264_mdate();
	free(nal.p_payload);
	fprintf(stderr, "\n");

	x264_decoder_close(h);

	fclose(fh26l);

	if (hout != stdout) {
		fclose(hout);
	}

	return 0;
}

static int  write_frame_yuv(x264_t *h, x264_picture_t *p_pic, hnd_t handle)
{
	FILE *f = (FILE *)handle;
	uint8_t *p_dst_y, *p_dst_u, *p_dst_v;
	int i;

	p_dst_y = p_pic->img.plane[0];

	for (i = 0; i < p_pic->i_height; i++) {
		fwrite(p_dst_y, p_pic->i_width, 1, f);
		p_dst_y += p_pic->img.i_stride[0];
	}

	p_dst_u = p_pic->img.plane[1];

	for (i = 0; i < p_pic->i_height / 2; i++) {
		fwrite(p_dst_u, p_pic->i_width / 2, 1, f);
		p_dst_u += p_pic->img.i_stride[1];
	}

	p_dst_v = p_pic->img.plane[2];

	for (i = 0; i < p_pic->i_height / 2; i++) {
		fwrite(p_dst_v, p_pic->i_width / 2, 1, f);
		p_dst_v += p_pic->img.i_stride[2];
	}

#if 0

	if (p_pic->i_poc == 20) {
		int i, j;
		uint8_t *dst_y, *dst_u, *dst_v;

		for (i = 0 ; i < h->sps->i_mb_height ; i ++) {
			for (j = 0 ; j < h->sps->i_mb_width ; j ++) {
				int k, l;
				x264_log(h, X264_LOG_DEBUG, "mb %d\n", i * (h->sps->i_mb_width) + j);

				dst_y = p_pic->img.plane[0] + (i << 4) * p_pic->img.i_stride[0] + (j << 4);
				dst_u = p_pic->img.plane[1] + (i << 3) * p_pic->img.i_stride[1] + (j << 3);
				dst_v = p_pic->img.plane[2] + (i << 3) * p_pic->img.i_stride[2] + (j << 3);

				for (k = 0 ; k < 16 ; k++) {
					for (l = 0 ; l < 16 ; l++) {
						x264_log(h, X264_LOG_DEBUG, "%3d ", dst_y[l]);
					}

					x264_log(h, X264_LOG_DEBUG, "\n");
					dst_y += p_pic->img.i_stride[0];
				}

#if 0

				for (k = 0 ; k < 8 ; k++) {
					for (l = 0 ; l < 8 ; l++) {
						x264_log(h, X264_LOG_DEBUG, "%3d ", dst_u[l]);
					}

					x264_log(h, X264_LOG_DEBUG, "\n");
					dst_u += p_pic->img.i_stride[1];
				}

				for (k = 0 ; k < 8 ; k++) {
					for (l = 0 ; l < 8 ; l++) {
						x264_log(h, X264_LOG_DEBUG, "%3d ", dst_v[l]);
					}

					x264_log(h, X264_LOG_DEBUG, "\n");
					dst_v += p_pic->img.i_stride[2];
				}

#endif
			}
		}
	}

#endif

	return 0;
}
