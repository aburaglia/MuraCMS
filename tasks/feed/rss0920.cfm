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
<cfset tz=GetTimeZoneInfo()>
<cfif not find("-", tz.utcHourOffset)>
	<cfset utc = " -" & numberFormat(tz.utcHourOffset,"00") & "00">
<cfelse>
	<cfset tz.utcHourOffset = right(tz.utcHourOffset, len(tz.utcHourOffset) -1 )>
	<cfset utc = " +" & numberFormat(tz.utcHourOffset,"00") & "00">
</cfif>
<cfheader name="content-type" value="text/xml"><cfcontent reset="yes"><cfoutput><?xml version="1.0" ?>
<rss version="0.92"
	xmlns:dc="http://purl.org/dc/elements/1.1/">
	<channel>
		<title>#XMLFormat(feedBean.renderName())#</title> 
		<link>http://#listFirst(cgi.http_host,":")#</link> 
		<description>#XMLFormat(feedBean.getDescription())#</description> 
		<webMaster>#application.settingsManager.getSite(feedBean.getSiteID()).getContact()#</webMaster> 
		<language>#feedBean.getLang()#</language>
<cfloop condition="feedIt.hasNext()"><cfsilent>
<cfset item=feedIt.next()>
<cfset itemdescription=item.getValue('summary')>
<cfif feedBean.getallowhtml() eq 0>
	<cfif not len(itemdescription)>
		<cfset itemdescription=item.getValue('body')>
	</cfif>	
	<cfset itemdescription = renderer.stripHTML(renderer.setDynamicContent(itemdescription))>
	<cfset itemdescription=left(itemdescription,200) & "...">
<cfelse>
	<cfset itemdescription = renderer.addCompletePath(renderer.setDynamicContent(itemdescription),feedBean.getSiteID())>
</cfif>
<cfif isDate(item.getValue('releaseDate'))>
	<cfset thePubDate=dateFormat(item.getValue('releaseDate'),"yyyy-mm-dd") & "T" & timeFormat(item.getValue('releaseDate'),"HH:mm:ss") & utc>
<cfelse>
	<cfset thePubDate=dateFormat(item.getValue('releaseDate'),"yyyy-mm-dd") & "T" & timeFormat(item.getValue('releaseDate'),"HH:mm:ss") & utc>
</cfif>

<cfset rsCats=application.contentManager.getCategoriesByHistID(item.getValue('contentHistID'))>

<cfset theLink=XMLFormat(renderer.createHREFforRss(item.getValue('type'),item.getValue('filename'),item.getValue('siteID'),item.getValue('contentID'),item.getValue('target'),item.getValue('targetParams'),application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile(),0,item.getValue('fileEXT'))) />
</cfsilent>
		<item>
			<title>#XMLFormat(item.getMenuTitle())#</title>
			<description><![CDATA[#itemdescription# ]]></description> 
			<link>#theLink#</link>
			<guid isPermaLink="true">#theLink#</guid>
			<dc:date>#thePubDate#</dc:date>
			<cfif item.getValue('type') eq "File"><cfset fileMeta=application.serviceFactory.getBean("fileManager").readMeta(item.getValue('fileID'))><enclosure url="#XMLFormat('http://#application.settingsManager.getSite(item.getValue('siteID')).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#item.getValue('fileID')#&fileEXT=.#item.getValue('fileExt')#')#" length="#fileMeta.filesize#" type="#fileMeta.ContentType#/#fileMeta.ContentSubType#" /></cfif>
		</item></cfloop>
	</channel>
</rss></cfoutput>
