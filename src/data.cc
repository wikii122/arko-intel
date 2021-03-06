typedef 
struct MapaStruct{
	int min;
	int max;
	int x1;
	int x2;
	int y1;
	int y2;
} MapaStruct;

typedef MapaStruct PrzekStruct;

#pragma pack(push)
#pragma pack(1)
typedef
struct BMPHeader {
	unsigned char bfType[2];
	unsigned int bfSize;
	unsigned short bfReserved1;
	unsigned short bfReserved2;
	unsigned int bfOffBits;
	unsigned int biSize;
	int biWidth;
	int biHeigth;
	unsigned short biPlanes;
	unsigned short biBitCount;
	unsigned int biCompression;
	unsigned int biSizeImage;
	int biXPelsPerMeter;
	int biYPelsPerMeter;
	unsigned int biClrUsed;
	unsigned int biClrImportant;
} BMPHeader;
#pragma pack(pop)

int makeMapHeader( BMPHeader* header )
{
	header->bfType[0] = 'B';
	header->bfType[1] = 'M';
	header->bfSize = sizeof(BMPHeader) + (3*201*201); // TODO: Check.
	header->bfReserved1 = 0;
	header->bfReserved2 = 0;
	header->bfOffBits = sizeof(BMPHeader); // TODO: Check.
	header->biSize = 40;
	header->biWidth = 201;
	header->biHeigth = 201;
	header->biPlanes = 1;
	header->biBitCount = 24;
	header->biCompression = 0; // TODO: Check.
	header->biSizeImage = 0;
	header->biXPelsPerMeter = 0;
	header->biYPelsPerMeter = 0;
	header->biClrUsed = 0;
	header->biClrImportant = 0;
	
	return 0;
}

int makeInterHeader( BMPHeader* header, PrzekStruct ps, int range )
{
	header->bfType[0] = 'B';
	header->bfType[1] = 'M';
	header->bfSize = sizeof(BMPHeader) + (3*400*range); // TODO: Check.
	header->bfReserved1 = 0;
	header->bfReserved2 = 0;
	header->bfOffBits = sizeof(BMPHeader); // TODO: Check.
	header->biSize = 40;
	header->biWidth = range;
	header->biHeigth = 400;
	header->biPlanes = 1;
	header->biBitCount = 24;
	header->biCompression = 0; // TODO: Check.
	header->biSizeImage = 0;
	header->biXPelsPerMeter = 0;
	header->biYPelsPerMeter = 0;
	header->biClrUsed = 0;
	header->biClrImportant = 0;
	
	return 0;
}
