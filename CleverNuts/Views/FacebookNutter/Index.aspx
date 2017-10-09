<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
    <img id="imageconnected" class ="imageconnected" src="<%= Url.Content("../../Images/connected.png") %>" />   Hello, <span id="enfonce"><%: Html.ActionLink("hbhuj", "Manage", "Account", routeValues: null, htmlAttributes: new { @class = "username", title = "Manage" }) %></span>
    <br />

    <!--<ul>
        <li><%//: Html.ActionLink("S'inscrire", "Register", "Account", routeValues: null, htmlAttributes: new { id = "registerLink" })%></li>
        <li><%//: Html.ActionLink("Se connecter", "Login", "Account", routeValues: null, htmlAttributes: new { id = "loginLink" })%></li>
    </ul>-->
<% //} %>