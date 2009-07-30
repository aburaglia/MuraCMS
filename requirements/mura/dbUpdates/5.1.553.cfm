<!--- make sure tcontent.urltitle and tcontent.htmltitle exists --->

<cfset doUpdate=false>

<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select urltitle from tcontent  where 0=1
</cfquery>
<cfcatch>
<cfset doUpdate=true>
</cfcatch>
</cftry>

<cfif doUpdate>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD urltitle [ntext] NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD htmltitle [ntext] NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN urltitle longtext
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN htmltitle longtext
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENT" ADD ("URLTITLE" clob)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENT" ADD ("HTMLTITLE" clob)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	update tcontent set
	urltitle=menutitle,
	htmltitle=title
</cfquery>

</cfif>