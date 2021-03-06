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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"email.bouncedemailaddresses")#</h2>
<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"email.filterbynumberofbounces")#:</h3>
<div id="advancedSearch" class="clearfix bounces">
<form novalidate="novalidate" action="index.cfm?fuseaction=cEmail.showAllBounces" method="post" name="form1" id="filterBounces">
<dl>
<dt>
	  <select name="bounceFilter">
	  	<option value="">#application.rbFactory.getKeyValue(session.rb,"email.all")#</option>
			<cfloop from="1" to="5" index="i">
			  <option value="#i#"<cfif isDefined('attributes.bounceFilter') and attributes.bounceFilter eq i> selected</cfif>>#i#</option>
			</cfloop>
	  </select>
</dt>
<dd><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,"email.filter")#</span></a></dd>
</dl>

<cfoutput>			  
	<input type="hidden" name="siteID" value="#attributes.siteid#">
</cfoutput>

</form>
</div>

<h3>#application.rbFactory.getKeyValue(session.rb,"email.emailaddressbounces")#</h3></cfoutput>
<cfif request.rsBounces.recordcount>
	<cfset bouncedEmailList = "">

	<form novalidate="novalidate" action="index.cfm?fuseaction=cEmail.deleteBounces" method="post" name="form2" id="bounces">
	
		<ul class="metadata">
			<cfoutput query="request.rsBounces">
				<li>#email# - #bounceCount#</li>
				<cfset bouncedEmailList = listAppend(bouncedEmailList,email)>
			</cfoutput>
		</ul>
		<cfoutput>
		<input type="hidden" value="#bouncedEmailList#" name="bouncedEmail" />
		<input type="hidden" name="siteID" value="#attributes.siteid#">
		<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form2,'delete','Delete bounced emails from mailing lists?');"><span>#application.rbFactory.getKeyValue(session.rb,"email.delete")#</span></a>
		</cfoutput>
	</form>
</cfif>

	







