<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/SiteFbk.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
            <script type="text/javascript" src="../Scripts/jquery-1.8.2.min.js"></script>
            <script type="text/javascript" src="../Scripts/social.js"></script>
            <script src="../../Scripts/jquery.blockUI.js"></script>
            <script type="text/javascript">
                (function (d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) { return; }
                    js = d.createElement(s); js.id = id;
                    js.src = "//connect.facebook.net/en_US/sdk.js";
                    fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));

                // ADD ADDITIONAL FACEBOOK CODE HERE
                // Place following code after FB.init call.


                window.fbAsyncInit = function () {
                    FB.init({
                        appId: '722884087782449',
                        xfbml: true,
                        version: 'v2.1',
                        frictionlessRequests: true,
                        status: true
                    });

                    // On désactive le bouton de jeu le temps du chargement
                    //$("#mfsButton").enabled = false;

                    // Size
                    FB.Canvas.setSize();

                    FB.Event.subscribe('auth.authResponseChange', onAuthResponseChange);
                    FB.Event.subscribe('auth.statusChange', onStatusChange);

                    FB.getLoginStatus(function (response) {
                        //if (response.status == 'connected') {
                        //alert(response.authResponse.accessToken);
                        renderMFS(response.authResponse.accessToken);
                    });

                    // Fonction d'affichage du multi sélecteur
                    function renderMFS(parametresecret) {

                        function sortByName(a, b) {
                            var x = a.name.toLowerCase();
                            var y = b.name.toLowerCase();
                            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                        }

                        // First get the list of friends for this user with the Graph API
                        FB.api('/me/friends?access_token=' + parametresecret, function (response) {

                            if (response != null) {

                                var container = document.getElementById('mfs');
                                var amisdiv = document.getElementById('amis');
                                var mfsForm = document.createElement('form');
                                //var msFormSearch = document.getElementById('searchFbkFriends');
                                //var msFormSearchDiv = document.getElementById('searchFbk');
                                mfsForm.id = 'mfsForm';
                                //mfsForm.appendChild(msFormSearch);

                                // Gestion de la recherche
                                /*msFormSearch.addEventListener("click", function () {
                                    if (msFormSearch.getAttribute('value') == "Wait...") {
                                        msFormSearch.setAttribute('value', "");
                                    }

                                });*/

                                //alert(response.data.length);


                                //var urlphoto = '<img alt="photoProfile" src="';

                                //var photosurl = new Array(Math.min(response.data.length, 10));
                                //var friendPhoto = new Array(Math.min(response.data.length, 10));

                                // Tri des amis
                                _friend_data = response.data.sort(sortByName);

                                // Iterate through the array of friends object and create a checkbox for each one.
                                //Math.min(response.data.length, 10)
                                for (var i = 0; i < response.data.length; i++) {
                                    var friendItem = document.createElement('div');
                                    //var friendPhotoElement = document.createElement('img');
                                    //friendPhoto[i] = friendPhotoElement;
                                    //alert(friendPhoto[i]);
                                    //friendPhoto.id = 'friendphoto_' + response.data[i].id;
                                    //friendPhoto[i] = document.createElement('img');
                                    // Recherche photo
                                    //FB.api('/' + response.data[i].id, { fields: 'picture.width(50).height(50)' }, function (responsephoto) {
                                    //photosurl[i] = responsephoto.picture.data.url;
                                    //$("#friendphoto_" + response.data[i].id).attr('src',responsephoto.picture.data.url);
                                    //friendPhotoElement.setAttribute('src', responsephoto.picture.data.url);
                                    //reponseamisfbkphotos.picture.data.url + '" />';
                                    //reponseamisfbkphotos = responsephoto.picture.data.url;
                                    //});

                                    //$("#friendphoto_" + response.data[i].id).attr('width', '50px');
                                    //$("#friendphoto_" + response.data[i].id).attr('height', '50px');
                                    var adresseProfilPhoto = "https://graph.facebook.com/" + response.data[i].id.toString() + "/picture";
                                    var adresseProfil = "https://facebook.com/" + response.data[i].id.toString();
                                    friendItem.id = 'friend_' + response.data[i].id;
                                    friendItem.innerHTML = '<input type="hidden" class="friends" value="'
                                      + response.data[i].id
                                      + '" /><span id="nomjoueur">' + response.data[i].name + '</span><br/><img class="classeProfileFacebookImg" src=' + adresseProfilPhoto + ' />';
                                    //friendPhoto[i] = friendPhotoElement;
                                    //alert(friendPhoto[i].getAttribute('src'));
                                    //friendItem.appendChild(friendPhoto[i]);

                                    // Sélection premier élément
                                    if (i == 0) {
                                        friendItem.style.backgroundColor = '#b0c4de';
                                        $('input#amichoisi').val(response.data[i].id);
                                        $('input#amichoisiid').val(response.data[i].id);
                                        //$('input#idMonNom').val($("#enfonce").val());
                                    }

                                    //alert(response.data[i].id);
                                    mfsForm.appendChild(friendItem);
                                }
                                amisdiv.appendChild(mfsForm);
                                //container.appendChild(msFormSearchDiv);
                                //container.appendChild(amisdiv);
                                //container.appendChild(mfsButtonDiv);

                                //alert($("#mfsForm").children().length + " ici");

                                // Evènement choix ami facebook adversaire
                                var elementami;
                                for (var i = 0; i < $("#mfsForm").children().length ; i++) {
                                    $("#mfsForm").children().eq(i).click(function (e) {
                                        for (var j = 0; j < $("#mfsForm").children().length ; j++) {
                                            elementami = document.getElementById('friend_' + response.data[j].id);
                                            elementami.getElementsByTagName("span")[0].style.backgroundColor = 'transparent';
                                            elementami.style.backgroundColor = 'transparent';
                                            //alert(e.target);
                                        }
                                        if (e.target.tagName.toLowerCase() == 'div') {
                                            e.target.style.backgroundColor = '#b0c4de'; // .css("background-color", "lightblue");
                                            $('input#amichoisi').val(e.target.id);
                                            $('input#amichoisiid').val(e.target.id.substr(7, e.target.id.length - 7));
                                            //$('input#idMonNom').val($("#enfonce").val());
                                        }
                                        else if (e.target.tagName.toLowerCase() == 'span')
                                        {
                                            e.target.style.backgroundColor = '#b0c4de'; // .css("background-color", "lightblue");
                                            e.target.parentNode.style.backgroundColor = '#b0c4de';
                                            $('input#amichoisi').val(e.target.parentNode.id);
                                            $('input#amichoisiid').val(e.target.parentNode.id.substr(7, e.target.parentNode.id.length - 7));
                                            //$('input#idMonNom').val($("#enfonce").val());
                                        }
                                        else if (e.target.tagName.toLowerCase() == 'img') {
                                            e.target.parentNode.style.backgroundColor = '#b0c4de';
                                            $('input#amichoisi').val(e.target.parentNode.id);
                                            $('input#amichoisiid').val(e.target.parentNode.id.substr(7, e.target.parentNode.id.length - 7));
                                            //$('input#idMonNom').val($("#enfonce").val());
                                        }
                                    });

                                }

                                // Evènement clic sur bouton de jeu
                                $("#mfsButton").click(function (e) {

                                    FB.api('/me', { fields: 'id,first_name' }, function (responsefirstname) {
                                        // On cherche mon prénom
                                        var friendCache2 = {};
                                        friendCache2.me = responsefirstname;

                                        // On vérifie que le joueur a assez de crédits pour faire une partie à deux
                                        var urlcanplay = "/PlayFbk/canyouplay";
                                        $.get(urlcanplay, { idmoimatches: friendCache2.me.id }, function (datacanplay) {
                                            
                                            if(datacanplay == "OK")
                                                {
                                                function tokenS4() {
                                                    var d = new Date().getTime();
                                                    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                                                        var r = (d + Math.random() * 16) % 16 | 0;
                                                        d = Math.floor(d / 16);
                                                        return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
                                                    });
                                                    return uuid;
                                                };
                                            // On génère un code unique
                                            var codeunique = tokenS4();
                                            // On envoie une notification à l'adversaire pour qu'il clique et joue
                                            var urlnotifs = "/PlayFbk/sendnotificationtoplay";
                                            $.get(urlnotifs, { monid: $('input#amichoisiid').val(), prenomMoi: friendCache2.me.first_name, codetokenjeu: codeunique }, function (datanotifs) {
                                                //alert(datanotifs);
                                                //console.log(datanotifs);
                                                // Redirection vers la page de jeu
                                                FB.api('/' + $('input#amichoisiid').val(), { fields: 'first_name' }, function (responsefirstnameadversaire) {
                                                    var friendCache3 = {};
                                                    friendCache3.me = responsefirstnameadversaire;
                                                    location.href = "/PlayFbkFriend/Index?ordredemandejeugame=1&codejeuadeux=" + codeunique + "&prenom1=" + friendCache2.me.first_name + "&prenom2=" + friendCache3.me.first_name;
                                                });
                                            });

                                            }
                                            else if(datacanplay == "KO")
                                            {
                                                var reponsejeulast = jAlert("You don't have too much nuts to play against friends !\n Buy them or win them playing awale !", 'Not much nuts !', function (r) {
                                                    if (r) {
                                                        location.href = "/FacebookNutter/Manage?identifiant=" + friendCache2.me.id;
                                                    }
                                                });
                                            }
                                        });
                                        
                                    });

                                    //// Create a button to send the Request(s)
                                    //var sendButton = document.createElement('input');
                                    //sendButton.type = 'button';
                                    //sendButton.value = 'Send Request';
                                    //sendButton.onclick = sendRequest;
                                    //mfsForm.appendChild(sendButton);


                                });

                            }
                        });
                    }
                            /*else {
                                alert("etape2");
                            }*/

                };

                document.addEventListener("DOMContentLoaded", function () {


                    // Trainée de poudre derrière
                    $(document).mousemove(function (e) {
                        var image = $('<img id="traine">');
                        image.attr('src', '../../Images/trainee.png');
                        image.appendTo(document.body);
                        image.css({ "position": "absolute", top: e.pageY + 2, left: e.pageX + 2 }).fadeOut(1200);
                    });

                    // Apparition du hibou et de l'écureuil
                    var tophibouMechant = aleatoire(screen.availHeight);
                    var lefthibouMechant = aleatoire(screen.availWidth);
                    var hibouMechant = $('<img id="HibouMechant">');
                    hibouMechant.attr('src', '../../Images/hibouvolant.gif');
                    $("body").append(hibouMechant);
                    hibouMechant.css({ position: "absolute", left: lefthibouMechant + "px", top: tophibouMechant + "px" });
                    // Son du hibou
                    soundManager.onready(function () {
                        soundManager.createSound({
                            id: 'sonBoubou',
                            url: '/Sounds/hibou.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1,
                            volume: 70
                        });
                    });
                    soundManager.load('sonBoubou', {
                        onload: function () {
                            this.play();
                        }
                    });
                    setTimeout(function () {
                        hibouMechant.remove();
                    }, 1500);
                    setInterval(function () {
                        var tophibouMechant = aleatoire(screen.availHeight);
                        var lefthibouMechant = aleatoire(screen.availWidth);
                        var hibouMechant = $('<img id="HibouMechant">');
                        hibouMechant.attr('src', '../../Images/hibouvolant.gif');
                        $("body").append(hibouMechant);
                        hibouMechant.css({ position: "absolute", left: lefthibouMechant + "px", top: tophibouMechant + "px" });
                        // Son du hibou
                        soundManager.onready(function () {
                            soundManager.createSound({
                                id: 'sonBoubou',
                                url: '/Sounds/hibou.mp3',
                                autoplay: true,
                                autoload: true,
                                loops: 1,
                                volume: 70
                            });
                        });
                        soundManager.load('sonBoubou', {
                            onload: function () {
                                this.play();
                            }
                        });
                        setTimeout(function () {
                            hibouMechant.remove();
                        }, 1500);
                    }, 5000);

                    // Fonction de génération aléatoire
                    function aleatoire(N) {
                        return (Math.floor((N) * Math.random() + 1));
                    }

                });
                </script>
                            
    <div class="float-center">
        <h2>Select your friends !</h2>
        <div id="mfs">
            <div id="searchFbk"><!--<input type="text" id="searchFbkFriends" value="Wait..." />--><input type="button" id="mfsButton" value="Play !" /></div>
        <div id="amis"></div>
        </div>
    </div>
        <input type="hidden" id="amichoisi" name="amichoisi" class="amichoisi" value="" />
    <input type="hidden" id="amichoisiid" name="amichoisiid" class="amichoisiid" value="" />
        <input type="hidden" id="idMonNom" name="idMonNom" class="idMonNom" value="<%: Convert.ToString(ViewData["fbk"]) %>" />
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>