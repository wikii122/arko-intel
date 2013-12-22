#include <stdio.h>
#include "data.cc"
#define SIZE 201*201
#define SINGLE 1

extern "C" int mapa( int* mapa, unsigned char* image, MapaStruct* par);
extern "C" int przekroj( int* mapa,  unsigned char* image, PrzekStruct* przek );

int main( int argc, char** argv )
{
	int map[SIZE];
	int value, range, indx, indy;
	MapaStruct ms;
	PrzekStruct ps;
	BMPHeader header;
	FILE* file;

	if( argc != 2 )
	{
		printf( "Usage:\n\tbin map intersection\n" );
		return 0;
	}
	
	file = fopen( "mapa.txt", "r" );
	for( int i=0; i<SIZE; i++ ) 
	{
		fscanf( file, "%d", &value );
		map[i] = value;
	}
	fclose( file );

	file = fopen( "parametry.txt", "r" );
	fscanf( file, "%d %d", &ps.x1, &ps.y1 );
	fscanf( file, "%d %d", &ps.x2, &ps.y2 );
	fscanf( file, "%d", &ms.min );
	fscanf( file, "%d", &ms.max );
	fclose( file );
	ps.ms = &ms;
	indx = ps.x2>ps.x1? ps.x2-ps.x1:ps.x1-ps.x2;
	indy = ps.y2>ps.y1? ps.y2-ps.y1:ps.y1-ps.y2;
	range = indx>indy? indx:indy;

	unsigned char mapBMP[3 * SIZE];
	mapa( map, mapBMP, &ms );
	unsigned char interBMP[3*range*(ms.max-ms.min)];
	przekroj( map, interBMP, &ps );

	file = fopen( argv[1], "w+" );
	makeMapHeader( &header ); 
	fwrite( &header, sizeof(BMPHeader), SINGLE, file );
	fwrite( &mapBMP, 3, SIZE, file );
	fclose( file );

	file = fopen( argv[2], "w+" );
	makeInterHeader( &header, ps, range );
	fwrite( &header, sizeof(BMPHeader), SINGLE, file );
	fwrite( &interBMP, 3, range*(ms.max-ms.min), file );
	fclose( file );

	return 0;
}


