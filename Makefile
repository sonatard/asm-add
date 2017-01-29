BUILD_DIR ?= ./

INCLUDE=$(shell go env GOROOT)/pkg/include
OS=GOOS_$(shell go env GOOS)
ARCH=GOARCH_$(shell go env GOARCH)
PKG=main

#TARGET=$(dir $(CURDIR))
TARGET=asm-add
SRCS := $(shell find . -name *.go -or -name *.s)
OBJS := $(SRCS:%=%.o)

$(info $(TARGET))
$(info $(SRCS))
$(info $(OBJS))


.PHONY: all clean

all: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/$(TARGET): $(BUILD_DIR)/$(TARGET).a
	go tool link -o $@ $^

$(BUILD_DIR)/$(TARGET).a: $(OBJS)
	go tool pack vc $@ $^

$(BUILD_DIR)/%.go.o: %.go
	go tool compile -o $@ -p $(PKG) $^

$(BUILD_DIR)/%.s.o: %.s
	go tool asm -o $@ -I $(INCLUDE) -D $(OS) -D $(ARCH) $^


clean:
	go clean
