#include "Defines.lsl"

#define LOG_DATA_SIZE 4
#define LOG_KEY_OFFSET 0
#define LOG_TYPE_OFFSET 1
#define LOG_TIME_OFFSET 2
#define LOG_NAME_OFFSET 3

list log = [];

AddLog(key id, integer type)
{
	log += id;
	log += type;
	log += llGetTimestamp();
	log += llGetDisplayName(id) + " (" + llGetUsername(id) + ")";
}
PresentLogChronological()
{
	integer count = llGetListLength(log);
	integer i = 0;
	for(; i < count; i += LOG_DATA_SIZE)
	{
		string message = "	-	-	-	-	\n";
		key id = llList2Key(log, i + LOG_KEY_OFFSET);
		integer type = llList2Integer(log, i + LOG_TYPE_OFFSET);
		string time = llList2String(log, i + LOG_TIME_OFFSET);
		string name = llList2String(log, i + LOG_NAME_OFFSET);
		
		message += name + "\n";
		switch(type)
		{
			case PT_AGENT_NEW:
				message += "Entered the sim on: ";
				break;
			case PT_AGENT_LEFT:
				message += "Left the sim on: ";
				break;
			default:
				message += "Unexpected value: (" + (string)type + ")";
				break;
		}		
		message += time + "\n";
		
		llOwnerSay(message);
	}
}
PresentLogByID(list recursion)
{
	integer count = llGetListLength(recursion);
	if(count < LOG_DATA_SIZE)
		return;
	
	string message = "	-	-	-	-	\n";
	key id = llList2Key(recursion, 0 + LOG_KEY_OFFSET);
	string name = llList2String(recursion, 0 + LOG_NAME_OFFSET);
	integer type = llList2Integer(recursion, 0 + LOG_TYPE_OFFSET);
	string time = llList2String(recursion, 0 + LOG_TIME_OFFSET);
	
	message += name + "\n";
	switch(type)
	{
		case PT_AGENT_NEW:
			message += "Entered the sim on: ";
			break;
		case PT_AGENT_LEFT:
			message += "Left the sim on: ";
			break;
		default:
			message += "Unexpected value: (" + (string)type + ")";
			break;
	}		
	message += time;
	llOwnerSay(message);
	message = "";
	
	recursion = llDeleteSubList(recursion, 0, LOG_DATA_SIZE - 1);
	
	integer index = 0;
	while((index) < llGetListLength(recursion))
	{
		key idTest = llList2Key(recursion, index + LOG_KEY_OFFSET);
		if(idTest == id)
		{
			type = llList2Integer(recursion, index + LOG_TYPE_OFFSET);
			time = llList2String(recursion, index + LOG_TIME_OFFSET);
			switch(type)
			{
				case PT_AGENT_NEW:
					message += "Entered the sim on: ";
					break;
				case PT_AGENT_LEFT:
					message += "Left the sim on: ";
					break;
				default:
					message += "Unexpected value: (" + (string)type + ")";
					break;
			}		
			message += time + "\n";
			llOwnerSay(message);
			message = "";
			
			recursion = llDeleteSubList(recursion, index, index + LOG_DATA_SIZE - 1);
		}
		else
			index += LOG_DATA_SIZE;
	}
	
	PresentLogByID(recursion);
}
ClearLog()
{
	log = [];
	presentAgents = [];
	llOwnerSay("Logs cleared");
}

