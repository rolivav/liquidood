(c-declare #<<end-of-c-declare

#include <stdio.h>
#include <stdlib.h>
#include <linux/i2c-dev.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

void myfunc (int a) {
  printf ("ASDF: %d\n", a);
}

short x;
short y;
short z;

void process_coordinates () {
    
    int fd;                                          // File descrition
    char *fileName = "/dev/i2c-1";                   // Name of the port we will be using
    int  address = 0x53;                             // Address of the adxl345
    char buf[6];                                     // Buffer for data being read/ written on the i2c bus
    float accel[3];
    double result[3];

    if ((fd = open(fileName, O_RDWR)) < 0) {             // Open port for reading and writing
	printf("Failed to open i2c port\n");
	exit(1);
    }

    if (ioctl(fd, I2C_SLAVE, address) < 0) {             // Set the port options and set the address of the device we wish to speak to
	printf("Unable to get bus access to talk to slave\n");
	exit(1);
    }

    buf[0] = 0x2d;                                       // Commands for performing a ranging
    buf[1] = 0x18;

    if ((write(fd, buf, 2)) != 2) {                      // Write commands to the i2c port
	printf("Error writing to i2c slave\n");
	exit(1);
    }

    buf[0] = 0x31;                                       // Commands for performing a ranging
    buf[1] = 0x09;

    if ((write(fd, buf, 2)) != 2) {                      // Write commands to the i2c port
	printf("Error writing to i2c slave\n");
	exit(1);
    }

    buf[0] = 0x32;                                       // This is the register we wish to read from
    if ((write(fd, buf, 1)) != 1) {                      // Send the register to read from
        printf("Error writing to i2c slave\n");
        exit(1);
    }
    
    // This sleep waits for the ping to come back

    //usleep(100);
    memset(&buf,0,sizeof(buf));
    if (read(fd, buf, 6) != 6) {                         // Read back data into buf[]
        printf("Unable to read from slave\n");
	exit(1);
    }
    else {
	  x=y=z=0;
	  //memset(&buf,0,sizeof(buf));
	  
	  x = ((short)buf[1]<<8) | (short) buf[0];
	  y = ((short)buf[3]<<8) | (short) buf[2];
	  z = ((short)buf[5]<<8) | (short) buf[4];   
	   
	  //printf ("x: %d  y: %d  z: %d \n",x,y,z);

    }
    close(fd);
}

short getX () {
  return x;
}

short getY () {
  return y;
}

short getZ () {
  return z;
}

end-of-c-declare
)

(define myfunc (c-lambda (int) void "myfunc"))


(define printf/ret (c-lambda (char-string) int
			     #<<end-c-lambda

printf ("hey!\n");
printf ("%s\n", ___arg1);
___result = 3;

end-c-lambda
))


(define malloc/s (c-lambda (unsigned-long) (pointer void) "malloc"))

(define processCoordinates (c-lambda () void "process_coordinates"))

(define getX (c-lambda () int "getX"))

(define getY (c-lambda () int "getY"))

(define getZ(c-lambda () int "getZ"))
