<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<div>
       
    <!-- Factures du nutter -->
    <table id="tableauAchats">
        <thead>
        <tr>
            <td style="color : white;">Transaction N°</td>
            <td style="color : white;>Kind of nuts</td>
            <td style="color : white;>Amount</td>
            <td style="color : white;>Transaction date</td>
            <td style="color : white;>Platform</td>  
        </tr>
        </thead>
            <tbody>
        <%  
           foreach (var item in ViewBag.resultat)
        {
            string cool = item.Plateforme;
            string i1 = cool.Substring(0, cool.Length - 13);
            string i2 = cool.Substring(cool.Length - 6, 6);
            string article2 = item.Article;
            string article3 = article2.Replace('+',' ');
        %>
        <tr>
            <td><%= item.IdPaiement %></td>
            <td><%= article3 %></td>
            <td><%= item.Montant %> €</td>
            <td><%= i1 %></td>
            <td><%= i2 %></td>
        </tr>
        <%} %>
            </tbody>
 </table>
    </div>