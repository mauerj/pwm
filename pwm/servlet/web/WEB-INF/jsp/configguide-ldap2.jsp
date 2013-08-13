<%@ page import="password.pwm.bean.servlet.ConfigGuideBean" %>
<%@ page import="password.pwm.servlet.ConfigGuideServlet" %>
<%@ page import="java.util.Map" %>
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

<!DOCTYPE html>

<%@ page language="java" session="true" isThreadSafe="true"
         contentType="text/html; charset=UTF-8" %>
<% ConfigGuideBean configGuideBean = (ConfigGuideBean)PwmSession.getPwmSession(session).getSessionBean(ConfigGuideBean.class);%>
<% Map<String,String> DEFAULT_FORM = ConfigGuideServlet.defaultForm(configGuideBean.getStoredConfiguration().getTemplate()); %>
<%@ taglib uri="pwm" prefix="pwm" %>
<html dir="<pwm:LocaleOrientation/>">
<%@ include file="fragment/header.jsp" %>
<body class="nihilo" onload="pwmPageLoadHandler()">
<link href="<%=request.getContextPath()%><pwm:url url='/public/resources/configStyle.css'/>" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="<%=request.getContextPath()%><pwm:url url="/public/resources/js/configguide.js"/>"></script>
<script type="text/javascript" src="<%=request.getContextPath()%><pwm:url url="/public/resources/js/configeditor.js"/>"></script>
<div id="wrapper">
    <div id="header">
        <div id="header-company-logo"></div>
        <div id="header-page">
            <pwm:Display key="Title_ConfigGuide" bundle="Config"/>
        </div>
        <div id="header-title">
            <pwm:Display key="Title_ConfigGuide_ldap" bundle="Config"/>
        </div>
    </div>
    <div id="centerbody">
        <form id="configForm" data-dojo-type="dijit/form/Form">
            <%@ include file="/WEB-INF/jsp/fragment/message.jsp" %>
            <br/>
            <div class="setting_outline">
                <div class="setting_title">LDAP Contextless Login Root</div>
                <div class="setting_body">
                    Enter the top level LDAP context of your LDAP directory. This sets the top level LDAP container where an LDAP sub-tree search is performed to find your user entries. If you need to enter multiple containers, you can use the configuration editor to add them after this guide completes.
                    <div class="setting_item">
                        <b>LDAP Contextless Login Root</b>
                        <br/><span>&nbsp;<%="\u00bb"%>&nbsp;&nbsp;</span>
                        <input id="value_<%=ConfigGuideServlet.PARAM_LDAP2_CONTEXT%>" name="setting_<%=ConfigGuideServlet.PARAM_LDAP2_CONTEXT%>"/>
                        <script type="text/javascript">
                            PWM_GLOBAL['startupFunctions'].push(function(){
                                require(["dijit/form/ValidationTextBox"],function(ValidationTextBox){
                                    new ValidationTextBox({
                                        id: '<%=ConfigGuideServlet.PARAM_LDAP2_CONTEXT%>',
                                        name: '<%=ConfigGuideServlet.PARAM_LDAP2_CONTEXT%>',
                                        required: true,
                                        style: "width: 550px",
                                        placeholder: '<%=DEFAULT_FORM.get(ConfigGuideServlet.PARAM_LDAP2_CONTEXT)%>',
                                        onKeyUp: function() {
                                            handleFormActivity();
                                        },
                                        value: '<%=configGuideBean.getFormData().get(ConfigGuideServlet.PARAM_LDAP2_CONTEXT)%>'
                                    }, "value_<%=ConfigGuideServlet.PARAM_LDAP2_CONTEXT%>");
                                });
                            });
                        </script>
                    </div>
                </div>
            </div>
            <br/>
            <div class="setting_outline">
                <div class="setting_title">
                    Administrator Search Filter
                </div>
                <div class="setting_body">
                    Enter the LDAP search filter to use for determining if a user should be given administrator access to this system.  Any user
                    that authenticates and matches this filter will be allowed administrative access.
                    <div class="setting_item">
                        <b>Administrator Search Filter</b>
                        <br/><span>&nbsp;<%="\u00bb"%>&nbsp;&nbsp;</span>
                        <input id="value_<%=ConfigGuideServlet.PARAM_LDAP2_ADMINS%>" name="setting_<%=ConfigGuideServlet.PARAM_LDAP2_ADMINS%>"/>
                        <script type="text/javascript">
                            PWM_GLOBAL['startupFunctions'].push(function(){
                                require(["dijit/form/ValidationTextBox"],function(ValidationTextBox){
                                    new ValidationTextBox({
                                        id: '<%=ConfigGuideServlet.PARAM_LDAP2_ADMINS%>',
                                        name: '<%=ConfigGuideServlet.PARAM_LDAP2_ADMINS%>',
                                        required: true,
                                        style: "width: 550px",
                                        placeholder: '<%=DEFAULT_FORM.get(ConfigGuideServlet.PARAM_LDAP2_ADMINS)%>',
                                        onKeyUp: function() {
                                            handleFormActivity();
                                        },
                                        value: '<%=configGuideBean.getFormData().get(ConfigGuideServlet.PARAM_LDAP2_ADMINS)%>'
                                    }, "value_<%=ConfigGuideServlet.PARAM_LDAP2_ADMINS%>");
                                });
                            });
                        </script>
                    </div>
                </div>
            </div>
        </form>
        <br/>
        <div id="healthBody" style="border:0; margin:0; padding:0" onclick="loadHealth()">
            <div style="text-align: center">
                <a class="menubutton" style="max-width: 100px; margin-left: auto; margin-right: auto">Check Settings</a>
            </div>
        </div>
        <div id="buttonbar">
            <button class="btn" id="button_previous" onclick="gotoStep('LDAPCERT')"><pwm:Display key="Button_Previous" bundle="Config"/></button>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <button class="btn" id="button_next" onclick="gotoStep('LDAP3')"><pwm:Display key="Button_Next"  bundle="Config"/></button>
        </div>
    </div>
    <div class="push"></div>
</div>
<script type="text/javascript">
    function handleFormActivity() {
        updateForm();
        clearHealthDiv();
    }

    function clearHealthDiv() {
        var healthBodyObj = getObject('healthBody');
        var newHtml = '<div style="text-align: center">';
        newHtml += '<a class="menubutton" style="max-width: 100px; margin-left: auto; margin-right: auto">Check Settings</a>';
        newHtml += '</div>'
        healthBodyObj.innerHTML = newHtml;
    }

    PWM_GLOBAL['startupFunctions'].push(function(){
        getObject('localeSelectionMenu').style.display = 'none';
        require(["dojo/parser","dijit/TitlePane","dijit/form/Form","dijit/form/ValidationTextBox","dijit/form/NumberSpinner","dijit/form/CheckBox"],function(dojoParser){
            dojoParser.parse();
        });
        checkIfNextEnabled();
    });

    function checkIfNextEnabled() {
        if (PWM_GLOBAL['pwm-health'] == 'GOOD' || PWM_GLOBAL['pwm-health'] == 'CONFIG') {
            getObject('button_next').disabled = false;
        } else {
            getObject('button_next').disabled = true;
        }
    }

    function loadHealth() {
        var options = {};
        options['sourceUrl'] = 'ConfigGuide?processAction=ldapHealth';
        options['showRefresh'] = false;
        options['refreshTime'] = -1;
        options['finishFunction'] = function(){
            closeWaitDialog();
            checkIfNextEnabled();
        };
        showWaitDialog();
        showPwmHealth('healthBody', options);
    }
</script>
<%@ include file="fragment/footer.jsp" %>
</body>
</html>
