#include "Defines.lsl"

#define EAR_NAME "ear"

list ears;
list following;
list suspects;

key query = NULL_KEY;

ListenTo(key id)
{
}

default
{
	link_message(integer sender, integer num, string str, key id)
	{
		if(num == SC_ACTOR_SCAN)
		{
			integer index = llListFindList(following, [id]);
			if(index < 0)
			{
				// not following, test it
				if(llListFindList(suspects, [id]) < 0)
					suspects += id;
			}
		}
		else if(num == SC_ACTOR_SCAN_END)
		{
			if(llGetListLength(suspects) > 0)
				query = llRequestAgentData(llList2Key(suspects, 0), DATA_BORN);
		}
	}
	dataserver(key queryid, string data)
	{
		if(queryid == query)
		{
			list date = llParseString2List(data, ["-"], []);
			integer year = (integer)llList2String(date, 0);
			integer month = (integer)llList2String(date, 1);
			integer day = (integer)llList2String(date, 2);
			
			if(year >= 2015)
			{
				if((month >= 10) && (day >= 6))
				{
					ListenTo(llList2Key(suspects, 0));
				}
			}
			suspects = llDeleteSubList(suspects, 0, 0);
			query = llRequestAgentData(llList2Key(suspects, 0), DATA_BORN);
		}
	}
}
