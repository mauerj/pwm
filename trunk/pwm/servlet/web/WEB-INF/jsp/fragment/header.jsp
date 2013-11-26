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

<%@ page import="password.pwm.ContextManager" %>
<%@ page import="password.pwm.PwmApplication" %>
<%@ page import="password.pwm.PwmConstants" %>
<%@ page import="password.pwm.PwmSession" %>
<%@ page import="password.pwm.AppProperty" %>
<%@ page import="password.pwm.error.PwmUnrecoverableException" %>
<%@ page import="password.pwm.util.PwmServletURLHelper" %>
<%@ page import="password.pwm.util.Helper" %>
<%@ page import="password.pwm.util.PwmRandom" %>
<%@ page import="password.pwm.ws.server.rest.RestAppDataServer" %>
<%@ taglib uri="pwm" prefix="pwm" %>
<%
    PwmSession pwmSessionHeader = null;
    PwmApplication pwmApplicationHeader = null;
    try {
        pwmApplicationHeader = ContextManager.getPwmApplication(session);
        pwmSessionHeader = PwmSession.getPwmSession(session);
    } catch (PwmUnrecoverableException e) {
        /* application must be unavailable */
    }

    // read parameters from calling jsp;
    final boolean showTheme = !"true".equalsIgnoreCase((String)request.getAttribute(PwmConstants.REQUEST_ATTR_HIDE_THEME));
    final boolean includeXVersion = Boolean.parseBoolean(pwmApplicationHeader.getConfig().readAppProperty(AppProperty.HTTP_HEADER_SEND_XVERSION));

%>
<head>
    <title><pwm:Display key="Title_TitleBar"/></title>
    <meta http-equiv="content-type" content="text/html;charset=utf-8"/>
    <meta name="application-name" content="<%=PwmConstants.PWM_APP_NAME%> Password Self Service" <%if (includeXVersion){%>data-<%=PwmConstants.PWM_APP_NAME.toLowerCase()%>-version="<%=PwmConstants.PWM_VERSION%> (<%=PwmConstants.BUILD_TYPE%>)" data-<%=PwmConstants.PWM_APP_NAME.toLowerCase()%>-build="<%=PwmConstants.BUILD_NUMBER%>" <%}%>data-<%=PwmConstants.PWM_APP_NAME.toLowerCase()%>-instance="<%=pwmApplicationHeader != null ? pwmApplicationHeader.getInstanceID() : ""%>"/>
    <meta name="viewport" content="width=device-width, initial-scale = 1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=10; IE=9; IE=8; IE=7" />
    <link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%><pwm:url url='/public/resources/favicon.ico'/>"/>
    <link href="<%=request.getContextPath()%><pwm:url url='/public/resources/style.css'/>" rel="stylesheet" type="text/css" media="screen"/>
    <link media="only screen and (max-device-width: 480px)" href="<%=request.getContextPath()%><pwm:url url='/public/resources/mobileStyle.css'/>" type="text/css" rel="stylesheet"/><%-- iphone css --%>
    <% if (showTheme) { %>
    <link href="<pwm:url url="%THEME_URL%"/>" rel="stylesheet" type="text/css" media="screen"/>
    <link media="only screen and (max-device-width: 620px)" href="<pwm:url url="%MOBILE_THEME_URL%"/>" type="text/css" rel="stylesheet"/><%-- iphone css --%>
    <% } %>
    <link href="<%=request.getContextPath()%><pwm:url url='/public/resources/dojo/dijit/themes/nihilo/nihilo.css'/>" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var PWM_GLOBAL = PWM_GLOBAL || {}, PWM_STRINGS = PWM_STRINGS || {}; PWM_GLOBAL['startupFunctions'] = new Array();
        PWM_GLOBAL["url-context"]='<%=request.getContextPath()%>';
        PWM_GLOBAL['pwmFormID']='<pwm:FormID/>';
        PWM_GLOBAL['clientEtag']='<%=RestAppDataServer.makeClientEtag(request,pwmApplicationHeader,pwmSessionHeader)%>';
        PWM_GLOBAL['restClientKey']='<%=pwmSessionHeader.getRestClientKey()%>';
    </script>
    <script defer data-dojo-config="async: true" type="text/javascript" src="<%=request.getContextPath()%><pwm:url url='/public/resources/dojo/dojo/dojo.js'/>"></script>
    <script defer type="text/javascript" src="<%=request.getContextPath()%><pwm:url url='/public/resources/js/main.js'/>"></script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%><pwm:url url='/public/resources/font/font-awesome.css'/>"/>
</head>
