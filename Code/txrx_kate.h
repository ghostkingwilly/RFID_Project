#include <stdio.h>
#include <complex>
#include <cmath>
#include <fstream>

#include <stdint.h>
#include <gnuradio/gr_complex.h>

using namespace std;
#ifndef FLEXNEMO
#define FLEXNEMO

// USRP
#define C_FLOAT32 	uhd::io_type_t::COMPLEX_FLOAT32
#define R_ONE_PKT	uhd::device::RECV_MODE_ONE_PACKET
#define S_ONE_PKT	uhd::device::SEND_MODE_ONE_PACKET
#define STOP 		uhd::stream_cmd_t::STREAM_MODE_STOP_CONTINUOUS
#define START 		uhd::stream_cmd_t::STREAM_MODE_START_CONTINUOUS

// System setting 
const size_t WARM_UP_TIME	= 1000;	//ms
const size_t DEBUG			= 0;

const double RECV_SEC = 0.2; //TODO: receive length may be much longer


const size_t SYM_LEN	= 100;// 100->50
const size_t MAX_PKT_LEN = 13000; // TODO: set to the query and ack size
const size_t MAX_QUE_LEN = 7000;
const size_t MAX_ACK_LEN = 6000; 
//const size_t MAX_ACK_LEN = 7000; 
//const size_t QUERY_SIZE = 4000;

//set the query
const size_t QUERY_SIZE = 6810;//6754
const size_t ACK_SIZE = 10000;//5379 5400 7000
//const size_t ACK_SIZE = 6800;
const int QUERY_CODE[4] = {1,0,0,0};
// QueryAdjust command
const int QADJ_CODE[4]  = {1,0,0,1};
// 110 Increment by 1, 000 unchanged, 010 decrement by 1
const int Q_UPDN[3][3]  = { {1,1,0}, {0,0,0}, {0,1,0} };
// ACK command
const int ACK_CODE[2]   = {0,1};

const int DR            = 0;
const int FIXED_Q       = 0;
const int TREXT         = 0;
const int TARGET        = 0;
const int M[2]          = {0,0};
const int SEL[2]        = {0,0};
const int SESSION[2]    = {0,0};
const int Q_VALUE [16][4] =  
{
    {0,0,0,0}, {0,0,0,1}, {0,0,1,0}, {0,0,1,1}, 
    {0,1,0,0}, {0,1,0,1}, {0,1,1,0}, {0,1,1,1}, 
    {1,0,0,0}, {1,0,0,1}, {1,0,1,0}, {1,0,1,1},
    {1,1,0,0}, {1,1,0,1}, {1,1,1,0}, {1,1,1,1}
}; 
const int POS_PREAMBLE[]={1,1,-1,1,-1,-1,1,-1,-1,-1,1,1};
const int NEG_PREAMBLE[] = {-1,-1,1,-1,1,1,-1,1,1,1,-1,-1};

const int WINDOW_SIZE = 10000;// 8000->10000
const int MOVING_WIN = 100;// 100 -> 50
const int dac_rate = 1e6;
const int decim = 5;
const int adc_rate = 2e6;
const int WIN_SIZE_D   = 250;
const int DELIM_D       = 12;      // A preamble shall comprise a fixed-length start delimiter 12.5us +/-5%
const int TRCAL_D     = 200;    // BLF = DR/TRCAL => 40e3 = 8/TRCAL => TRCAL = 200us
const int T1_D         = 240;    // Time from Interrogator transmission to Tag response (250 us)
const int T2_D         = 480;    // Time from Tag response to Interrogator transmission. Max value = 20.0 * T_tag = 500us 
const int RN16_BITS          = 17;  // Dummy bit at the end
const int EPC_BITS            = 129;  // PC + EPC + CRC16 + Dummy = 6 + 16 + 96 + 16 + 1 = 135
const int TAG_PREAMBLE_BITS  = 6;   // Number of preamble bits
const int T_READER_FREQ = 40e3;     // BLF = 40kHz
const float TAG_BIT_D   = 1.0/T_READER_FREQ * pow(10,6); // Duration in us
const int PW_D         = 12;      // Half Tari 
const int CW_D         = 250;    // Carrier wave
const int P_DOWN_D     = 2000;    // power down
const int NUM_PULSES_COMMAND = 4; // 5

const int RN16_D        = (RN16_BITS + TAG_PREAMBLE_BITS) * TAG_BIT_D;
const int EPC_D          = (EPC_BITS  + TAG_PREAMBLE_BITS) * TAG_BIT_D;



const size_t RX_WND_SIZE 	= 4000;
#endif
