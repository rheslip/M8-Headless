#include <string.h>

#include "config.h"
#include "low_battery.h"
#include "gpu.h"
#include "spi.h"

#ifdef LOW_BATTERY_PIN
// this is confusing because X and Y are swapped from convention
#define LOW_BATTERY_ICON_TOP_LEFT_X 42
#define LOW_BATTERY_ICON_TOP_LEFT_Y 273
#define LOW_BATTERY_ICON_WIDTH 11
#define LOW_BATTERY_ICON_HEIGHT 20
#define FULL_BATTERY_FORE_COLOR 65535 // white
//#define LOW_BATTERY_FORE_COLOR 0x00ff  // blue
#define LOW_BATTERY_FORE_COLOR 0xf000  // Red
#define LOW_BATTERY_BACK_COLOR 0

static bool lowBattery = false;
static bool threeqBattery = false;
static bool halfBattery = false;
static uint64_t lowBatteryLastPolled = 0;

/*
// Battery icon from: https://github.com/martinohanlon/grrl-bat-monitor
static uint16_t lowBatteryIcon [LOW_BATTERY_ICON_HEIGHT][LOW_BATTERY_ICON_WIDTH] = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};
*/
/* building block lines for new icons
        {0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 1},
		{1, 0, 1, 1, 1, 0, 1},
		{1, 1, 1, 1, 1, 1, 1},
*/

static uint16_t lowBatteryIcon [LOW_BATTERY_ICON_HEIGHT][LOW_BATTERY_ICON_WIDTH] = {
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
	
		};

static uint16_t fullBatteryIcon [LOW_BATTERY_ICON_HEIGHT][LOW_BATTERY_ICON_WIDTH] = {
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},	
		};

static uint16_t threeqBatteryIcon [LOW_BATTERY_ICON_HEIGHT][LOW_BATTERY_ICON_WIDTH] = {
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},	
		};

static uint16_t halfBatteryIcon [LOW_BATTERY_ICON_HEIGHT][LOW_BATTERY_ICON_WIDTH] = {
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},	
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},	
		};
		
void InitLowBatterySystem()
{
  for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y)
    for(int x = 0; x < LOW_BATTERY_ICON_WIDTH; ++x)
      lowBatteryIcon[y][x] = lowBatteryIcon[y][x] ? LOW_BATTERY_FORE_COLOR : LOW_BATTERY_BACK_COLOR;
  for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y)  // RH added new icons
    for(int x = 0; x < LOW_BATTERY_ICON_WIDTH; ++x)
      fullBatteryIcon[y][x] = fullBatteryIcon[y][x] ? FULL_BATTERY_FORE_COLOR : LOW_BATTERY_BACK_COLOR;
  for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y)  // 
    for(int x = 0; x < LOW_BATTERY_ICON_WIDTH; ++x)
      threeqBatteryIcon[y][x] = threeqBatteryIcon[y][x] ? FULL_BATTERY_FORE_COLOR : LOW_BATTERY_BACK_COLOR;
  for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y)  // 
    for(int x = 0; x < LOW_BATTERY_ICON_WIDTH; ++x)
      halfBatteryIcon[y][x] = halfBatteryIcon[y][x] ? FULL_BATTERY_FORE_COLOR : LOW_BATTERY_BACK_COLOR;	  
  PollLowBattery();
}

void PollLowBattery()
{
  uint64_t now = tick();
  if (now - lowBatteryLastPolled > LOW_BATTERY_POLLING_INTERVAL)
  {
    lowBattery = GET_GPIO(LOW_BATTERY_PIN) ? LOW_BATTERY_IS_ACTIVE_HIGH : !LOW_BATTERY_IS_ACTIVE_HIGH;
    halfBattery = GET_GPIO(HALF_BATTERY_PIN) ? LOW_BATTERY_IS_ACTIVE_HIGH : !LOW_BATTERY_IS_ACTIVE_HIGH;
    threeqBattery = GET_GPIO(THREEQ_BATTERY_PIN) ? LOW_BATTERY_IS_ACTIVE_HIGH : !LOW_BATTERY_IS_ACTIVE_HIGH;
    lowBatteryLastPolled = now;
  }
}



void DrawLowBatteryIcon(uint16_t *framebuffer)
{ // inputs go low sequentially so check from last to first
  if (lowBattery) {
	for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y) {
		int framebuffer_start_offset = (LOW_BATTERY_ICON_TOP_LEFT_Y+y)*(gpuFramebufferScanlineStrideBytes>>1)+LOW_BATTERY_ICON_TOP_LEFT_X;
		memcpy(framebuffer+framebuffer_start_offset, lowBatteryIcon[y], LOW_BATTERY_ICON_WIDTH*2);
	}
	return; 
  }
  if (halfBattery) {
	for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y) {
		int framebuffer_start_offset = (LOW_BATTERY_ICON_TOP_LEFT_Y+y)*(gpuFramebufferScanlineStrideBytes>>1)+LOW_BATTERY_ICON_TOP_LEFT_X;
		memcpy(framebuffer+framebuffer_start_offset, halfBatteryIcon[y], LOW_BATTERY_ICON_WIDTH*2);
	}
	return; 
  }  
  if (threeqBattery) {
	for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y) {
		int framebuffer_start_offset = (LOW_BATTERY_ICON_TOP_LEFT_Y+y)*(gpuFramebufferScanlineStrideBytes>>1)+LOW_BATTERY_ICON_TOP_LEFT_X;
		memcpy(framebuffer+framebuffer_start_offset, threeqBatteryIcon[y], LOW_BATTERY_ICON_WIDTH*2);
	}
	return; // for now just do low battery icon
  }  
  else {
// full battery - all inputs high
	for(int y = 0; y < LOW_BATTERY_ICON_HEIGHT; ++y) {
		int framebuffer_start_offset = (LOW_BATTERY_ICON_TOP_LEFT_Y+y)*(gpuFramebufferScanlineStrideBytes>>1)+LOW_BATTERY_ICON_TOP_LEFT_X;
		memcpy(framebuffer+framebuffer_start_offset, fullBatteryIcon[y], LOW_BATTERY_ICON_WIDTH*2);
	}
	return;
  }
}
	  
  
  
  
#else 
  
void InitLowBatterySystem() {}
void PollLowBattery() {}  
void DrawLowBatteryIcon(uint16_t *framebuffer) {}

#endif