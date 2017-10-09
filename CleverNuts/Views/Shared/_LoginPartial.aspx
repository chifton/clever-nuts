<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<% if (Request.IsAuthenticated) { %>
            <a href="<%= Url.Action("Manage", "Account") %>"><img src="../../Images/buypurchase.gif" /></a><img id="imageconnected" class ="imageconnected" src="<%= Url.Content("../../Images/connected.png") %>" />   Hello, <span id="enfonce"><%: Html.ActionLink(User.Identity.Name, "Manage", "Account", routeValues: null, htmlAttributes: new { @class = "username", title = "Manage" }) %></span>
    <% using (Html.BeginForm("LogOff", "Account", FormMethod.Post, new { id = "logoutForm", title = "Logout" }))
       { %>
        <%: Html.AntiForgeryToken() %>
        <a href="javascript:document.getElementById('logoutForm').submit()"><img class ="imagedeconnexion" src="<%= Url.Content("../../Images/disconnect.png") %>" /></a>
    <% } %>
    <br />
    <span id="groupeClient">
    <img src="<%= Url.Content("../../Images/gold2.png") %>" />
    <%: ViewData["noix3"] %>
    <img src="<%= Url.Content("../../Images/bronze2.png") %>" />
    <%: ViewData["noix2"] %>
    <img src="<%= Url.Content("../../Images/simple2.png") %>" />
    <%: ViewData["noix1"] %>
    <br />
    <img id="imagefin" src="<%= Url.Content("../../Images/bonus2.png") %>" />
    <br />
        <span id="groupeClient2">
    <%: ViewData["noixb"] %>
        </span>
        </span>
<% } //else { %>
    <!--<ul>
        <li><%//: Html.ActionLink("S'inscrire", "Register", "Account", routeValues: null, htmlAttributes: new { id = "registerLink" })%></li>
        <li><%//: Html.ActionLink("Se connecter", "Login", "Account", routeValues: null, htmlAttributes: new { id = "loginLink" })%></li>
    </ul>-->
<% //} %>