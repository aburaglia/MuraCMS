<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","#variables.instance.configBean.getMapDir()#.advertising.adZone.adZoneBean").init()>
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
	<cfargument name="adZoneBean" type="any" />
	 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	insert into tadzones (adZoneID,siteid,dateCreated, lastupdate,lastupdateBy,name,creativeType,notes,isActive,height,width)
	values (
	'#arguments.adZoneBean.getAdZoneID()#',
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getsiteID()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(isDate(arguments.adZoneBean.getDateCreated()),de('no'),de('yes'))#" value="#arguments.adZoneBean.getDateCreated()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(isDate(arguments.adZoneBean.getLastUpdate()),de('no'),de('yes'))#" value="#arguments.adZoneBean.getLastUpdate()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getLastUpdateBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getName()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getCreativeType() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getCreativeType()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.adZoneBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getNotes()#">,
	#arguments.adZoneBean.getIsActive()#,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getHeight()),de(arguments.adZoneBean.getHeight()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getWidth()),de(arguments.adZoneBean.getWidth()),de(0))#">
	)
	</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="AdZoneID" type="string" />

	<cfset var adZoneBean=getBean() />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	Select * from tadzones where 
	adZoneID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adZoneID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset adZoneBean.set(rs) />
	</cfif>
	
	<cfreturn adZoneBean />
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="adZoneBean" type="any" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	update tadzones set
	lastUpdate = <cfif isDate(arguments.adZoneBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.adZoneBean.getLastUpdate()#"><cfelse>null</cfif>,
	lastupdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getlastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getLastUpdateBy()#">,
	name = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getName()#">,
	creativeType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getCreativeType() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getCreativeType()#">,
	isActive = #arguments.adZoneBean.getIsActive()#,
	notes= <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.adZoneBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getNotes()#">,
	height = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getHeight()),de(arguments.adZoneBean.getHeight()),de(0))#">,
	width = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getWidth()),de(arguments.adZoneBean.getWidth()),de(0))#">
	where adZoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adZoneBean.getAdZoneID()#" />
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="adZoneID" type="String" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadzones 
	where adZoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adZoneID#" />
	</cfquery>

</cffunction>

</cfcomponent>
