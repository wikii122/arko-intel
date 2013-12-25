#include <stdio.h>
#include "data.cc"
#define SIZE 201*201
#define SINGLE 1
#define PIXEL_SIZE 3

extern "C" int mapa( int* mapa, unsigned char* image, MapaStruct* par);
extern "C" int przekroj( int* mapa,  unsigned char* image, PrzekStruct* przek );

int main( int argc, char** argv )
{
	int map[SIZE];
	int value, range, indx, indy;
	char filename[20];
	MapaStruct ms;
	BMPHeader header;
	FILE* file;

	if( argc != 3 )
	{
		printf( "Usage:\n\tbin map intersection\n" );
		return 0;
	}
	
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
	indx = ms.x2>ms.x1? ms.x2-ms.x1:ms.x1-ms.x2;
	indy = ms.y2>ms.y1? ms.y2-ms.y1:ms.y1-ms.y2;
	range = indx>indy? indx:indy;

	unsigned char mapBMP[3 * SIZE];
	mapa( map, mapBMP, &ms );
	int len = 3*range*(ms.max-ms.min);
	unsigned char interBMP[len];
	//przekroj( map, interBMP, &ms );

	file = fopen( filename, "w+" );
	makeMapHeader( &header ); 
	fwrite( &header, sizeof(BMPHeader), SINGLE, file );
	fwrite( &mapBMP, PIXEL_SIZE, SIZE, file );
	fclose( file );

	//file = fopen( argv[2], "w+" );
	//makeInterHeader( &header, ms, range );
	//fwrite( &header, sizeof(BMPHeader), SINGLE, file );
	//fwrite( &interBMP, PIXEL_SIZE, range*(ms.max-ms.min), file );
	//fclose( file );

	return 0;
}


