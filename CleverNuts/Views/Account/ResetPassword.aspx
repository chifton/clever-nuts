<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.ResetPasswordModel>" %>

<asp:Content ID="resetTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="resetContent" ContentPlaceHolderID="MainContent" runat="server">

        <section id="resetForm">
            <h2>Reset your password.</h2>
    <% using (Html.BeginForm()) { %>
        <%: Html.AntiForgeryToken() %>
        <%: Html.ValidationSummary() %>

        <fieldset>
            <legend>Reset password form</legend>
            <ol>
                <%: Html.HiddenFor(m => m.Token) %>
                <%: Html.HiddenFor(m => m.UserName) %> 
                <li>
                    <%: Html.LabelFor(m => m.NewPassword) %>
                    <%: Html.PasswordFor(m => m.NewPassword) %>
                    <%: Html.ValidationMessageFor(m => m.NewPassword) %>
                </li>
                <li>
                    <%: Html.LabelFor(m => m.ConfirmNewPassword) %>
                    <%: Html.PasswordFor(m => m.ConfirmNewPassword) %>
                    <%: Html.ValidationMessageFor(m => m.ConfirmNewPassword) %>
                </li>
            </ol>
            <input type="submit" value="Change password" />
        </fieldset>
    <% } %>
            </section>
</asp:Content>

<asp:Content ID="scriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/jqueryval") %>
</asp:Content>
