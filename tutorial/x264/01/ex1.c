/* x264: h264 encoder/decoder testing program */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "stdint.h"
#include "iostream.h"

#include <math.h>

#include <signal.h>
#define _GNU_SOURCE

#ifdef _MSC_VER
#include <io.h>     /* _setmode() */
#include <fcntl.h>  /* _O_BINARY */
#endif

#include "x264.h"
#include "common.h"

#define DATA_MAX 3000000
uint8_t data[DATA_MAX];

/* Ctrl-C handler */
static int     i_ctrl_c = 0;
static void    SigIntHandler( int a )
{
    i_ctrl_c = 1;
}

/****************************************************************************
 * main:
 ****************************************************************************/
void main()
{
    x264_t *h;             /////  x264_
    x264_param_t param;    /////  x264_param_t
    x264_picture_t *pic;   ////   x264_picture

    FILE    *fyuv;
    FILE    *fout = stdout;
    int     i_frame, i_frame_total;
    int64_t i_start, i_end;
    int64_t i_file;

#ifdef _MSC_VER
    _setmode(_fileno(stdin), _O_BINARY);    /* thanks to Marcos Morais <morais at dee.ufcg.edu.br> */
    _setmode(_fileno(stdout), _O_BINARY);
#endif

    x264_param_default( m );                           /////

                                                           /
    if( ( fyuv = fopen("d:\\mother_daughter_qcif.yuv", "rb" ) ) == NULL )
    {
        cout<<"could not open yuv input file"<<endl;;

    }
    int64_t i_size = ftell( fyuv );

    if( ( fout = fopen("d:\\out.h264", "wb" ) ) == NULL )
    {
        cout<<"cannot open output file"<<endl;
    }

    param.i_width = 176;
    param.i_height = 144;

    i_frame_total = 0;
    if( !fseek( fyuv, 0, SEEK_END ) )
    {
        int64_t i_size = ftell( fyuv );
        fseek( fyuv, 0, SEEK_SET );
        i_frame_total = i_size / ( param.i_width * param.i_height * 3 / 2 );  //Í¼Ïó×ÜÕìÊý
    }

    if( ( h = x264_encoder_open( ¶m ) ) == NULL )  // x264_encoder

    {
        cout<< "x264_encoder_open failed"<<endl;
    }

    pic = x264_picture_new( h );

    i_start = x264_mdate();

    for( i_frame = 0, i_file = 0; i_ctrl_c == 0 ; i_frame++ )
    {
        int         i_nal;
        x264_nal_t  *nal;

        int         i;

        /* read a frame */
        if( fread( pic->plane[0], 1, param.i_width * param.i_height, fyuv ) <= 0 ||
            fread( pic->plane[1], 1, param.i_width * param.i_height / 4, fyuv ) <= 0 ||
            fread( pic->plane[2], 1, param.i_width * param.i_height / 4, fyuv ) <= 0 )
        {
            break;
        }
                         //  x264_encoder_encode
                         //      x264_picture_new
        if( x264_encoder_encode( h, &nal, &i_nal, pic ) < 0 )
        {
            fprintf( stderr, "x264_encoder_encode failed\n" );
        }

        for( i = 0; i < i_nal; i++ )
        {
            int i_size;
            int i_data;

            i_data = DATA_MAX; // x264_nal_encode
            if( ( i_size = x264_nal_encode( data, &i_data, 1, &nal[i] ) ) > 0 )
            {
                i_file += fwrite( data, 1, i_size, fout );
            }
            else if( i_size < 0 )
            {
                fprintf( stderr,"need to increase buffer size (size=%d)\n", -i_size );
            }
        }
    }

    i_end = x264_mdate();
    x264_picture_delete( pic );
    x264_encoder_close( h );
    fprintf( stderr, "\n" );

    fclose( fyuv );
    if( fout != stdout )
    {
        fclose( fout );
    }

    if( i_frame > 0 )
    {
        double fps = (double)i_frame * (double)1000000 /(double)( i_end - i_start );
        fprintf( stderr, "encoded %d frames %ffps %lld kb/s\n", i_frame, fps, i_file * 8 * 25 / i_frame / 1000 );
    }
}
