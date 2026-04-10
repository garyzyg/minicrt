CC = cl.exe
LIB = link.exe /lib

CFLAGS = /nologo /O1 /GS- /c
LFLAGS = /nologo

TARGET = minicrt.lib

OBJS = \
!IF "$(Platform)" == "x86"
!IF [(for %i in (*.obj) do @echo | set /p="%~i " >> objs.tmp) & ver > nul] == 0
!INCLUDE objs.tmp
!ENDIF
!ENDIF

SRCS = \
!IF [(for /f "delims=" %i in ('dir /b *.c *.cc *.cpp ^| findstr /v /i /c:"_hello.cc" /c:"string.cc"') do @echo | set /p="%~i " >> srcs.tmp) & ver > nul] == 0
!INCLUDE srcs.tmp
!ENDIF

OBJS = $(OBJS) $(SRCS:.cc=.obj)
OBJS = $(OBJS:.cpp=.obj)
OBJS = $(OBJS:.c=.obj)

all: $(TARGET)

$(TARGET): $(OBJS)
    $(LIB) $(LFLAGS) /OUT:$@ $**

.c.obj:
    $(CC) $(CFLAGS) $<

.cc.obj:
    $(CC) $(CFLAGS) $<

.cpp.obj:
    $(CC) $(CFLAGS) $<

clean:
    del /Q $(OBJS) $(TARGET) objs.tmp srcs.tmp
