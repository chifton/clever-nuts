<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
    <span id="enfonce2"><img id="inviteramis" src="../../Images/inviter.png" /></span><a href="<%= Url.Action("Manage", "FacebookNutter", new { identifiant = ViewBag.idfbk })%>"><img src="../../Images/buypurchase.gif" /></a><img id="photo"/><img id="imageconnected" class ="imageconnected" src="<%= Url.Content("../../Images/connected.png") %>" />   Hello, <span id="enfonce"><%: Html.ActionLink(Convert.ToString(ViewData["fbk"]), "Manage", "FacebookNutter", routeValues: new { identifiant = Convert.ToString(ViewData["idfbk"]) }, htmlAttributes: new { @class = "username", title = "Manage" })%></span>
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

<script type="text/javascript">
    // Pour ajouter des amis facebook
    var boutonamis = document.querySelector("#enfonce2");
    boutonamis.addEventListener("click", function () {
        FB.ui({
            method: 'apprequests',
            filters: ['all'],
            message: 'Select friends you want to be nutters !'
        }, function (response) {
            console.log(response);
        });
    });
</script>

    <!--<ul>
        <li><%//: Html.ActionLink("S'inscrire", "Register", "Account", routeValues: null, htmlAttributes: new { id = "registerLink" })%></li>
        <li><%//: Html.ActionLink("Se connecter", "Login", "Account", routeValues: null, htmlAttributes: new { id = "loginLink" })%></li>
    </ul>-->
<% //} %>