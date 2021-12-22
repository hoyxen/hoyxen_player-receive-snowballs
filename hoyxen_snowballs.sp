#include <sourcemod>
#include <sdktools>
#include <multicolors>
#include <autoexecconfig>

#pragma newdecls required
#pragma semicolon 1

ConVar gConVar_Join_Message;
ConVar gConVar_ReceiveSnowballs_Message;

public Plugin myinfo = 
{
	name = "Snowballs", 
	author = "hoyxen", 
	description = "Player receive 3x Snowballs", 
	version = "1.0", 
	url = "http://steamcommunity.com/id/hoyxen"
};

public void OnPluginStart()
{
	LoadTranslations("hoyxen_snowballs.phrases");
	
	RegConsoleCmd("sm_snow", Cmd_Snowballs);
	RegConsoleCmd("sm_snowball", Cmd_Snowballs);
	RegConsoleCmd("sm_snowballs", Cmd_Snowballs);
	
	AutoExecConfig_SetFile("hoyxen_snowballs_config");
	
	gConVar_Join_Message = AutoExecConfig_CreateConVar("sm_hoyxen_snowballs_join_message", "1", "Enable/Disable the message when player join (1 - Enable | 0 - Disable)", 0, true, 0.0, true, 1.0);
	gConVar_ReceiveSnowballs_Message = AutoExecConfig_CreateConVar("sm_hoyxen_receive_snowballs_message", "1", "Enable/Disable the message when player receive Snowballs (1 - Enable | 0 - Disable)", 0, true, 0.0, true, 1.0);
	
	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();
}

public void OnClientPutInServer(int client)
{
	CreateTimer(10.0, Join_Message, client);
}

public Action Join_Message(Handle timer, any client)
{
	if (gConVar_Join_Message.BoolValue)
		CPrintToChat(client, "%t", "Join Message");
} 

public Action Cmd_Snowballs(int client, int args)
{
    if(IsValidClient(client))	{
	if (gConVar_ReceiveSnowballs_Message.BoolValue)
		CPrintToChat(client, "%t", "Receive Snowballs"),
		StripAllSnowBalls(client),
		GivePlayerItem(client, "weapon_snowball"),
		GivePlayerItem(client, "weapon_snowball"),
		GivePlayerItem(client, "weapon_snowball");
    }
}

stock void StripAllSnowBalls(int client)
{
	int m_hMyWeapons_size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
	int item; 
	char classname[64];
	
	for(int index = 0; index < m_hMyWeapons_size; index++) 
	{ 
		item = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", index); 

		if(item != -1 && GetEntityClassname(item, classname, sizeof(classname)) && StrEqual(classname, "weapon_snowball")) 
		{ 
			RemovePlayerItem(client, item);
			AcceptEntityInput(item, "Kill");
		} 
	} 
}


bool IsValidClient(int client)	{
	if(client == 0)
		return	false;
	if(client < 1 || client > MaxClients)
		return	false;
	if(!IsClientInGame(client))
		return	false;
	if(!IsClientConnected(client))
		return	false;
	if(!IsPlayerAlive(client))
		return	false;
	if(IsFakeClient(client))
		return	false;
	if(IsClientReplay(client))
		return	false;
	if(IsClientSourceTV(client))
		return	false;
	return	true;
}