<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <a href="<%= Url.Action("Index", "Rules") %>"><img id="langueimage" src="../../Images/drapanglais.jpg" style="margin : auto; text-align : center"/></a>
    <h2 style="text-align : center;">Règles pour gagner des noix en jouant à l'Awalé</h2>
    <p><ul style="color : white;font-family : Consolas, Courier, monospace;font-size : 12px; font-weight : bold; text-align : center; margin : auto;">
        <li>La partie se déroule entre deux nutters.</li>
        <img src="../../Images/corne.png" style="margin : auto; text-align : center"/>
        <li>Au départ, il y a quarante huit noix dans les douze trous de l'awalé, à raison de quatre noix par trou.</li>
        <img src="../../Images/ecureuil2.png" style="margin : auto; text-align : center"/>
        <li>Les joueurs sont opposés, chacun avec une partie horizontale de la tablette. Cette partie sera son camp.</li>
        <img src="../../Images/hiboucool.png" style="margin : auto; text-align : center"/>
        <li>Un tour de jeu se fait comme suit : le premier joueur prend toutes les noix d'un trou de son camp. Il les distribue ensuite dans tous les trous suivants, également dans le camp de son adversaire, dans le sens de rotation contraire aux aiguilles d'une montre (une noix par trou sauf le trou de départ).</li>
        <img src="../../Images/lance.png" style="margin : auto; text-align : center"/>
        <li>Si la dernière noix tombe dans un trou du camp adverse et qu'il y a deux ou trois noix dans ce trou (après depôt des noix), le nutter les gagne. Il regarde ensuite le trou précédent : s'il est dans le camp adverse et s'il contient deux ou trois noix, il les gagne aussi et ainsi de suite jusqu'à ce qu'il revienne dans son propre camp ou qu'il y ait un nombre de noix différent de deux ou de trois.</li>
        <img src="../../Images/awale_1.png" style="margin : auto; text-align : center"/>
        <li>Le but est de gagner le maximum de noix à la fin du jeu.</li>
        <img src="../../Images/lancebouleOr.png" style="margin : auto; text-align : center"/>
        <li>La partie se termine quand un nutter a capturé au moins 25 noix, ou plus de la moitié, ou quand il n'y a plus que 6 noix dans le jeu.</li>
       </ul>
    </p>
        <h2 style="text-align : center;">Règles pour sauver les écureuils</h2>
        <p><ul style="color : white;font-family : Consolas, Courier, monospace;font-size : 12px; font-weight : bold; text-align : center;">
        <li>Nutters, pas de règles ! Sauvez-les juste en dégommant les hiboux ! Mais ne le faites pas en vrai :)</li>
        </ul>
        </p>

        <h3><ul style="border : double 1px red; color : white;font-family : Consolas, Courier, monospace;font-size : 20px; font-weight : bold; text-align : center;">
        <li>NE PAS DESACTIVER JAVASCRIPT. CLEVER NUTS L'UTILISE !</li>
        </ul>
        </h3>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>
