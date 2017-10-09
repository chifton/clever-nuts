<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.EmailModel>" %>
<%@ Import Namespace="Recaptcha" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Contact Us
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="form_Contact" style="border:2px double white;border-radius:5px;">
            
                    <%= Html.ValidationSummary("Please correct the following errors and try again.") %>
                    <% using (Html.BeginForm(new { ReturnUrl = ViewBag.ReturnUrl })) { %>
                    <%: Html.AntiForgeryToken() %>
                    <%: Html.ValidationSummary(true) %>
                        <div class="contact_form">
                        <span id="titreContact" style="font-size:18px;font-weight:bold;">Contact us for your questions !</span>
            <br />
                            <table style="text-align:center;margin:auto;display:inline-block;float:left;position:relative;left:0px;margin-left:0px;">
                <tr>
                    <label style="display:inline;" for="Name">Pseudo</label>
                    <%= Html.TextBox("Name", "", new { @class = "inputcool" })%>
                    <%= Html.ValidationMessage("Name", "*")%>
                </tr>
                <tr>
                    <label style="display:inline;" for="EmailAddress">Email</label>
                    <%= Html.TextBox("EmailAddress", "", new { @class = "inputcool" })%>
                    <%= Html.ValidationMessage("EmailAddress", "*")%>
                </tr>
                <tr>
                    <label style="display:inline;" for="Subject">Subject</label>
                    <%= Html.TextBox("Subject", "", new { @class = "inputcool" })%>
                    <%= Html.ValidationMessage("Subject", "*")%>
                </tr>
                <tr>
                    <label style="display:inline;" for="Message">Message</label>
                    <%= Html.TextArea("Message", new { @rows = "5", @cols = "25", @class = "inputcool3" })%>
                    <%= Html.ValidationMessage("Message", "*")%>
                </tr>
                <tr style="width : 200px;height: 200px;">
                    <%= Html.Raw(Html.GenerateCaptcha("Captcha","white")) %>
                    <%= Html.ValidationMessage("Captcha", "*")%>
                </tr>
                <tr>
                    <%= Html.ValidationMessage("Message", "*")%>
                    <input style="margin:auto;text-align:center;width:100px;display:inline-block;" type="submit" value="Send" />
                </tr>
            </table>
        </div>
    <% } %>
                </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>