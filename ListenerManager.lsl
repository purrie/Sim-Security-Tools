#include "Defines.lsl"

#define EAR_NAME "ear"
#define LISTEN_OFFSET 10000

list ears;
list following;
list suspects;
list blacklist;

key query = NULL_KEY;

ListenTo(key id)
{
	vector pos = llGetPos();
	llRezObject(EAR_NAME, pos, ZERO_VECTOR, ZERO_ROTATION, llGetListLength(ears) + LISTEN_OFFSET );
	ears += llListen(llGetListLength(ears)+1, "", NULL_KEY, "");
	following += id;
}
PopulateBlacklist()
{
	blacklist = 
	[
		"ab7251d3-d257-43a5-a89f-f73e6f471da6", // ღϯSƙïε Ŧαℓℓєηϯღ (AnnabelLM)
		"97c81fe1-d81e-43d5-abf4-1b7d6d7a627e", // Lizzie  (kawaiichan4312) 
		"e49f304f-8736-485b-af11-adc2b3f2c468", //  Ặίđȼη ΉãVФȻ (bwalla813)
		"c0a17a47-2500-44af-9996-37c8db8d68ef" // TheMrsAiden
	];
}

default
{
	state_entry()
	{
		PopulateBlacklist();
	}
	listen(integer channel, string name, key id, string message)
	{
		integer index = channel - LISTEN_OFFSET;
		llListenRemove(llList2Integer(ears, index));
		ears = llDeleteSubList(ears, index, index);
		ears = llListInsertList(ears, [id], index);
		llSay(channel, (string) llList2Key(following, index));
	}
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
			key id = llList2Key(suspects, 0);
			integer follow = FALSE;
			
			if(llListFindList(blacklist, [id]) >= 0)
			{
				follow = TRUE;
			}
			else if(year >= 2015)
			{
				if((month >= 10) && (day >= 6))
				{
					follow = TRUE;
				}
			}
			if(follow)
			{
				ListenTo(id);
			}
			
			suspects = llDeleteSubList(suspects, 0, 0);
			query = llRequestAgentData(llList2Key(suspects, 0), DATA_BORN);
		}
	}
}
