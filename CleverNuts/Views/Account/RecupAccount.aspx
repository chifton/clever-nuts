<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.RecupAccountModel>" %>

<asp:Content ID="recupTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="recupContent" ContentPlaceHolderID="MainContent" runat="server">

        <section id="recupForm">
            <h2>Recover your account.</h2>
    <% using (Html.BeginForm()) { %>
        <%: Html.AntiForgeryToken() %>
        <%: Html.ValidationSummary() %>

        <fieldset>
            <legend>Recover form</legend>
            <ol>
                <li>
                    <%: Html.LabelFor(m => m.UserName) %>
                    <%: Html.EditorFor(m => m.UserName) %>
                    <%: Html.ValidationMessageFor(m => m.UserName) %>
                </li>
                <li>
                    <%: Html.LabelFor(m => m.Email) %>
                    <%: Html.EditorFor(m => m.Email) %>
                    <%: Html.ValidationMessageFor(m => m.Email) %>
                </li>
            </ol>
            <input type="submit" value="Recover" />
        </fieldset>
    <% } %>
            </section>
</asp:Content>

<asp:Content ID="scriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/jqueryval") %>
</asp:Content>
