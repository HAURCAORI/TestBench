# Project Path
PROJECT_PATH = .

# Library Path
LIB_INCLUDE = ./lib/hdf5_cxx/include
LIB_PATH = ./lib

LIBS = -L$(LIB_PATH)/hdf5_cxx/lib -Wl,--copy-dt-needed-entries,-R$(LIB_PATH)/hdf5_cxx/lib -lhdf5_cpp

#STATIC_LIBS = $(subst lib, -l,$(basename $(notdir $(wildcard $(LIB_PATH)/*/*.a))))
#DYNAMIC_LIBS = $(notdir $(wildcard $(LIB_PATH)/*/*.so.*))
#LIBS = -L$(LIB_PATH)/curl -Wl,-R$(LIB_PATH)/curl -lcurl
#LIBS += -L$(LIB_PATH)/openssl -Wl,-R$(LIB_PATH)/openssl -lssl -lcrypto
#LIBS += -L$(LIB_PATH)/openssl -Wl,-R$(LIB_PATH)/openssl -lssl -lcrypto

# Compiler
CC = g++ -std=c++17

# C++ 컴파일러 옵션
CXXFLAGS = -Wall -O2

# 링커 옵션
LDFLAGS =

# 헤더파일 경로
INCLUDE = -I$(PROJECT_PATH)/include/ -I$(LIB_INCLUDE)

# 소스 파일 디렉토리
SRC_DIR = $(PROJECT_PATH)/src

# 오브젝트 파일 디렉토리
OBJ_DIR = $(PROJECT_PATH)/obj

# 생성하고자 하는 실행 파일 이름
TARGET_DIR = $(PROJECT_PATH)/bin
TARGET = main

# Make 할 소스 파일들
# wildcard 로 SRC_DIR 에서 *.cc 로 된 파일들 목록을 뽑아낸 뒤에
# notdir 로 파일 이름만 뽑아낸다.
# (e.g SRCS 는 foo.cc bar.cc main.cc 가 된다.)
SRCS = $(notdir $(wildcard $(SRC_DIR)/*.cpp))

OBJS = $(SRCS:.cpp=.o)
DEPS = $(SRCS:.cpp=.d)

# OBJS 안의 object 파일들 이름 앞에 $(OBJ_DIR)/ 을 붙인다.
OBJECTS = $(patsubst %.o,$(OBJ_DIR)/%.o,$(OBJS))
DEPS = $(OBJECTS:.o=.d)

all: main

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cpp
	$(CC) $(CXXFLAGS) $(INCLUDE) -c $< -o $@ -MD $(LDFLAGS)

$(TARGET) : $(OBJECTS)
	$(CC) $(CXXFLAGS) -pthread $(OBJECTS) -o $(TARGET_DIR)/$(TARGET) $(LIBS) $(LDFLAGS)

.PHONY: clean all
clean:
	rm -f $(OBJECTS) $(DEPS) $(TARGET)

-include $(DEPS)