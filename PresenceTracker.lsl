#include "Defines.lsl"

list presentAgents;
list buffer;

#include "PresenceLogger.lsl"

ReportAbsent()
{
	integer count = llGetListLength(presentAgents);
	while(count --> 0)
	{
		LogAbsent(llList2Key(presentAgents, count));
	}
	presentAgents = buffer;
	buffer = [];
}
ReportPresent(key id)
{
	integer found = llListFindList(presentAgents, [id]);
	if(found < 0)
	{
		// new actor in region
		buffer += id;
		LogNew(id);
	}
	else
	{
		buffer += id;
		presentAgents = llDeleteSubList(presentAgents, found, found);
	}
}

LogNew(key id)
{
	//llMessageLinked(LINK_SET, PT_AGENT_NEW, "", id);
	AddLog(id, PT_AGENT_NEW);
}
LogAbsent(key id)
{
	//llMessageLinked(LINK_SET, PT_AGENT_ABSENT, "", id);
	AddLog(id, PT_AGENT_LEFT);
}

default
{
	state_entry()
	{
		llListen(VC_CHANNEL, "", NULL_KEY, "");
	}
	listen(integer channel, string name, key id, string message)
	{
		key owner = llGetOwner();
		if((id != owner) && (llGetOwnerKey(id) != owner))
			return;
		
		message = llToLower(message);
		switch(message)
		{
			case VC_READ_PRESENCE_LOG_C:
				llOwnerSay("	=	-	Starting chronological readout	-	=");
				PresentLogChronological();
				llOwnerSay("	-	-	-	-	");
				llOwnerSay("	=	-	End of chronological readout	-	=");
				break;
			case VC_READ_PRESENCE_LOG_ID:
				llOwnerSay("	=	-	Starting readout by ID	-	=");
				PresentLogByID(log);
				llOwnerSay("	-	-	-	-	");
				llOwnerSay("	=	-	End of readout by ID	-	=");
				break;
			case VC_CLEAR_PRESENCE_LOG:
				ClearLog();
				break;
			case VC_DIE:
				llOwnerSay("Deleting...");
				llDie();
			default:
				break;
		}
	}
	link_message(integer sender, integer num, string str, key id)
	{
		switch(num)
		{
			case SC_ACTOR_SCAN_START:
				buffer = [];
				break;
			case SC_ACTOR_SCAN_END:
				ReportAbsent();
				break;
			case SC_ACTOR_SCAN:
				ReportPresent(id);
				break;
			default:
				break;
		}
	}
}