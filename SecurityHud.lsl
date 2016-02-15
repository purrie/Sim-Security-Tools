#include "Defines.lsl"

#define ID_CLEAR "~clear"
#define ID_LOG_C "~log_c"
#define ID_LOG_ID "~log_id"
#define ID_LOG_DIE "~die"

integer clearLog;
integer readLogChrono;
integer readLogID;
integer die;

default
{
	state_entry()
	{
		integer num = llGetNumberOfPrims();
		do
		{
			list data = llGetLinkPrimitiveParams(num, [PRIM_DESC]);
			if(llGetListLength(data) > 0)
			{
				string desc = llList2String(data, 0);
				if(llSubStringIndex(desc, ID_CLEAR) >= 0)
					clearLog = num;
				if(llSubStringIndex(desc, ID_LOG_C) >= 0)
					readLogChrono = num;
				if(llSubStringIndex(desc, ID_LOG_ID) >= 0)
					readLogID = num;
				if(llSubStringIndex(desc, ID_LOG_DIE) >= 0)
					die = num;
			}
		}while(--num > 0);
	}
	touch_start(integer num)
	{
		integer button = llDetectedLinkNumber(0);
		
		switch(button)
		{
			case readLogChrono:
				llRegionSay(VC_CHANNEL, VC_READ_PRESENCE_LOG_C);
				break;
			case readLogID:
				llRegionSay(VC_CHANNEL, VC_READ_PRESENCE_LOG_ID);
				break;
			case clearLog:
				llRegionSay(VC_CHANNEL, VC_CLEAR_PRESENCE_LOG);
				break;
			case die:
				llRegionSay(VC_CHANNEL, VC_DIE);
			default:
				break;
		}
	}
}