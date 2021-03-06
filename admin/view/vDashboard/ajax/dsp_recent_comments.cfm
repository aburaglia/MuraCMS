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

<cfinclude template="../act_defaults.cfm">
<cfset comments=application.contentManager.getRecentCommentsIterator(attributes.siteID,5,false) />
<cfoutput><table>
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"dashboard.comments")#</th>
	<th class="dateTime">#application.rbFactory.getKeyValue(session.rb,"dashboard.comments.posted")#</th>
	<th class="administration">&nbsp;</th>
</tr>
<cfloop condition="comments.hasNext()">
	<cfset comment=comments.next()>
	<!---
	<cfset crumbdata=application.contentManager.getCrumbList(comment.getCommentID(),comment.getSiteID())/>
	<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
	--->
	<cfset content=application.serviceFactory.getBean("content").loadBy(contentID=comment.getContentID(),siteID=session.siteID)>
	<tr<cfif comments.currentIndex() mod 2> class="alt"</cfif>>
		<cfset args=arrayNew(1)>
		<cfset args[1]="<strong>#HTMLEditFormat(comment.getName())#</strong>">
		<cfset args[2]="<strong>#HTMLEditFormat(content.getMenuTitle())#</strong>">
		<td class="varWidth">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.comments.description"),args)#</td>
		<td class="dateTime">#LSDateFormat(comment.getEntered(),session.dateKeyFormat)# #LSTimeFormat(comment.getEntered(),"short")#</td>
		<td class="administration">
		<ul class="one">
			<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('#content.getURL(complete=1,queryString='##comment-#comment.getCommentID()#')#','#content.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#</a></li>
		</ul>
		</td>
	</tr>
	</cfloop>
	</table>
</cfoutput>