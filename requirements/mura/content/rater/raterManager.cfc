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
<cffunction name="init" access="public" returntype="any">
		<cfargument name="configBean" type="any" required="yes">
		<cfargument name="settingsManager" type="any" required="yes">
		
		<cfset variables.configBean=arguments.configBean>
		<cfset variables.settingsManager=arguments.settingsManager>
		<cfset variables.dsn=variables.configBean.getDatasource()/>
		<cfreturn this>
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","rateBean").init(variables.configBean)>
</cffunction>

<cffunction name="getStarText" access="public" output="false" returntype="string">
<cfargument name="avg" type="any" default="" required="yes"/>

	<cfset var num="" />
	<cfset var theAvg=arguments.avg />
	
	<cfif theAvg eq ''>
		<cfset theAvg=0 />
	</cfif>

	<cfscript>
	  if (arguments.avg LTE  0) num = "zero";
	  else if (arguments.avg LT   1) num = "half";
	  else if (arguments.avg LT 1.5) num = "one";
	  else if (arguments.avg LT   2) num = "onehalf";
	  else if (arguments.avg LT 2.5) num = "two";
	  else if (arguments.avg LT   3) num = "twohalf";
	  else if (arguments.avg LT 3.5) num = "three";
	  else if (arguments.avg LT   4) num = "threehalf";
	  else if (arguments.avg LT 4.5) num = "four";  
	  else if (arguments.avg LT   5) num = "fourhalf";
	  else if (arguments.avg GTE  5) num = "five";  
	</cfscript>
 <cfreturn num />
</cffunction>

<cffunction name="saveRate" access="public" output="true" returntype="any">
	<cfargument name="contentID" type="string" default="" required="yes"/>
	<cfargument name="siteID" type="string" default="" required="yes"/>
	<cfargument name="userID" type="string" default="" required="yes"/>
	<cfargument name="rate" type="numeric" default="0" required="yes"/>
	
	<cfset var rating = getBean() />
	<cfset var stats = application.contentManager.getStatsBean() />
	<cfset var rsRating = "" />
	<cfset var ln="l" &replace(arguments.contentID,"-","","all") />
		<cfset rating.setcontentID(arguments.contentID) />
		<cfset rating.setSiteID(arguments.siteID) />
		<cfset rating.setUserID(arguments.userID) />
		<cfset rating.load() />
		<cfset rating.setEntered(now()) />
		<cfset rating.setRate(arguments.rate) />
		<cfset rating.save() />
		
		
		<cfset rsRating=getAvgRating(arguments.contentID,arguments.siteID)/>
		
		
		<cflock name="#ln#" timeout="10">
			<cfset stats.setContentID(arguments.contentID)/>
			<cfset stats.setSiteID(arguments.siteID)/>
			<cfset stats.load()/>
			<cfset stats.setRating(rsRating.theAvg)/>
			<cfset stats.setTotalVotes(rsRating.theCount)/>
			<cfif isNumeric(rsRating.downVotes)>
				<cfset stats.setDownVotes(rsRating.downVotes)/>
			<cfelse>
				<cfset stats.setDownVotes(0)/>
			</cfif>
			<cfset stats.setUpVotes( stats.getTotalVotes()-stats.getDownVotes()) />
			<cfset stats.save()/>
		</cflock>
 <cfreturn rating />
</cffunction>

<cffunction name="readRate" access="public" output="true" returntype="any">
	<cfargument name="contentID" type="string" default="" required="yes"/>
	<cfargument name="siteID" type="string" default="" required="yes"/>
	<cfargument name="userID" type="string" default="" required="yes"/>
	
	<cfset var rating = getBean() />
	
		<cfset rating.setcontentID(arguments.contentID) />
		<cfset rating.setSiteID(arguments.siteID) />
		<cfset rating.setUserID(arguments.userID) />
		<cfset rating.load() />
		
 <cfreturn rating />
</cffunction>

<cffunction name="getAvgRating" access="public" output="true" returntype="query">
	<cfargument name="contentID" type="string" default="" required="yes"/>
	<cfargument name="siteID" type="string" default="" required="yes"/>
	
	<cfset var rs=""/>
	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select avg(tcontentratings.rate) as theAvg, count(tcontentratings.contentID) as theCount, (count(tcontentratings.contentID)-downVotes) as upVotes, downVotes from tcontentratings
	left join (select count(rate) as downVotes, contentID,siteID from tcontentratings
				where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				and contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
				and rate=1
				group by contentID,siteID) qDownVotes
				On (tcontentratings.contentID=qDownVotes.contentID
					and tcontentratings.siteID=qDownVotes.siteID)
	where tcontentratings.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontentratings.contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	group by downVotes
	</cfquery>
		
 <cfreturn rs />
</cffunction>

<cffunction name="getTopRated" access="public" output="true" returntype="query">
	<cfargument name="siteID" type="string" default="" required="yes"/>
	<cfargument name="threshold" type="numeric" default="0" required="yes"/>
	<cfargument name="limit" type="numeric" default="0" required="yes"/>
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs=""/>
	<cfset var stop=""/>
	<cfset var start=""/>
	<cfset var dbType=variables.configBean.getDbType() />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	    <cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	    SELECT <cfif dbType eq "mssql" and arguments.limit>Top #arguments.limit#</cfif> tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active,
	    tcontent.Type, tcontent.OrderNo, tcontent.ParentID, tcontent.siteID,  tcontent.moduleID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy,
		tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, avg(tcontentratings.rate) AS theAvg,
		count(tcontentratings.contentID) AS theCount, tcontent.isfeature,tcontent.inheritObjects,tcontent.target,
		tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,
		tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType
		FROM tcontent INNER JOIN tcontentratings ON tcontent.contentid=tcontentratings.contentid and 
													tcontent.siteid=tcontentratings.siteid
		LEFT JOIN tfiles On tcontent.FileID=tfiles.FileID and tcontent.siteID=tfiles.siteID
		WHERE 
		tcontent.siteid='#arguments.siteid#'
		and   tcontent.Active=1 
		and   (tcontent.Type ='Page'
				or tcontent.Type = 'Component' 
				or tcontent.Type = 'Link'
				or tcontent.Type = 'File' 
				or tcontent.Type = 'Portal'
				or tcontent.Type = 'Calendar'
				or tcontent.Type = 'Form'
				or tcontent.Type = 'Gallery') 
		
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and tcontentratings.entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and tcontentratings.entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and tcontentratings.entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and tcontentratings.entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>	
	
		group by tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename,
		tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, tcontent.siteID, tcontent.moduleID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy,
		tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,
		tcontent.releaseDate,tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType
		
		<cfif arguments.threshold gt 1>
		HAVING count(tcontentratings.contentID) >= #arguments.threshold#
		</cfif>
		
		ORDER BY  theAvg desc, theCount desc 
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=1 </cfif>
	</cfquery>
		
 <cfreturn rs />
</cffunction>
	
</cfcomponent>