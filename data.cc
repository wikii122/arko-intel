typedef 
struct MapaStruct{
	int min;
	int max;
} MapaStruct;

typedef
struct PrzekStruct{
	int x1;
	int y1;
	int x2;
	int y2;
	MapaStruct* ms;
} PrzekStruct;

typedef
struct BMPHeader {
	char bfType[2];
	int bfSize;
	short bfReserved1;
	short bfReserved2;
	int bfOffBits;
} BMPHeader;


int makeMapHeader( BMPHeader* header )
{
	// TODO
}

int makeInterHeader( BMPHeader* header, PrzekStruct ps, int range )
{
	// TODO
}
