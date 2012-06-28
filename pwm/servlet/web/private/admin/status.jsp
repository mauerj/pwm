<%--
  ~ Password Management Servlets (PWM)
  ~ http://code.google.com/p/pwm/
  ~
  ~ Copyright (c) 2006-2009 Novell, Inc.
  ~ Copyright (c) 2009-2012 The PWM Project
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or
  ~ (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  --%>

<%@ page import="password.pwm.servlet.ResourceFileServlet" %>
<%@ page import="password.pwm.util.TimeDuration" %>
<%@ page import="password.pwm.util.pwmdb.PwmDB" %>
<%@ page import="password.pwm.util.stats.StatisticsManager" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<%@ page language="java" session="true" isThreadSafe="true"
         contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="pwm" prefix="pwm" %>
<% final PwmApplication pwmApplication = ContextManager.getPwmApplication(session); %>
<% final NumberFormat numberFormat = NumberFormat.getInstance(PwmSession.getPwmSession(session).getSessionStateBean().getLocale()); %>
<% final DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.FULL, DateFormat.FULL, PwmSession.getPwmSession(session).getSessionStateBean().getLocale()); %>
<html dir="<pwm:LocaleOrientation/>">
<%@ include file="/WEB-INF/jsp/fragment/header.jsp" %>
<body class="nihilo" onload="pwmPageLoadHandler();">
<div id="wrapper">
<jsp:include page="/WEB-INF/jsp/fragment/header-body.jsp">
    <jsp:param name="pwm.PageName" value="PWM Status"/>
</jsp:include>
<div id="centerbody">
<%@ include file="admin-nav.jsp" %>
<div id="content" style="display:none">
<div data-dojo-type="dijit.layout.TabContainer" style="width: 100%; height: 100%;" data-dojo-props="doLayout: false">
<div data-dojo-type="dijit.layout.ContentPane" title="Status">
    <table>
        <tr>
            <td class="key">
                PWM Version
            </td>
            <td>
                <%= PwmConstants.SERVLET_VERSION %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Current Time
            </td>
            <td>
                <%= dateFormat.format(new java.util.Date()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Start Time
            </td>
            <td>
                <%= dateFormat.format(pwmApplication.getStartupTime()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Install Time
            </td>
            <td>
                <%= dateFormat.format(pwmApplication.getInstallTime()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Server Timezone
            </td>
            <td>
                <%= dateFormat.getTimeZone().getDisplayName() %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Instance ID
            </td>
            <td>
                <%= pwmApplication.getInstanceID() %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Last LDAP Unavailable Time
            </td>
            <td>
                <%= pwmApplication.getLastLdapFailure() != null ? dateFormat.format(pwmApplication.getLastLdapFailure().getDate()) : "n/a" %>
            </td>
        </tr>
        <tr>
            <td class="key">
                LDAP Vendor
            </td>
            <td>
                <%
                    String vendor = "[detection error]";
                    try {
                        vendor = pwmApplication.getProxyChaiProvider().getDirectoryVendor().toString();
                    } catch (Exception e) { /* nothing */ }
                %>
                <%= vendor %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Chai API Version
            </td>
            <td>
                <%= com.novell.ldapchai.ChaiConstant.CHAI_API_VERSION %> (<%= com.novell.ldapchai.ChaiConstant.CHAI_API_BUILD_INFO %>)
            </td>
        </tr>
        <tr>
            <td class="key">
                Dojo API Version
            </td>
            <td>
                <span id="dojoVersionSpan"></span>
                <script type="text/javascript">
                    require(["dojo"],function(dojo){
                        dojo.byId('dojoVersionSpan').innerHTML = dojo.version;
                    });
                </script>
            </td>
        </tr>
    </table>
</div>
<div data-dojo-type="dijit.layout.ContentPane" title="Activity">
    <table class="tablemain">
        <tr>
            <td class="key">
                <a href="<pwm:url url='activesessions.jsp'/>">
                    Active HTTP Sessions
                </a>
            </td>
            <td>
                <a href="<pwm:url url='activesessions.jsp'/>">
                    <%= ContextManager.getContextManager(session).getPwmSessions().size() %>
                </a>
            </td>
            <td class="key">
                Stored Tokens
            </td>
            <td>
                <%= pwmApplication.getTokenManager().size() < 0 ? "n/a" : pwmApplication.getTokenManager().size() %>
            </td>
        </tr>
        <tr>
            <td class="key">
                <a href="<pwm:url url='intruderstatus.jsp'/>">
                    Locked Users
                </a>
            </td>
            <td>
                <a href="<pwm:url url='intruderstatus.jsp'/>">
                    <%= numberFormat.format(pwmApplication.getIntruderManager().currentLockedUsers()) %>
                </a>
            </td>
            <td class="key">
                <a href="<pwm:url url='intruderstatus.jsp'/>">
                    Locked Addresses
                </a>
            </td>
            <td>
                <a href="<pwm:url url='intruderstatus.jsp'/>">
                    <%= numberFormat.format(pwmApplication.getIntruderManager().currentLockedAddresses()) %>
                </a>
            </td>
        </tr>
    </table>
    <table class="tablemain">
        <tr>
            <td style="text-align: center">
            </td>
            <td style="text-align: center">
                5 Minutes
            </td>
            <td style="text-align: center">
                15 Minutes
            </td>
            <td style="text-align: center">
                1 Hour
            </td>
        </tr>
        <tr>
            <td class="key">
                Authentications / Minute
            </td>
            <td style="text-align: center">
                <%= ContextManager.getContextManager(session).getPwmApplication().getStatisticsManager().readEps(StatisticsManager.EpsType.AUTHENTICATION, new TimeDuration(5 * 60 * 1000)) %>
            </td>
            <td style="text-align: center">
                <%= ContextManager.getContextManager(session).getPwmApplication().getStatisticsManager().readEps(StatisticsManager.EpsType.AUTHENTICATION, new TimeDuration(15 * 60 * 1000)) %>
            </td>
            <td style="text-align: center">
                <%= ContextManager.getContextManager(session).getPwmApplication().getStatisticsManager().readEps(StatisticsManager.EpsType.AUTHENTICATION, TimeDuration.HOUR) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Password Changes / Minute
            </td>
            <td style="text-align: center">
                <%= ContextManager.getContextManager(session).getPwmApplication().getStatisticsManager().readEps(StatisticsManager.EpsType.PASSWORD_CHANGES, new TimeDuration(5 * 60 * 1000)) %>
            </td>
            <td style="text-align: center">
                <%= ContextManager.getContextManager(session).getPwmApplication().getStatisticsManager().readEps(StatisticsManager.EpsType.PASSWORD_CHANGES,new TimeDuration(15 * 60 * 1000)) %>
            </td>
            <td style="text-align: center">
                <%= ContextManager.getContextManager(session).getPwmApplication().getStatisticsManager().readEps(StatisticsManager.EpsType.PASSWORD_CHANGES, TimeDuration.HOUR) %>
            </td>
        </tr>
    </table>
</div>
<div data-dojo-type="dijit.layout.ContentPane" title="Health">
    <div id="healthBody">&nbsp;</div>
    <script type="text/javascript">
        dojo.addOnLoad(function() {
            showPwmHealth('healthBody', false);
        });
    </script>
    <div style="text-align:center; width:100%; border: 0">Public PWM Health Page is at <a
            href="<%=request.getContextPath()%>/public/health.jsp"><%=request.getContextPath()%>/public/health.jsp</a></div>
</div>
<div data-dojo-type="dijit.layout.ContentPane" title="Local PwmDB">
    <table class="tablemain">
        <tr>
            <td class="key">
                Wordlist Dictionary Status
            </td>
            <td style="white-space:nowrap;">
                <%= pwmApplication.getWordlistManager().getDebugStatus() %>
            </td>
            <td class="key">
                Wordlist Dictionary Size
            </td>
            <td>
                <%= numberFormat.format(pwmApplication.getWordlistManager().size()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Seedlist Status
            </td>
            <td style="white-space:nowrap;">
                <%= pwmApplication.getSeedlistManager().getDebugStatus() %>
            </td>
            <td class="key">
                Seedlist Size
            </td>
            <td>
                <%= numberFormat.format(pwmApplication.getSeedlistManager().size()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Shared Password History Status
            </td>
            <td>
                <%= pwmApplication.getSharedHistoryManager().status() %>
            </td>
            <td class="key">
                Shared Password History Size
            </td>
            <td>
                <%= numberFormat.format(pwmApplication.getSharedHistoryManager().size()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Email Queue Status
            </td>
            <td>
                <%= pwmApplication.getEmailQueue().status() %>
            </td>
            <td class="key">
                Email Queue Size
            </td>
            <td>
                <%= pwmApplication.getEmailQueue().queueSize() %>
            </td>
        </tr>
        <tr>
            <td class="key">
                SMS Queue Status
            </td>
            <td>
                <%= pwmApplication.getSmsQueue().status() %>
            </td>
            <td class="key">
                SMS Queue Size
            </td>
            <td>
                <%= pwmApplication.getSmsQueue().queueSize() %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Log Events in Write Queue
            </td>
            <td>
                <%= pwmApplication.getPwmDBLogger() != null ? numberFormat.format(pwmApplication.getPwmDBLogger().getPendingEventCount()) : "n/a" %>
            </td>
            <td class="key">
                <a href="<pwm:url url='eventlog.jsp'/>">
                    Log Events
                </a>
            </td>
            <td>
                <a href="<pwm:url url='eventlog.jsp'/>">
                    <%= pwmApplication.getPwmDBLogger() != null ? numberFormat.format(pwmApplication.getPwmDBLogger().getStoredEventCount()) : "n/a" %>
                </a>
            </td>
        </tr>
        <tr>
            <td class="key">
                Oldest Log Event in Write Queue
            </td>
            <td>
                <%= pwmApplication.getPwmDBLogger() != null ? pwmApplication.getPwmDBLogger().getDirtyQueueTime().asCompactString() : "n/a"%>
            </td>
            <td class="key">
                Oldest Log Event
            </td>
            <td>
                <%= pwmApplication.getPwmDBLogger() != null ? TimeDuration.fromCurrent(pwmApplication.getPwmDBLogger().getTailDate()).asCompactString() : "n/a" %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Oldest Shared Password Entry
            </td>
            <td>
                <% final long oldestEntryAge = pwmApplication.getSharedHistoryManager().getOldestEntryAge(); %>
                <%= oldestEntryAge == 0 ? "n/a" : TimeDuration.asCompactString(oldestEntryAge) %>
            </td>
            <td class="key">
                PwmDB Size On Disk
            </td>
            <td>
                <%= pwmApplication.getPwmDB() == null ? "n/a" : pwmApplication.getPwmDB().getFileLocation() == null ? "n/a" : Helper.formatDiskSize(Helper.getFileDirectorySize(pwmApplication.getPwmDB().getFileLocation())) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                User Responses in PwmDB
            </td>
            <td>
                <%
                    String responseCount = "n/a";
                    try {
                        responseCount = String.valueOf(pwmApplication.getPwmDB().size(PwmDB.DB.RESPONSE_STORAGE));
                    } catch (Exception e) { /* na */ }
                %>
                <%= responseCount %>
            </td>
            <td class="key">
                PwmDB Free Space
            </td>
            <td>
                <%= pwmApplication.getPwmDB() == null ? "n/a" : pwmApplication.getPwmDB().getFileLocation() == null ? "n/a" : Helper.formatDiskSize(Helper.diskSpaceRemaining(pwmApplication.getPwmDB().getFileLocation())) %>
            </td>
        </tr>
    </table>
    <% if (pwmApplication.getPwmDB() != null && "true".equalsIgnoreCase(request.getParameter("showPwmDBCounts"))) { %>
    <table class="tablemain">
        <tr>
            <td class="key">
                Name
            </td>
            <td style="white-space:nowrap;">
                Record Count
            </td>
        </tr>
        <% for (final PwmDB.DB loopDB : PwmDB.DB.values()) { %>
        <tr>
            <td class="key">
                <%= loopDB %>
            </td>
            <td style="white-space:nowrap;">
                <%= pwmApplication.getPwmDB().size(loopDB) %>
            </td>
        </tr>
        <% } %>
    </table>
    <% } else { %>
    <div style="text-align:center; width:100%; border: 0">
        <a href="status.jsp?showPwmDBCounts=true">Show PwmDB record counts</a> (may be slow to load)
    </div>
    <% } %>
</div>
<div data-dojo-type="dijit.layout.ContentPane" title="Java">
    <table>
        <tr>
            <td class="key">
                Java Vendor
            </td>
            <td>
                <%= System.getProperty("java.vm.vendor") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Java Runtime Version
            </td>
            <td>
                <%= System.getProperty("java.runtime.version") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Java VM Version
            </td>
            <td>
                <%= System.getProperty("java.vm.version") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Java Name
            </td>
            <td>
                <%= System.getProperty("java.vm.name") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Java Home
            </td>
            <td>
                <%= System.getProperty("java.home") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                OS Name
            </td>
            <td>
                <%= System.getProperty("os.name") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                OS Version
            </td>
            <td>
                <%= System.getProperty("os.version") %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Free Memory
            </td>
            <td>
                <%= numberFormat.format(Runtime.getRuntime().freeMemory()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Memory Allocated
            </td>
            <td>
                <%= numberFormat.format(Runtime.getRuntime().totalMemory()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                ResourceFileServlet Cache
            </td>
            <td>
                <%= numberFormat.format(ResourceFileServlet.itemsInCache(session.getServletContext())) %>
                (<%= numberFormat.format(ResourceFileServlet.bytesInCache(session.getServletContext())) %>)
            </td>
        </tr>
        <tr>
            <td class="key">
                Memory Limit
            </td>
            <td>
                <%= numberFormat.format(Runtime.getRuntime().maxMemory()) %>
            </td>
        </tr>
        <tr>
            <td class="key">
                Threads
            </td>
            <td>
                <%= Thread.activeCount() %>
            </td>
        </tr>
    </table>
</div>
<div data-dojo-type="dijit.layout.ContentPane" title="Java Threads">
    <div style="height: 480px; overflow: auto;">
        <table class="tablemain">
            <tr>
                <td style="font-weight:bold;">
                    Id
                </td>
                <td style="font-weight:bold;">
                    Name
                </td>
                <td style="font-weight:bold;">
                    Priority
                </td>
                <td style="font-weight:bold;">
                    State
                </td>
                <td style="font-weight:bold;">
                    Daemon
                </td>
            </tr>
            <%
                final Thread[] tArray = new Thread[Thread.activeCount()];
                Thread.enumerate(tArray);
                try {
                    for (final Thread t : tArray) {
            %>
            <tr>
                <td>
                    <%= t.getId() %>
                </td>
                <td>
                    <%= t.getName() != null ? t.getName() : "n/a" %>
                </td>
                <td>
                    <%= t.getPriority() %>
                </td>
                <td>
                    <%= t.getState().toString().toLowerCase() %>
                </td>
                <td>
                    <%= String.valueOf(t.isDaemon()) %>
                </td>
            </tr>
            <% } %>
            <% } catch (Exception e) { /* */ } %>
        </table>
    </div>

</div>
</div>
</div>
</div>
</div>
<script type="text/javascript">
    require(["dojo/parser","dijit/layout/TabContainer","dijit/layout/ContentPane"],function(dojoParser){
        getObject('content').style.display = 'inline';
        dojoParser.parse();
    });
</script>
<%@ include file="/WEB-INF/jsp/fragment/footer.jsp" %>
</body>
</html>


