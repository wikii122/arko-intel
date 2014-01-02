#include <stdio.h>
#include <math.h>
#include "data.cc"
#define SIZE 202*201
#define SINGLE 1
#define PIXEL_SIZE 3

extern "C" int mapa( int* mapa, unsigned char* image, MapaStruct* par);
extern "C" int przekroj( int* mapa,  unsigned char* image, PrzekStruct* przek );

int main( int argc, char** argv )
{
	int map[SIZE];
	int value, range;
	MapaStruct ms;
	BMPHeader header;
	FILE* file;

	//if( argc != 1 )
	//{
	//	printf( "Usage:\n\tbin map intersection\n" );
	//	return 0;
	//}
	
	file = fopen( "mapa.txt", "r" );
	if( file==NULL )
	{
		printf( "File mapa.txt does not exist." );
		return 1;
	}
	for( int i=0; i<SIZE; i++ ) 
	{
		fscanf( file, "%d", &value );
		map[i] = value;
	}
	fclose( file );

	file = fopen( "parametry.txt", "r" );
	if( file==NULL )
	{
		printf( "File parametry.txt does not exist." );
		return 1;
	}
	fscanf( file, "%d %d", &ms.x1, &ms.y1 );
	fscanf( file, "%d %d", &ms.x2, &ms.y2 );
	fscanf( file, "%d", &ms.min );
	fscanf( file, "%d", &ms.max );
	fclose( file );
	if( ms.min > ms.max )
	{
		printf( "Wrong parameters!" );
		return 0;
	}
	range = pow((double)(ms.x2 - ms.x1), 2.0) + pow((double)(ms.y2 - ms.y1), 2.0);
	range = sqrt( range );
	if(!range) range = 1;

	unsigned char mapBMP[3 * SIZE];
	mapa( map, mapBMP, &ms );
	int len = 3*400*range;
	ms.min = range;
	unsigned char interBMP[len];
	przekroj( map, interBMP, &ms );

	file = fopen( "mapa.bmp", "w+" );
	makeMapHeader( &header ); 
	fwrite( &header, sizeof(BMPHeader), SINGLE, file );
	fseek( file, sizeof(BMPHeader), SEEK_SET );
	fwrite( &mapBMP, PIXEL_SIZE, SIZE, file );
	fclose( file );

	file = fopen( "przekroj.bmp", "w+" );
	makeInterHeader( &header, ms, range );
	fwrite( &header, sizeof(BMPHeader), SINGLE, file );
	fseek( file, sizeof(BMPHeader), SEEK_SET );
	fwrite( &interBMP, PIXEL_SIZE, range*400, file );
	fclose( file );

	return 0;
}


