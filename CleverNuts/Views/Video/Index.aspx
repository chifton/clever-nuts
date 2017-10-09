<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <script type="text/javascript">

            function load() {

                var video = document.getElementById("myVideo");

                video.addEventListener("error", function (event) {
                    switch (event.target.error.code) {
                        case event.target.error.MEDIA_ERR_ABORTED:
                            alert('La lecture du média a été annulée.');
                            break;
                        case event.target.error.MEDIA_ERR_NETWORK:
                            alert('Une erreur ou une indisponibilité réseau n\'a pas permis le bon déroulement du téléchargement.');
                            break;
                        case event.target.error.MEDIA_ERR_DECODE:
                            alert('La lecture a été annulée suite à une erreur de corruption du fichier, ou parce que le média utilise des fonctionnalités que ce navigateur ne peut supporter.');
                            break;
                        case event.target.error.MEDIA_ERR_SRC_NOT_SUPPORTED:
                            alert('Le fichier ne peut être chargé, soit parce que le serveur distant ou le réseau sont indisponibles, soit parce que le format n\'est pas supporté.');
                            break;
                    }
                });
            }

            document.addEventListener("DOMContentLoaded", load);

    </script>
    <video id="myVideo" autoplay="true" controls="controls">
        <source type="video/mp4" src="../Vids/fin.mp4" />
         <source type="video/flv" src="../Vids/fin.flv" />
         <source type="video/ogg" src="../Vids/fin.ogg" />
        <source type="video/avi" src="../Vids/fin.avi" />
     </video>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>