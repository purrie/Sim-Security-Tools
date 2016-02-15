#include "Defines.lsl"

float scanInterval = 1.0;

default
{
	state_entry()
	{
		llSetTimerEvent(scanInterval);
	}
	
	timer()
	{
		list actors = llGetAgentList(AGENT_LIST_REGION, []);
		llMessageLinked(LINK_SET, SC_ACTOR_SCAN_START, "", NULL_KEY);
		integer count = llGetListLength(actors);
		while( count --> 0 )
		{
			llMessageLinked(LINK_SET, SC_ACTOR_SCAN, "", llList2Key(actors, count));
		}
		llMessageLinked(LINK_SET, SC_ACTOR_SCAN_END, "", NULL_KEY);
	}
}
