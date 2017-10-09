<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.LocalPasswordModel>" %>

<p>
    Vous n’avez pas de mot de passe local pour ce site. Ajoutez un mot de passe
    local, pour pouvoir vous connecter sans connexion externe.
</p>

<% using (Html.BeginForm("Manage", "Account")) { %>
    <%: Html.AntiForgeryToken() %>
    <%: Html.ValidationSummary() %>

    <fieldset>
        <legend>Password definition word</legend>
        <ol>
            <li>
                <%: Html.LabelFor(m => m.NewPassword) %>
                <%: Html.PasswordFor(m => m.NewPassword) %>
            </li>
            <li>
                <%: Html.LabelFor(m => m.ConfirmPassword) %>
                <%: Html.PasswordFor(m => m.ConfirmPassword) %>
            </li>
        </ol>
        <input type="submit" value="Define a password" />
    </fieldset>
<% } %>
