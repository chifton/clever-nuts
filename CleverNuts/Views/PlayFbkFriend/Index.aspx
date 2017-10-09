<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="indexFeatured" ContentPlaceHolderID="FeaturedContent" runat="server">
    <section class="featured">
    </section>
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
                 
            <script language="c#" runat="server">
            protected void Page_Load(object sender, EventArgs e)
                {
                if (IsPostBack == false)
                    {
                    // Mettre d'autres types de traitement après
                    }
                }
            </script>

            <script type="text/javascript" src="../Scripts/jquery-1.8.2.min.js"></script>
            <script type="text/javascript" src="../Scripts/soundmanager2.js"></script>
            <script type="text/javascript" src="../Scripts/jquery-blink.js"></script>
            <!--Script nécessaire pour la gestion du temps réel et du turn-based (tout à tour)-->
            <script src="../Scripts/jquery.signalR-2.1.0.min.js"></script>
            <script src="../../Scripts/jquery.blockUI.js"></script>
            <script src="../signalr/hubs"></script>
            <link href="../Content/jquery.cssemoticons.css" media="screen" rel="stylesheet" type="text/css" />
            <script type="text/javascript" src="../Scripts/jquery.cssemoticons.min.js"></script>

                <!-- Code JAVASCRIPT ICI -->
                <script type="text/javascript">


                document.addEventListener("DOMContentLoaded", function () {

                    // Récupération de tous les contrôles de la view
                    var transmissionbouffeur = 1;
                    var monnomcool;
                    var nomChat;
                    var nbJoueursEnLigne;
                    var serveurdejeu;
                    var peutChatter = 0;
                    var nomdemonjoueur;
                    var nomdujoueuradverse;
                    var jeutermine = 0;
                    var jeucommence = 0;
                    // Pour la bouffe dans les tablettes
                    var solutiontablette = 250;
                    var solutiontablette2 = 250;
                    var tablette = document.querySelector("#awale");
                    var label = new Array(12);
                    var trjoueur = 1;
                    for (var t = 0; t < label.length; t++) {
                        label[t] = document.querySelector(".label" + t);
                    }

                    // Gestion du résumé des règles
                    var regleimage = document.querySelector("#langueimage");
                    regleimage.addEventListener("click", function () {
                        if ($("#langueimage").attr("src") == "../../Images/drapfrance.jpg") {
                            $("#langueimage").attr("src", "../../Images/drapanglais.jpg");
                            $("#rules2").text("Collectez les noix d'un trou et distribuez-les dans le sens opposé aux aiguilles d'une montre, en sautant le trou de départ. Vous gagnez les noix des trous s'ils ont deux ou trois noix à la fin de votre tour.");
                        }
                        else if ($("#langueimage").attr("src") == "../../Images/drapanglais.jpg") {
                            $("#langueimage").attr("src", "../../Images/drapfrance.jpg");
                            $("#rules2").text("Collect nuts in a hole of your side and distribute them in the opposite direction of clockwise, one nut per hole, skipping the starting hole. You win two-nuts or three-nuts continuous holes at the end of your turn.");
                        }
                    });

                    // Animation des boutons
                    var images = document.querySelectorAll(".bonneimage");
                    var image = document.querySelectorAll(".bonneimage2");
                    for (var t = 0; t < images.length; t++) {
                        $(".bonneimage").eq(t).hover(function () {
                            $(this).animate({ width: 400 }, 1, "linear");
                        }, function () {
                            $(this).animate({ width: 274 }, 1, "linear");
                        });
                    }
                    $(".bonneimage2").hover(function () {
                        $(this).animate({ width: 400 }, 1, "linear");
                    }, function () { $(this).animate({ width: 290 }, 1, "linear"); });

                    // Son du public en arrière plan
                    soundManager.url = 'swf/';
                    /*soundManager.onready(function () {
                        soundManager.createSound({
                            id: 'sonPublic',
                            url: '/Sounds/cris.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1000000000000000,
                            volume: 30
                        });
                    });
                    soundManager.load('sonPublic', {
                        onload: function () {
                            this.play();
                        }
                    });*/

                    // Gestion en cas de fermeture prématurée du navigateur
                    var myEvent = window.attachEvent || window.addEventListener;
                    var chkevent = window.attachEvent ? 'onbeforeunload' : 'beforeunload'; /// make IE7, IE8 compitable

                    myEvent(chkevent, function (e) { // For >=IE7, Chrome, Firefox
                        if (jeutermine == 0 && jeucommence == 1) {
                            serveurdejeu.server.send3($("#tonGroupe").val());
                            serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                            $.connection.hub.stop();  // Arrête la connection au hub
                        }
                    });

                    /*$(window).on('beforeunload', function () {
                        if (jeutermine == 0 && jeucommence == 1) {
                            serveurdejeu.server.send3($("#tonGroupe").val());
                            serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                            $.connection.hub.stop();  // Arrête la connection au hub
                        }
                    });*/


                    // Initialisation des noms, des scores et des consoles
                    var sommeawale = 0;
                    var sommeawale1 = 0;
                    var sommeawale2 = 0;
                    var playor1;
                    var playor2;
                    var playorscore1;
                    var playorscore2;
                    var playorscorebonus1;
                    var playorscorebonus2;
                    var console1 = document.querySelector("#consoleJoueur1");
                    var console2 = document.querySelector("#consoleJoueur2");
                    var panel1 = document.querySelector("#detailsJoueur1_1");
                    var panel2 = document.querySelector("#detailsJoueur2_1");
                    var panel3 = document.querySelector("#detailsJoueur1_2");
                    var panel4 = document.querySelector("#detailsJoueur2_2");
                    var me1;
                    var me2;
                    var url1 = "/PlayFbkFriend/nom1";
                    var url2 = "/PlayFbkFriend/nom2";
                    var url3 = "/PlayFbkFriend/score1";
                    var url4 = "/PlayFbkFriend/score2";
                    var url5 = "/PlayFbkFriend/scorebonus1";
                    var url6 = "/PlayFbkFriend/scorebonus2";
                    console1.textContent = "It's your turn !";
                    $.get(url1, { jouant: "KO", codepartiejeu: $("#codeGameAsk").val() }, function (data1) {
                        panel1.textContent = data1;
                        me1 = data1;
                        playor1 = data1;
                    });
                    $.get(url2, { jouant: "KO", codepartiejeu: $("#codeGameAsk").val() }, function (data2) {
                        panel2.textContent = data2;
                        me2 = data2;
                        playor2 = data2;
                    });
                    $.get(url3, { jouant: "KO", codepartiejeu: $("#codeGameAsk").val() }, function (data3) {
                        panel1.textContent = me1 + " : " + data3 + " nuts";
                        playorscore1 = data3;
                    });
                    $.get(url4, { jouant: "KO", codepartiejeu: $("#codeGameAsk").val() }, function (data4) {
                        panel2.textContent = me2 + " : " + data4 + " nuts";
                        playorscore2 = data4;
                    });
                    $.get(url5, { jouant: "KO", codepartiejeu: $("#codeGameAsk").val() }, function (data5) {
                        panel3.textContent = "Bonus : " + data5;
                        playorscorebonus1 = data5;
                    });
                    $.get(url6, { jouant: "KO", codepartiejeu: $("#codeGameAsk").val() }, function (data6) {
                        panel4.textContent = "Bonus : " + data6;
                        playorscorebonus2 = data6;
                    });

                    // FONCTION DE GESTION DE SCORES ICI
                    // Gestion de la gagne, de la fin du jeu pour continuer ou pas
                    var myVar = setInterval(function () {

                        // Gestion de la gagne du jeu ou pas ici
                        // On met la somme de toutes les boules de l'awalé à 0
                        var sommeawale = 0;
                        var sommeawale1 = 0;
                        var sommeawale2 = 0;
                        for (var t = 0; t < label.length; t++) {
                            sommeawale = sommeawale + label[t].childElementCount;
                        }
                        for (var t = 0; t < 6; t++) {
                            sommeawale1 = sommeawale1 + label[t].childElementCount;
                        }
                        for (var t = 6; t < 12; t++) {
                            sommeawale2 = sommeawale2 + label[t].childElementCount;
                        }

                        /* Informations de jeu
                        console.log(sommeawale);
                        console.log(sommeawale1);
                        console.log(sommeawale2);
                        console.log(playorscore1);
                        console.log($('input#score2vrai').val());*/

                        // Récupération des informations de jeu
                        /*var $('input#nom1vrai').val()end;
                        var playor2end;
                        var playorscore1end;
                        var $('input#score2vrai').val()end;
                        var url1end = "/PlayFbkFriend/nom1";
                        var url2end = "/PlayFbkFriend/nom2";
                        var url3end = "/PlayFbkFriend/score1";
                        var url4end = "/PlayFbkFriend/score2";
                        $.get(url1end, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data1) {
                            playor1end = data1;
                        });
                        $.get(url2end, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data2) {
                            playor2end = data2;
                        });
                        $.get(url3end, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data3) {
                            $('input#score1vrai').val()end = data3;
                        });
                        $.get(url4end, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data4) {
                            $('input#score2vrai').val()end = data4;
                        });*/

                        if (sommeawale1 == 0 || sommeawale2 == 0) {
                            var scorefinal1 = parseInt($('input#score1vrai').val()) + (parseInt(sommeawale1) != 0) * parseInt(sommeawale1);
                            var scorefinal2 = parseInt($('input#score2vrai').val()) + (parseInt(sommeawale2) != 0) * parseInt(sommeawale2);
                            var gagneur;
                            if (scorefinal2 > scorefinal1) {
                                gagneur = $('input#nom2vrai').val();
                            } else if (scorefinal2 < scorefinal1) {
                                gagneur = $('input#nom1vrai').val();
                            }
                            else {
                                gagneur = $('input#nom1vrai').val() + " and " + $('input#nom2vrai').val();
                            }
                            // Envoi des deux scores au controlleur
                            var urlend = "/PlayFbkFriend/EndGame";
                            $.get(urlend, { idMoi: $("#meId").val(), idPartieJeu : $("#tonGroupe").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                console.log("Oyé");
                                // ICI
                                /*var urlsessionGet = "/Play/getmysession";
                                $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                    alert("Session N°" + datasessioncool);
                                });*/
                            });

                            // Destruction de la connexion au hub et stopinterval et variable fin partie
                            serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                            clearInterval(myVar);
                            jeutermine = 1;

                            // Confirmation ou non de continuation de jeu
                            var reponsejeu = jConfirm(gagneur + " won ! Play again ?", 'Awale End !', function (r) {
                                if (r) {
                                    $.connection.hub.stop();  // Arrête la connection au hub
                                    location.href = '<%= Page.ResolveUrl("~/PlayFbk/Index") %>';
                                }
                                else {
                                    $.connection.hub.stop();  // Arrête la connection au hub
                                    location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                }
                            });
                            console1.textContent = "";
                            console2.textContent = "";
                        }
                        else if (parseInt($('input#score1vrai').val()) > 24 || parseInt($('input#score2vrai').val()) > 24 || sommeawale <= 6) {
                            jAlert("End of game, you share the rest !", "No nuch nuts !", function (r2) {
                                if (r2) {
                                    if (parseInt($('input#score1vrai').val()) > parseInt($('input#score2vrai').val())) {
                                        var scorefinal1 = parseInt($('input#score1vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var scorefinal2 = parseInt($('input#score2vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var gagneur = $('input#nom1vrai').val();
                                        // Envoi des deux scores au controlleur
                                        var urlend = "/PlayFbkFriend/EndGame";
                                        $.get(urlend, { idMoi: $("#meId").val(), idPartieJeu : $("#tonGroupe").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                            console.log("Oyé");
                                            // ICI
                                            /*var urlsessionGet = "/Play/getmysession";
                                            $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                                alert("Session N°" + datasessioncool);
                                            });*/
                                        });

                                        // Destruction de la connexion au hub
                                        serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                                        clearInterval(myVar);
                                        jeutermine = 1;

                                        // Confirmation ou non de continuation de jeu
                                        var reponsejeu = jConfirm($('input#nom1vrai').val() + " won ! Play again ?", 'Awale End !', function (r) {
                                            if (r) {
                                                $.connection.hub.stop();  // Arrête la connection au hub
                                                location.href = '<%= Page.ResolveUrl("~/PlayFbk/Index") %>';
                                            }
                                            else {
                                                $.connection.hub.stop();  // Arrête la connection au hub
                                                location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                            }
                                        });
                                        console1.textContent = "";
                                        console2.textContent = "";
                                        console1.style.backgroundImage = "url('../Images/youwon.png')";
                                        console1.style.backgroundRepeat = "no-repeat";
                                        console1.style.backgroundPositionX = "center";
                                        console1.style.backgroundPositionY = "center";
                                    }
                                    else if (parseInt($('input#score2vrai').val()) > parseInt($('input#score1vrai').val())) {
                                        var scorefinal1 = parseInt($('input#score1vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var scorefinal2 = parseInt($('input#score2vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var gagneur = $('input#nom2vrai').val();
                                        // Envoi des deux scores au controlleur
                                        var urlend = "/PlayFbkFriend/EndGame";
                                        $.get(urlend, { idMoi: $("#meId").val(), idPartieJeu : $("#tonGroupe").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                            console.log("Oyé");
                                            // ICI
                                            /*var urlsessionGet = "/Play/getmysession";
                                            $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                                alert("Session N°" + datasessioncool);
                                            });*/
                                        });

                                        // Destruction de la connexion au hub
                                        serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                                        clearInterval(myVar);
                                        jeutermine = 1;

                                        // Confirmation ou non de continuation de jeu
                                        var reponsejeu = jConfirm($('input#nom2vrai').val() + " won ! Play again ?", 'Awale End !', function (r) {
                                            if (r) {
                                                $.connection.hub.stop();  // Arrête la connection au hub
                                                location.href = '<%= Page.ResolveUrl("~/PlayFbk/Index") %>';
                                            }
                                            else {
                                                $.connection.hub.stop();  // Arrête la connection au hub
                                                location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                            }
                                        });
                                        console1.textContent = "";
                                        console2.textContent = "";
                                        console2.style.backgroundImage = "url('../Images/youwon.png')";
                                        console2.style.backgroundRepeat = "no-repeat";
                                        console2.style.backgroundPositionX = "center";
                                        console2.style.backgroundPositionY = "center";
                                    }
                                    else if (parseInt($('input#score2vrai').val()) == parseInt($('input#score1vrai').val())) {
                                        var scorefinal1 = parseInt($('input#score1vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var scorefinal2 = parseInt($('input#score2vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var gagneur = $('input#nom1vrai').val() + " and " + $('input#nom2vrai').val();
                                        // Envoi des deux scores au controlleur
                                        var urlend = "/PlayFbkFriend/EndGame";
                                        $.get(urlend, { idMoi: $("#meId").val(), idPartieJeu : $("#tonGroupe").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                            console.log("Oyé");
                                            // ICI
                                            /*var urlsessionGet = "/Play/getmysession";
                                            $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                                alert("Session N°" + datasessioncool);
                                            });*/
                                        });

                                        // Destruction de la connexion au hub
                                        serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                                        clearInterval(myVar);
                                        jeutermine = 1;

                                        // Confirmation ou non de continuation de jeu
                                        var reponsejeu = jConfirm($('input#nom1vrai').val() + " and " + $('input#nom2vrai').val() + " are in equality ! Play again ?", 'Awale End !', function (r) {
                                            if (r) {
                                                $.connection.hub.stop();  // Arrête la connection au hub
                                                location.href = '<%= Page.ResolveUrl("~/PlayFbk/Index") %>';
                                            }
                                            else {
                                                $.connection.hub.stop();  // Arrête la connection au hub
                                                location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                            }
                                        });
                                        console1.textContent = "";
                                        console2.textContent = "";
                                        console1.style.backgroundImage = "url('../Images/equality.png')";
                                        console1.style.backgroundRepeat = "no-repeat";
                                        console1.style.backgroundPositionX = "center";
                                        console1.style.backgroundPositionY = "center";
                                        console2.style.backgroundImage = "url('../Images/equality.png')";
                                        console2.style.backgroundRepeat = "no-repeat";
                                        console2.style.backgroundPositionX = "center";
                                        console2.style.backgroundPositionY = "center";
                                    }
                                }
                            });
                        }
                    }, 3000);

                    function arrange(numerolabel) {
                        var nombre = $(".label" + numerolabel).children().length;
                        var enfants = new Array(nombre);
                        for (var t = 0; t < nombre; t++) {
                            enfants[t] = $(".label" + numerolabel).children().eq(t);
                        }

                        switch (nombre) {
                            case 1:
                                enfants[0].css({ top: "28px", left: "28px" });
                                break;

                            case 2:
                                enfants[0].css({ top: "28px", left: "10px" });
                                enfants[1].css({ top: "28px", left: "45px" });
                                break;

                            case 3:
                                enfants[0].css({ top: "10px", left: "28px" });
                                enfants[1].css({ top: "45px", left: "10px" });
                                enfants[2].css({ top: "45px", left: "45px" });
                                break;

                            case 4:
                                enfants[0].css({ top: "10px", left: "10px" });
                                enfants[1].css({ top: "10px", left: "45px" });
                                enfants[2].css({ top: "45px", left: "10px" });
                                enfants[3].css({ top: "45px", left: "45px" });
                                break;

                            default:

                                var degre = 0;
                                var rayonnement = 28;
                                for (var s = 0; s < nombre; s++) {
                                    if (s == 10) {
                                        degre = 0;
                                        rayonnement = rayonnement - 10;
                                    }
                                    if (s == 18) {
                                        degre = 0;
                                        rayonnement = rayonnement - 10;
                                    }
                                    addCircle(28, 28, rayonnement, degre, enfants[s]);
                                    if (nombre <= 10) {
                                        degre = degre + 360 / nombre;
                                    }
                                    else if (nombre > 10) {
                                        if (nombre <= 18) {
                                            if (s < 10) {
                                                degre = degre + 36;
                                            }
                                            else if (s >= 10 && s < 18) {
                                                degre = degre + 360 / (nombre - 10);
                                            }
                                        }
                                        else if (nombre > 18) {
                                            if (s < 10) {
                                                degre = degre + 36;
                                            }
                                            else if (s >= 10 && s < 18) {
                                                degre = degre + 45;
                                            }
                                            else if (s >= 18) {
                                                degre = degre + (nombre - 18);
                                            }
                                        }
                                    }
                                }

                                break;
                        }

                        // Fonction d'explosion et de scintillement
                        var explosion = $('<img id="explosion">');
                        explosion.attr('src', '../../Images/explosion.png');
                        $("#awale").append(explosion);
                        explosion.css({ position: "absolute", top: $(".label" + numerolabel).css('top'), left: $(".label" + numerolabel).css('left') }).fadeOut(2000);

                        // Fonction pour jouer le son de l'explosion à chaque déplacement de graine
                        soundManager.url = 'swf/';
                        soundManager.onready(function () {
                            // first, make the sound
                            soundManager.createSound({
                                id: 'sonBoule',
                                url: '/Sounds/explod.mp3',
                                autoplay: true,
                                autoload: true,
                            });
                        });
                        soundManager.load('sonBoule', {
                            onload: function () {
                                this.play();
                            }
                        });

                    }

                    function addCircle(centreX, centreY, rayon, angle, boule) {
                        var positionCircleX = centreX + rayon * Math.cos(angle * Math.PI / 180);
                        var positionCircleY = centreY + rayon * Math.sin(angle * Math.PI / 180);

                        var coordonnees = new Array(2);
                        coordonnees[0] = positionCircleX;
                        coordonnees[1] = positionCircleY;

                        boule.css({ top: coordonnees[1] + "px", left: coordonnees[0] + "px" });
                    }


                    function retourneLettre(number) {
                        foo = $(".label" + number).attr("class");
                        switch (foo) {
                            case "label0":
                                return "A";
                                break;
                            case "label1":
                                return "B";
                                break;
                            case "label2":
                                return "C";
                                break;
                            case "label3":
                                return "D";
                                break;
                            case "label4":
                                return "E";
                                break;
                            case "label5":
                                return "F";
                                break;
                            case "label6":
                                return "A";
                                break;
                            case "label7":
                                return "B";
                                break;
                            case "label8":
                                return "C";
                                break;
                            case "label9":
                                return "D";
                                break;
                            case "label10":
                                return "E";
                                break;
                            case "label11":
                                return "F";
                                break;
                            default:
                                return "Nothing";
                                break;
                        }
                    }


                    // FONCTION APPELEE PAR LE SERVEUR A CHAQUE CLIC DE JOUEUR
                    // SUR UN TROU
                    $(function () {
                        serveurdejeu = $.connection.gameserverfbk;
                        // Reference the auto-generated proxy for the hub.
                        //var serveurdejeu = $.connection.gameserver;
                        // Create a function that the hub can call back to display messages.

                        // 2 CODES DE JEU ICI
                        serveurdejeu.client.jouerawale = function (p) {

                            console.log("Je joue 1");
                            // Gestion des clics sur chaque trou et des déplacements de jeu des glands
                            if ((trjoueur == 1 && p > 5) || (trjoueur == 2 && p < 6)) {
                                if (trjoueur == 1) {
                                    console1.textContent = "Cliquez sur vos propres cases !";
                                }
                                else if (trjoueur == 2) {
                                    console2.textContent = "Cliquez sur vos propres cases !";
                                }
                                // Gestion du clic unique
                                switch (p) {
                                    case 0:
                                        document.getElementById('<%=label0.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 1:
                                        document.getElementById('<%=label1.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 2:
                                        document.getElementById('<%=label2.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 3:
                                        document.getElementById('<%=label3.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 4:
                                        document.getElementById('<%=label4.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 5:
                                        document.getElementById('<%=label5.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 6:
                                        document.getElementById('<%=label6.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 7:
                                        document.getElementById('<%=label7.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 8:
                                        document.getElementById('<%=label8.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 9:
                                        document.getElementById('<%=label9.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 10:
                                        document.getElementById('<%=label10.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    case 11:
                                        document.getElementById('<%=label11.ClientID%>').style.pointerEvents = "auto";
                                        break;
                                    default:
                                        break;
                                }

                            }
                            else {
                                // Si la fonction ajax retourne un ok c'est possible de joueur, on joue
                                // Interroger le controlleur et le serveur ici
                                var url = "/PlayFbkFriend/Sequence";
                                var lettre = retourneLettre(p);
                                $.get(url, { possible: lettre, codepartiejeu: $("#codeGameAsk").val()}, function (data) {

                                    // FAIRE le déplacement en fonction de la condition d'en bas
                                    if (data == "OK") {

                                        // On appelle le serveur pour valider le jeu chez l'adversaire
                                        serveurdejeu.server.jeuChezAdversaire(p, $("#tonGroupe").val());

                                        var trou = p;
                                        var trou2 = p;
                                        var nbcontrols = label[p].childElementCount;   // pour jumeler ça avec le code de l'awale console après ou les threads
                                        var nbcontrols2 = label[p].childElementCount;
                                        var nbcontrols3 = label[p].childElementCount;

                                        var hauteur;
                                        var largeur;
                                        var position1;
                                        var position2;
                                        var temps;
                                        var tempsboucle;
                                        var ok = false;
                                        var tower;
                                        var tower2;
                                        var incremente = 0;
                                        var poseidon1;
                                        var poseidon2;
                                        var poseidon3;
                                        var poseidon4;

                                        var bouffeur;
                                        var tablebouffe;

                                        while (nbcontrols2 > 0) {

                                            trou = trou + 1;
                                            if (trou == 12) {
                                                trou = 0;
                                            }

                                            hauteur = parseInt(label[trou].style.top);
                                            largeur = parseInt(label[trou].style.left);

                                            if (trou != p) {

                                                // Pour gérer les nombre de tours dans un jeu
                                                // Déplacements en cercle indépendants des déplacement réels
                                                incremente = incremente + 1;
                                                tower = incremente % 11;
                                                tempsboucle = 0;
                                                if (incremente > 11) {
                                                    if (tower > 0) {
                                                        tower2 = (incremente - tower) / 11;
                                                        for (var s = 1; s <= tower2; s++) {
                                                            console.log("1er tour !!!");
                                                            // Faire 1 tour d'awalé à chaque boucle
                                                            if (p >= 0 && p <= 5) {
                                                                position1 = (p == 5) * 35 + (p != 5) * (35 + parseInt(label[5].style.left) - parseInt(label[p].style.left));
                                                                var pos1 = position1;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                                position2 = 100;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                                position1 = pos1 + parseInt(label[11].style.left) - 35;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing");
                                                                position2 = 35;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                                position1 = 35;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                                tempsboucle = tempsboucle + 5500;
                                                            }
                                                            else if (p >= 6 && p <= 11) {
                                                                position1 = (p == 11) * 35 + (p != 11) * (35 + parseInt(label[11].style.left) - parseInt(label[p].style.left));
                                                                var pos1 = position1;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                                position2 = -65;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                                position1 = pos1 - parseInt(label[0].style.left) + parseInt(label[5].style.left);
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing");
                                                                position2 = 35;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                                position1 = 35;
                                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                                tempsboucle = tempsboucle + 5500;
                                                            }
                                                        }
                                                    }
                                                }

                                                // Après un éventuel traitement des tours déjà faits
                                                if (trou > p) {
                                                    if (p >= 0 && p <= 4) {
                                                        if (trou <= 5) {
                                                            position1 = largeur - parseInt(label[p].style.left);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing",
                                                                (function (z, g, n) {
                                                                    return function () {
                                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                        arrange(g);
                                                                    }
                                                                })(nbcontrols2, trou, p));
                                                            temps = 1500;
                                                            //ok = true;
                                                        }
                                                        else if (trou > 5 && trou <= 11) {
                                                            position1 = parseInt(label[5].style.left) + 35 - parseInt(label[p].style.left);
                                                            position2 = 110;
                                                            var pos1 = position1;
                                                            var pos2 = position2;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1300, "swing");
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                            position1 = pos1 * (trou == 6) + (trou != 6) * (pos1 + largeur - parseInt(label[6].style.left));
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                                return function () {
                                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                    arrange(g);
                                                                }
                                                            })(nbcontrols2, trou, p));
                                                            temps = 3100;
                                                            //ok = true;
                                                        }
                                                    }
                                                    else if (p == 5) {
                                                        var pos1 = 35;
                                                        position2 = 110;
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                        position1 = pos1 * (trou == 6) + (trou != 6) * (pos1 + largeur - parseInt(label[6].style.left));
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                            return function () {
                                                                $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                arrange(g);
                                                            }
                                                        })(nbcontrols2, trou, p));
                                                        temps = 1800;
                                                        //ok = true;
                                                    }
                                                    else if (p >= 6 && p < 11) {
                                                        if (trou <= 11) {
                                                            position1 = largeur - parseInt(label[p].style.left) + 35;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing", (function (z, g, n) {
                                                                return function () {
                                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                    arrange(g);
                                                                }
                                                            })(nbcontrols2, trou, p));
                                                            temps = 1500;
                                                            //ok = true;
                                                        }
                                                    }
                                                }
                                                else if (trou < p) {
                                                    if (p >= 6 && p < 11) {
                                                        if (trou <= 5) {
                                                            position1 = parseInt(label[11].style.left) - parseInt(label[p].style.left) + 35;
                                                            var pos1 = position1;
                                                            position2 = hauteur - 100;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                            position1 = pos1 * (trou == 0) + (trou != 0) * (pos1 - parseInt(label[0].style.left) + largeur);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                                return function () {
                                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                    arrange(g);
                                                                }
                                                            })(nbcontrols2, trou, p));
                                                            temps = 3300;
                                                            //ok = true;
                                                        }
                                                        else if (trou > 5) {
                                                            position1 = parseInt(label[11].style.left) - parseInt(label[p].style.left) + 35;
                                                            var pos1 = position1;
                                                            position2 = 65;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": -position2 + "px" }, 1300, "swing");
                                                            position1 = pos1 - parseInt(label[0].style.left) + parseInt(label[5].style.left);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1000, "swing");
                                                            position2 = 35;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                            pos1 = position1;
                                                            position1 = 35 - parseInt(label[p].style.left) + parseInt(label[trou].style.left);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 600, "swing", (function (z, g, n) {
                                                                return function () {
                                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                    arrange(g);
                                                                }
                                                            })(nbcontrols2, trou, p));
                                                            temps = 5200;
                                                            //ok = true;
                                                        }
                                                    }
                                                    else if (p == 11) {
                                                        if (trou <= 5) {
                                                            position1 = 35;
                                                            var pos1 = position1;
                                                            position2 = hauteur - 100;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                            position1 = pos1 * (trou == 0) + (trou != 0) * (pos1 - parseInt(label[0].style.left) + largeur);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                                return function () {
                                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                    arrange(g);
                                                                }
                                                            })(nbcontrols2, trou, p));
                                                            temps = 3300;
                                                            //ok = true;
                                                        }
                                                        else if (trou > 5) {
                                                            position1 = 35;
                                                            var pos1 = position1;
                                                            position2 = 65;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": -position2 + "px" }, 1300, "swing");
                                                            position1 = pos1 - parseInt(label[0].style.left) + parseInt(label[5].style.left);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1000, "swing");
                                                            position2 = 35;
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                            pos1 = position1;
                                                            position1 = 35 - parseInt(label[p].style.left) + parseInt(label[trou].style.left);
                                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 600, "swing", (function (z, g, n) {
                                                                return function () {
                                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                    arrange(g);
                                                                }
                                                            })(nbcontrols2, trou, p));
                                                            temps = 5200;
                                                            //ok = true;
                                                        }
                                                    }
                                                    else if (p >= 0 && p < 6) {
                                                        position1 = (p != 5) * (parseInt(label[5].style.left) + 35 - parseInt(label[p].style.left)) + 35 * (p == 5);
                                                        position2 = 110;
                                                        var pos1 = position1;
                                                        var pos2 = position2;
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1300, "swing");
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                        position1 = pos1 + parseInt(label[11].style.left) - 35;
                                                        pos1 = position1;
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                        position2 = 35;
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                        position1 = pos1 * (trou == 0) + (trou != 0) * (35 - parseInt(label[p].style.left) + parseInt(label[trou].style.left));
                                                        $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                            return function () {
                                                                $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                                $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                                $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                                arrange(g);
                                                            }
                                                        })(nbcontrols2, trou, p));
                                                        temps = 5600;
                                                        //ok = true;
                                                    }
                                                }
                                                nbcontrols2 = nbcontrols2 - 1;
                                            }
                                        }

                                        // Gestion de la bouffe, par settimeout à la fin de toutes les animations
                                        // On bouffe les noix de l'adversaire si on a 2 ou 3 boules dans les trous
                                        tablebouffe = document.querySelector("#tabletteGains" + $("#orderGameAsk").val());
                                        setTimeout(function () {
                                            if ($("#orderGameAsk").val() == 1) {
                                                if (trou > 5 && trou < 12) {
                                                    console.log(trou + "1");
                                                    for (var o = trou; o > 5; o--) {
                                                        if (label[o].childElementCount != 2 && label[o].childElementCount != 3) {
                                                            console.log("Pas possible !");
                                                            break;
                                                        }
                                                        else {
                                                            bouffeur = label[o].childElementCount;
                                                            console.log("Bouffe !");
                                                            for (var f = 0; f < bouffeur; f++) {
                                                                tablebouffe.appendChild(label[o].firstChild);
                                                                if (tablebouffe.childElementCount < 10) {
                                                                    tablebouffe.lastChild.style.position = "absolute";
                                                                    tablebouffe.lastChild.style.top = "23px";
                                                                    tablebouffe.lastChild.style.left = solutiontablette + "px";
                                                                    solutiontablette = solutiontablette + 15;
                                                                    if (tablebouffe.childElementCount == 9) {
                                                                        solutiontablette = 250;
                                                                    }
                                                                }
                                                                else if (tablebouffe.childElementCount >= 10 && tablebouffe.childElementCount < 19) {
                                                                    tablebouffe.lastChild.style.position = "absolute";
                                                                    tablebouffe.lastChild.style.top = "38px";
                                                                    tablebouffe.lastChild.style.left = solutiontablette + "px";
                                                                    solutiontablette = solutiontablette + 15;
                                                                    if (tablebouffe.childElementCount == 18) {
                                                                        solutiontablette = 250;
                                                                    }
                                                                }
                                                                else if (tablebouffe.childElementCount >= 19) {
                                                                    tablebouffe.lastChild.style.position = "absolute";
                                                                    tablebouffe.lastChild.style.top = "53px";
                                                                    tablebouffe.lastChild.style.left = solutiontablette + "px";
                                                                    solutiontablette = solutiontablette + 15;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            else if ($("#orderGameAsk").val() == 2) {
                                                if (trou >= 0 && trou < 6) {
                                                    console.log(trou + "2");
                                                    for (var o = trou; o >= 0; o--) {
                                                        if (label[o].childElementCount != 2 && label[o].childElementCount != 3) {
                                                            console.log("Pas possible !");
                                                            break;
                                                        }
                                                        else {
                                                            bouffeur = label[o].childElementCount;
                                                            console.log(bouffeur + " noix !!!!! awale1");
                                                            console.log("Bouffe !");
                                                            for (var f = 0; f < bouffeur; f++) {
                                                                tablebouffe.appendChild(label[o].firstChild);
                                                                if (tablebouffe.childElementCount < 10) {
                                                                    tablebouffe.lastChild.style.position = "absolute";
                                                                    tablebouffe.lastChild.style.top = "23px";
                                                                    tablebouffe.lastChild.style.left = solutiontablette2 + "px";
                                                                    solutiontablette2 = solutiontablette2 + 15;
                                                                    if (tablebouffe.childElementCount == 9) {
                                                                        solutiontablette2 = 250;
                                                                    }
                                                                }
                                                                else if (tablebouffe.childElementCount >= 10 && tablebouffe.childElementCount < 19) {
                                                                    tablebouffe.lastChild.style.position = "absolute";
                                                                    tablebouffe.lastChild.style.top = "38px";
                                                                    tablebouffe.lastChild.style.left = solutiontablette2 + "px";
                                                                    solutiontablette2 = solutiontablette2 + 15;
                                                                    if (tablebouffe.childElementCount == 18) {
                                                                        solutiontablette2 = 250;
                                                                    }
                                                                }
                                                                else if (tablebouffe.childElementCount >= 19) {
                                                                    tablebouffe.lastChild.style.position = "absolute";
                                                                    tablebouffe.lastChild.style.top = "53px";
                                                                    tablebouffe.lastChild.style.left = solutiontablette2 + "px";
                                                                    solutiontablette2 = solutiontablette2 + 15;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            // Mise à jour des panels de jeu (nom, score, scorebonus...)
                                            $.get(url1, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data1) {
                                                panel1.textContent = data1;
                                                me1 = data1;
                                                playor1 = data1;
                                                $('input#nom1vrai').val(data1);
                                            });
                                            $.get(url2, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data2) {
                                                panel2.textContent = data2;
                                                me2 = data2;
                                                playor2 = data2;
                                                $('input#nom2vrai').val(data2);
                                            });
                                            $.get(url3, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data3) {
                                                panel1.textContent = me1 + " : " + data3 + " nuts";
                                                $('input#score1vrai').val(data3);
                                            });
                                            $.get(url4, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data4) {
                                                panel2.textContent = me2 + " : " + data4 + " nuts";
                                                $('input#score2vrai').val(data4);
                                            });
                                            $.get(url5, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data5) {
                                                panel3.textContent = "Bonus : " + data5;
                                                playorscorebonus1 = data5;
                                            });
                                            $.get(url6, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data6) {
                                                panel4.textContent = "Bonus : " + data6;
                                                playorscorebonus2 = data6;
                                            });

                                            // Gestion des tours de jeu et du champMe
                                            if (trjoueur == 1) {
                                                trjoueur = 2;
                                                console2.textContent = "It's your turn !";
                                                console1.textContent = "";
                                            }
                                            else if (trjoueur == 2) {
                                                trjoueur = 1;
                                                console1.textContent = "It's your turn !";
                                                console2.textContent = "";
                                            }
                                            // Modification du champ champMe
                                            if ($("#champMe").attr("value") == "0") {
                                                $("#champMe").attr("value", "1");
                                            }
                                            else if ($("#champMe").attr("value") == "1") {
                                                $("#champMe").attr("value", "0");
                                            }

                                            // Gestion du clic unique
                                            switch (p) {
                                                case 0:
                                                    document.getElementById('<%=label0.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 1:
                                                    document.getElementById('<%=label1.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 2:
                                                    document.getElementById('<%=label2.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 3:
                                                    document.getElementById('<%=label3.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 4:
                                                    document.getElementById('<%=label4.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 5:
                                                    document.getElementById('<%=label5.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 6:
                                                    document.getElementById('<%=label6.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 7:
                                                    document.getElementById('<%=label7.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 8:
                                                    document.getElementById('<%=label8.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 9:
                                                    document.getElementById('<%=label9.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 10:
                                                    document.getElementById('<%=label10.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                case 11:
                                                    document.getElementById('<%=label11.ClientID%>').style.pointerEvents = "auto";
                                                    break;
                                                default:
                                                    break;
                                            }
                                            console.log("Temps total : " + tempsboucle + " boucle et " + temps + " simple");
                                        }, temps + tempsboucle + 200);

                                    } // Fin du OK du jeu ici : retour serveur positif

                                        // S'il y a des couacs pour le retour serveur controlleur, on les gère
                                    else if (data == "KO") {
                                        var url10 = "/PlayFbkFriend/bonArgument";
                                        $.get(url10, { codepartiejeu: $("#codeGameAsk").val() }, function (data10) {
                                            if (data10 = "Pas de noix dans la case choisie !") {
                                                if (trjoueur == 1) {
                                                    console1.textContent = data10;
                                                }
                                                else if (trjoueur == 2) {
                                                    console2.textContent = data10;
                                                }
                                            }
                                        });
                                        // Gestion du clic unique
                                        switch (p) {
                                            case 0:
                                                document.getElementById('<%=label0.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 1:
                                                document.getElementById('<%=label1.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 2:
                                                document.getElementById('<%=label2.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 3:
                                                document.getElementById('<%=label3.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 4:
                                                document.getElementById('<%=label4.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 5:
                                                document.getElementById('<%=label5.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 6:
                                                document.getElementById('<%=label6.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 7:
                                                document.getElementById('<%=label7.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 8:
                                                document.getElementById('<%=label8.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 9:
                                                document.getElementById('<%=label9.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 10:
                                                document.getElementById('<%=label10.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            case 11:
                                                document.getElementById('<%=label11.ClientID%>').style.pointerEvents = "auto";
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                });

                            }// Fin else clic du bon joueur ici

                        };

                        serveurdejeu.client.jouerawale2 = function (p) {

                            console.log("Je joue 2");

                            var trou = p;
                            var trou2 = p;
                            var nbcontrols = label[p].childElementCount;   // pour jumeler ça avec le code de l'awale console après ou les threads
                            var nbcontrols2 = label[p].childElementCount;
                            var nbcontrols3 = label[p].childElementCount;

                            var hauteur;
                            var largeur;
                            var position1;
                            var position2;
                            var temps;
                            var tempsboucle;
                            var ok = false;
                            var tower;
                            var tower2;
                            var incremente = 0;
                            var poseidon1;
                            var poseidon2;
                            var poseidon3;
                            var poseidon4;

                            var bouffeur;
                            var tablebouffe;

                            while (nbcontrols2 > 0) {

                                trou = trou + 1;
                                if (trou == 12) {
                                    trou = 0;
                                }

                                hauteur = parseInt(label[trou].style.top);
                                largeur = parseInt(label[trou].style.left);

                                if (trou != p) {

                                    // Pour gérer les nombre de tours dans un jeu
                                    // Déplacements en cercle indépendants des déplacement réels
                                    incremente = incremente + 1;
                                    tower = incremente % 11;
                                    tempsboucle = 0;
                                    if (incremente > 11) {
                                        if (tower > 0) {
                                            tower2 = (incremente - tower) / 11;
                                            for (var s = 1; s <= tower2; s++) {
                                                console.log("1er tour !!!");
                                                // Faire 1 tour d'awalé à chaque boucle
                                                if (p >= 0 && p <= 5) {
                                                    position1 = (p == 5) * 35 + (p != 5) * (35 + parseInt(label[5].style.left) - parseInt(label[p].style.left));
                                                    var pos1 = position1;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                    position2 = 100;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                    position1 = pos1 + parseInt(label[11].style.left) - 35;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing");
                                                    position2 = 35;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                    position1 = 35;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                    tempsboucle = tempsboucle + 5500;
                                                }
                                                else if (p >= 6 && p <= 11) {
                                                    position1 = (p == 11) * 35 + (p != 11) * (35 + parseInt(label[11].style.left) - parseInt(label[p].style.left));
                                                    var pos1 = position1;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                    position2 = -65;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                    position1 = pos1 - parseInt(label[0].style.left) + parseInt(label[5].style.left);
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing");
                                                    position2 = 35;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                    position1 = 35;
                                                    $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                    tempsboucle = tempsboucle + 5500;
                                                }
                                            }
                                        }
                                    }

                                    // Après un éventuel traitement des tours déjà faits
                                    if (trou > p) {
                                        if (p >= 0 && p <= 4) {
                                            if (trou <= 5) {
                                                position1 = largeur - parseInt(label[p].style.left);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing",
                                                    (function (z, g, n) {
                                                        return function () {
                                                            $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                            $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                            $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                            arrange(g);
                                                        }
                                                    })(nbcontrols2, trou, p));
                                                temps = 1500;
                                                //ok = true;
                                            }
                                            else if (trou > 5 && trou <= 11) {
                                                position1 = parseInt(label[5].style.left) + 35 - parseInt(label[p].style.left);
                                                position2 = 110;
                                                var pos1 = position1;
                                                var pos2 = position2;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1300, "swing");
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                position1 = pos1 * (trou == 6) + (trou != 6) * (pos1 + largeur - parseInt(label[6].style.left));
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                    return function () {
                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                        arrange(g);
                                                    }
                                                })(nbcontrols2, trou, p));
                                                temps = 3100;
                                                //ok = true;
                                            }
                                        }
                                        else if (p == 5) {
                                            var pos1 = 35;
                                            position2 = 110;
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                            position1 = pos1 * (trou == 6) + (trou != 6) * (pos1 + largeur - parseInt(label[6].style.left));
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                return function () {
                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                    arrange(g);
                                                }
                                            })(nbcontrols2, trou, p));
                                            temps = 1800;
                                            //ok = true;
                                        }
                                        else if (p >= 6 && p < 11) {
                                            if (trou <= 11) {
                                                position1 = largeur - parseInt(label[p].style.left) + 35;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing", (function (z, g, n) {
                                                    return function () {
                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                        arrange(g);
                                                    }
                                                })(nbcontrols2, trou, p));
                                                temps = 1500;
                                                //ok = true;
                                            }
                                        }
                                    }
                                    else if (trou < p) {
                                        if (p >= 6 && p < 11) {
                                            if (trou <= 5) {
                                                position1 = parseInt(label[11].style.left) - parseInt(label[p].style.left) + 35;
                                                var pos1 = position1;
                                                position2 = hauteur - 100;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                position1 = pos1 * (trou == 0) + (trou != 0) * (pos1 - parseInt(label[0].style.left) + largeur);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                    return function () {
                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                        arrange(g);
                                                    }
                                                })(nbcontrols2, trou, p));
                                                temps = 3300;
                                                //ok = true;
                                            }
                                            else if (trou > 5) {
                                                position1 = parseInt(label[11].style.left) - parseInt(label[p].style.left) + 35;
                                                var pos1 = position1;
                                                position2 = 65;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": -position2 + "px" }, 1300, "swing");
                                                position1 = pos1 - parseInt(label[0].style.left) + parseInt(label[5].style.left);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1000, "swing");
                                                position2 = 35;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                pos1 = position1;
                                                position1 = 35 - parseInt(label[p].style.left) + parseInt(label[trou].style.left);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 600, "swing", (function (z, g, n) {
                                                    return function () {
                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                        arrange(g);
                                                    }
                                                })(nbcontrols2, trou, p));
                                                temps = 5200;
                                                //ok = true;
                                            }
                                        }
                                        else if (p == 11) {
                                            if (trou <= 5) {
                                                position1 = 35;
                                                var pos1 = position1;
                                                position2 = hauteur - 100;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                                position1 = pos1 * (trou == 0) + (trou != 0) * (pos1 - parseInt(label[0].style.left) + largeur);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                    return function () {
                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                        arrange(g);
                                                    }
                                                })(nbcontrols2, trou, p));
                                                temps = 3300;
                                                //ok = true;
                                            }
                                            else if (trou > 5) {
                                                position1 = 35;
                                                var pos1 = position1;
                                                position2 = 65;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": -position2 + "px" }, 1300, "swing");
                                                position1 = pos1 - parseInt(label[0].style.left) + parseInt(label[5].style.left);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1000, "swing");
                                                position2 = 35;
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 800, "swing");
                                                pos1 = position1;
                                                position1 = 35 - parseInt(label[p].style.left) + parseInt(label[trou].style.left);
                                                $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 600, "swing", (function (z, g, n) {
                                                    return function () {
                                                        $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                        $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                        $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                        arrange(g);
                                                    }
                                                })(nbcontrols2, trou, p));
                                                temps = 5200;
                                                //ok = true;
                                            }
                                        }
                                        else if (p >= 0 && p < 6) {
                                            position1 = (p != 5) * (parseInt(label[5].style.left) + 35 - parseInt(label[p].style.left)) + 35 * (p == 5);
                                            position2 = 110;
                                            var pos1 = position1;
                                            var pos2 = position2;
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1300, "swing");
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                            position1 = pos1 + parseInt(label[11].style.left) - 35;
                                            pos1 = position1;
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 1500, "swing");
                                            position2 = 35;
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "top": position2 + "px" }, 1000, "swing");
                                            position1 = pos1 * (trou == 0) + (trou != 0) * (35 - parseInt(label[p].style.left) + parseInt(label[trou].style.left));
                                            $(".label" + p).children().eq(nbcontrols2 - 1).animate({ "left": position1 + "px" }, 800, "swing", (function (z, g, n) {
                                                return function () {
                                                    $(".label" + g).prepend($(".label" + n).children().eq(z - 1));
                                                    $(".label" + g).children().eq(0).css({ "top": "35px" });
                                                    $(".label" + g).children().eq(0).css({ "left": "35px" });
                                                    arrange(g);
                                                }
                                            })(nbcontrols2, trou, p));
                                            temps = 5600;
                                            //ok = true;
                                        }
                                    }
                                    nbcontrols2 = nbcontrols2 - 1;
                                }
                            }

                            // Gestion de la bouffe, par settimeout à la fin de toutes les animations
                            // On bouffe les noix de l'adversaire si on a 2 ou 3 boules dans les trous
                            var jackpot;
                            if ($("#orderGameAsk").val() == 1)
                            {
                                tablebouffe = document.querySelector("#tabletteGains2");
                                jackpot = 2;
                            }
                            else if ($("#orderGameAsk").val() == 2)
                            {
                                tablebouffe = document.querySelector("#tabletteGains1");
                                jackpot = 1;
                            }
                            setTimeout(function () {
                                if (jackpot == 1) {
                                    if (trou > 5 && trou < 12) {
                                        console.log(trou + "1");
                                        for (var o = trou; o > 5; o--) {
                                            console.log(label[o].childElementCount);
                                            var bug = label[o].childElementCount;
                                            if (bug != 2 && bug != 3) {
                                                console.log("Pas possible !");
                                                break;
                                            }
                                            else {
                                                bouffeur = label[o].childElementCount;
                                                console.log(bouffeur + " noix !!!!! awale2");
                                                console.log(bouffeur);
                                                for (var f = 0; f < bouffeur; f++) {
                                                    tablebouffe.appendChild(label[o].firstChild);
                                                    console.log("jai bouffe");
                                                    if (tablebouffe.childElementCount < 10) {
                                                        tablebouffe.lastChild.style.position = "absolute";
                                                        tablebouffe.lastChild.style.top = "23px";
                                                        tablebouffe.lastChild.style.left = solutiontablette + "px";
                                                        solutiontablette = solutiontablette + 15;
                                                        if (tablebouffe.childElementCount == 9) {
                                                            solutiontablette = 250;
                                                        }
                                                    }
                                                    else if (tablebouffe.childElementCount >= 10 && tablebouffe.childElementCount < 19) {
                                                        tablebouffe.lastChild.style.position = "absolute";
                                                        tablebouffe.lastChild.style.top = "38px";
                                                        tablebouffe.lastChild.style.left = solutiontablette + "px";
                                                        solutiontablette = solutiontablette + 15;
                                                        if (tablebouffe.childElementCount == 18) {
                                                            solutiontablette = 250;
                                                        }
                                                    }
                                                    else if (tablebouffe.childElementCount >= 19) {
                                                        tablebouffe.lastChild.style.position = "absolute";
                                                        tablebouffe.lastChild.style.top = "53px";
                                                        tablebouffe.lastChild.style.left = solutiontablette + "px";
                                                        solutiontablette = solutiontablette + 15;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else if (jackpot == 2) {
                                    if (trou >= 0 && trou < 6) {
                                        console.log(trou + "2");
                                        for (var o = trou; o >= 0; o--) {
                                            console.log(label[o].childElementCount);
                                            var bug = label[o].childElementCount;
                                            if (bug != 2 && bug != 3) {
                                                console.log("Pas possible !");
                                                break;
                                            }
                                            else {
                                                bouffeur = label[o].childElementCount;
                                                console.log(bouffeur);
                                                for (var f = 0; f < bouffeur; f++) {
                                                    tablebouffe.appendChild(label[o].firstChild);
                                                    console.log("jai bouffe");
                                                    if (tablebouffe.childElementCount < 10) {
                                                        tablebouffe.lastChild.style.position = "absolute";
                                                        tablebouffe.lastChild.style.top = "23px";
                                                        tablebouffe.lastChild.style.left = solutiontablette2 + "px";
                                                        solutiontablette2 = solutiontablette2 + 15;
                                                        if (tablebouffe.childElementCount == 9) {
                                                            solutiontablette2 = 250;
                                                        }
                                                    }
                                                    else if (tablebouffe.childElementCount >= 10 && tablebouffe.childElementCount < 19) {
                                                        tablebouffe.lastChild.style.position = "absolute";
                                                        tablebouffe.lastChild.style.top = "38px";
                                                        tablebouffe.lastChild.style.left = solutiontablette2 + "px";
                                                        solutiontablette2 = solutiontablette2 + 15;
                                                        if (tablebouffe.childElementCount == 18) {
                                                            solutiontablette2 = 250;
                                                        }
                                                    }
                                                    else if (tablebouffe.childElementCount >= 19) {
                                                        tablebouffe.lastChild.style.position = "absolute";
                                                        tablebouffe.lastChild.style.top = "53px";
                                                        tablebouffe.lastChild.style.left = solutiontablette2 + "px";
                                                        solutiontablette2 = solutiontablette2 + 15;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                // Mise à jour des panels de jeu (nom, score, scorebonus...)
                                $.get(url1, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data1) {
                                    panel1.textContent = data1;
                                    me1 = data1;
                                    playor1 = data1;
                                    $('input#nom1vrai').val(data1);
                                });
                                $.get(url2, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data2) {
                                    panel2.textContent = data2;
                                    me2 = data2;
                                    playor2 = data2;
                                    $('input#nom2vrai').val(data2);
                                });
                                $.get(url3, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data3) {
                                    panel1.textContent = me1 + " : " + data3 + " nuts";
                                    playorscore1 = data3;
                                    $('input#score1vrai').val(data3);
                                });
                                $.get(url4, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data4) {
                                    panel2.textContent = me2 + " : " + data4 + " nuts";
                                    playorscore2 = data4;
                                    $('input#score2vrai').val(data4);
                                });
                                $.get(url5, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data5) {
                                    panel3.textContent = "Bonus : " + data5;
                                    playorscorebonus1 = data5;
                                });
                                $.get(url6, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data6) {
                                    panel4.textContent = "Bonus : " + data6;
                                    playorscorebonus2 = data6;
                                });

                                // Gestion des tours de jeu et du champMe
                                if (trjoueur == 1) {
                                    trjoueur = 2;
                                    console2.textContent = "It's your turn !";
                                    console1.textContent = "";
                                }
                                else if (trjoueur == 2) {
                                    trjoueur = 1;
                                    console1.textContent = "It's your turn !";
                                    console2.textContent = "";
                                }
                                // Modification du champ champMe
                                if ($("#champMe").attr("value") == "0") {
                                    $("#champMe").attr("value", "1");
                                }
                                else if ($("#champMe").attr("value") == "1") {
                                    $("#champMe").attr("value", "0");
                                }

                            }, temps + tempsboucle + 200);
                        };

                        // Affiche le nb de users online dans la console
                        serveurdejeu.client.updateUsersOnlineCount = function (count) {
                            nbJoueursEnLigne = count;
                            console.log(" Il y a " + count + " nutters en ligne ! Courage Chérif !");
                        };


                        // Fonction pour stocker l'identifiant du joueur présent
                        serveurdejeu.client.stockeId = function (envoiId) {
                            $("#meId").val(envoiId);
                        };

                        // Fonction pour stocker l'identifiant du joueur présent
                        serveurdejeu.client.getInformations = function () {
                            serveurdejeu.server.sendinformationshub($("#orderGameAsk").val(), $("#codeGameAsk").val())
                        };

                        // Fonction pour retourner le nom du joueur adverse et faire les
                        // mises à jour chez l'appelant
                        serveurdejeu.client.returnNameJavascript = function (jeujoueuradversaire, tongroupeserver) {

                            // On change le champ champMe pour mettre 1 car c'est à son tour de joueur
                            $("#champMe").attr("value", "1");
                            trjoueur = 1;
                            $("#order").attr("value", "1");

                            // Peut tchatter
                            peutChatter = 1;

                            // Le jeu a commencé
                            jeucommence = 1;

                            // On met à jour les consoles car on peut joueur
                            // Messages de patientement dans les consoles
                            $("#consoleJoueur1").text("It's your turn !");
                            $("#consoleJoueur2").text("");
                            $("#consoleJoueur1").stopBlink();
                            $("#consoleJoueur2").stopBlink();

                            nomdemonjoueur = $("#prenom1").val();
                            //nomdujoueuradverse = jeujoueuradversaire;
                            nomdujoueuradverse = $("#prenom2").val();
                            monnomcool = nomdemonjoueur;
                            nomChat = playor1;
                            $("#tonGroupe").attr('value', tongroupeserver);
                            // On transmet d'abord les deux noms pour modification de la partie
                            var urlmodifpartie = "/PlayFbkFriend/modifPartie";
                            $.get(urlmodifpartie, { j1: nomdemonjoueur, j2: nomdujoueuradverse, partiename: tongroupeserver }, function () {
                                // Après exécution du code serveur, on met à jour la partie

                                //alert(nomdujoueuradverse + " VS " + nomdemonjoueur);
                                //alert($("#tonGroupe").attr('value'));

                                // On modifie les paramètres de la partie après changements
                                $.get(url1, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data1) {
                                    panel1.textContent = data1;
                                    me1 = data1;
                                    playor1 = data1;
                                    $("#first1").attr('value', data1);
                                    $('input#nom1vrai').val(data1);
                                });
                                $.get(url2, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data2) {
                                    panel2.textContent = data2;
                                    me2 = data2;
                                    playor2 = data2;
                                    $("#first2").attr('value', data2);
                                    $('input#nom2vrai').val(data2);
                                });
                                $.get(url3, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data3) {
                                    panel1.textContent = me1 + " : " + data3 + " nuts";
                                    playorscore1 = data3;
                                    $('input#score1vrai').val(data3);
                                });
                                $.get(url4, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data4) {
                                    panel2.textContent = me2 + " : " + data4 + " nuts";
                                    playorscore2 = data4;
                                    $('input#score2vrai').val(data4);
                                });
                                $.get(url5, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data5) {
                                    panel3.textContent = "Bonus : " + data5;
                                    playorscorebonus1 = data5;
                                });
                                $.get(url6, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data6) {
                                    panel4.textContent = "Bonus : " + data6;
                                    playorscorebonus2 = data6;
                                });
                            });
                        }

                        // Affiche une boîte de dialogue pour 
                        /*serveurdejeu.client.readytoplay = function () {
                            var tokenreadytoplay = jConfirm("Your opponent is ready to play", 'Ready opponent !', function (r) {
                                if (r) {
                                    // On ne fait rien
                                }
                            });
                        }*/

                        // Se déclenche quand notre fenêtre a fini de se charger
                        // Pour avertir l'autre qu'on est pret
                        /*$(window).on('load', function () {
                            serveurdejeu.server.sayoppponentready($("#tonGroupe").val());
                        });*/


                        // Fonction de fin de jeu anticipé
                        // Affiche le message de fin de jeu anticipé
                        serveurdejeu.client.finjeuanticipe = function () {
                            serveurdejeu.server.destroyHubGroupe($("#tonGroupe").val());
                            $.connection.hub.stop();
                            var reponsejeuanticipe = jConfirm("Your opponent left the game ! Replay ?", 'Awale End !', function (r) {
                                if (r) {
                                    location.href = '<%= Page.ResolveUrl("~/PlayFbk/Index") %>';
                                }
                                else {
                                    location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                }
                            });
                        }

                        // Fonction pour écrire dans le chat
                        serveurdejeu.client.addMessageChat = function (name, message) {
                            // Add the message to the page. 
                            $('#discussion').append('<li><strong>' + htmlEncode(name)
                                + '</strong>: ' + htmlEncode(message) + '</li>').emoticonize();
                            var objDiv = document.getElementById("groupeMonte");
                            objDiv.scrollTop = objDiv.scrollHeight;
                        };

                        // Fonction pour retourner le nom de l'appelant
                        // et faire les mises à jour chez le receveur
                        serveurdejeu.client.miseAjourJeuAdversaire = function (nomcaller, tongroupeserver2) {

                            // On change le champ champMe pour mettre 0
                            // car ce n'est pas son tour de jouer
                            $("#champMe").attr("value", "0");
                            trjoueur = 1;
                            $("#order").attr("value", "2");

                            // Peut tchatter
                            peutChatter = 1;

                            // Le jeu a commencé
                            jeucommence = 1;

                            // On met à jour les consoles car on peut joueur
                            // Messages de patientement dans les consoles
                            $("#consoleJoueur1").text("It's your turn !");
                            $("#consoleJoueur2").text("");
                            $("#consoleJoueur1").stopBlink();
                            $("#consoleJoueur2").stopBlink();

                            nomdemonjoueur = $("#prenom1").val();
                            //nomdujoueuradverse = nomcaller;
                            nomdujoueuradverse = $("#prenom2").val();
                            monnomcool = nomdujoueuradverse;
                            nomChat = playor2;
                            $("#tonGroupe").attr('value', tongroupeserver2);
                            // On ne recréer pas la partie, l'appelant se charge de le faire
                            /*var urlmodifpartie = "/Play/modifPartie";
                            $.get(urlmodifpartie, { j1: nomdemonjoueur, j2: nomdujoueuradverse }, function () {
                                // On ne fait rien ici, on a juste transmis les deux noms
                            });*/

                            //alert(nomdujoueuradverse + " VS " + nomdemonjoueur);
                            //alert($("#tonGroupe").attr('value'));

                            // Mise à jour des informations de jeu par ping
                            
                            var urlping = "/PlayFbkFriend/createdPartie";
                            // On détruit la variable de setInterval
                            var myVarPing = setInterval(function () {
                            $.get(urlping, { partiename: $("#codeGameAsk").val() }, function (dataping) {

                                // Si la partie a été créée par le demandeur
                                if (dataping == "OK") {
                                    // On modifie les paramètres de la partie après changements
                                    $.get(url1, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data1) {
                                        panel1.textContent = data1;
                                        me1 = data1;
                                        playor1 = data1;
                                        $("#first1").attr('value', data1);
                                        $('input#nom1vrai').val(data1);
                                    });
                                    $.get(url2, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data2) {
                                        panel2.textContent = data2;
                                        me2 = data2;
                                        playor2 = data2;
                                        $("#first2").attr('value', data2);
                                        $('input#nom2vrai').val(data2);
                                    });
                                    $.get(url3, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data3) {
                                        panel1.textContent = me1 + " : " + data3 + " nuts";
                                        playorscore1 = data3;
                                        $('input#score1vrai').val(data3);
                                    });
                                    $.get(url4, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data4) {
                                        panel2.textContent = me2 + " : " + data4 + " nuts";
                                        playorscore2 = data4;
                                        $('input#score2vrai').val(data4);
                                    });
                                    $.get(url5, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data5) {
                                        panel3.textContent = "Bonus : " + data5;
                                        playorscorebonus1 = data5;
                                    });
                                    $.get(url6, { jouant: "OK", codepartiejeu: $("#codeGameAsk").val() }, function (data6) {
                                        panel4.textContent = "Bonus : " + data6;
                                        playorscorebonus2 = data6;
                                    });
                                    // On arrête le ping
                                    clearInterval(myVarPing);
                                }
                                // Si la partie n'a pas encore été créée par le demandeur
                                else
                                {
                                    // On ne fait rien
                                }
                            });
                            }, 10000);
                        }


                        //alert($('#codeGameAsk').val());

                        // Ici, on initialise le serveur de jeu et on appelle la fonction actualiser du hub
                        // qui renvoie sur la fonction jquery jouerawale
                        // Start the connection.
                        $.connection.hub.start().done(function () {

                            // Fonction pour gérer le clic du chat
                            $('#sendmessage').click(function () {
                                if (peutChatter == 1) {
                                    if ($("#message").val()) {
                                        // Call the Send method on the hub.
                                        var senderchat;
                                        if ($('#orderGameAsk').val() == "1")
                                        {
                                            senderchat = $('#first1').val();
                                            //alert($('#first1').val());
                                        }
                                        else if ($('#orderGameAsk').val() == "2")
                                        {
                                            senderchat = $('#first2').val();
                                            //alert($('#first2').val());
                                        }
                                        serveurdejeu.server.sendChat(senderchat, $('#message').val(), $('#tonGroupe').val());
                                        // Clear text box and reset focus for next comment. 
                                        $('#message').val('').focus();
                                    }
                                }
                                else if (peutChatter == 0) {
                                    $('#message').val('No player yet ! Wait...');
                                }
                            });

                            // Fonction pour gérer la touche Entrée du chat
                            document.addEventListener('keydown', function (e) {
                                if (e.keyCode == 13 && $('#message').is(":focus")) {
                                    if (peutChatter == 1) {
                                        if ($("#message").val()) {
                                            // Call the Send method on the hub.
                                            var senderchat;
                                            if ($('#orderGameAsk').val() == "1") {
                                                senderchat = $('#first1').val();
                                            }
                                            else if ($('#orderGameAsk').val() == "2") {
                                                senderchat = $('#first2').val();
                                            }
                                            serveurdejeu.server.sendChat(senderchat, $('#message').val(), $('#tonGroupe').val());
                                            // Clear text box and reset focus for next comment. 
                                            $('#message').val('').focus();
                                        }
                                    }
                                    else if (peutChatter == 0) {
                                        $('#message').val('No player yet ! Wait...');
                                    }
                                }
                            });

                            //var identifiant = $.connection.hub.id;
                            for (var t = 0; t < label.length; t++) {
                                label[t].addEventListener("click", (function (p) {

                                    // Il y a deux cas
                                    return function () {
                                        // Si c'est à son tour de jouer
                                        if ($("#champMe").attr("value") == "1") {
                                            // Call the actualiserJeu method on the hub to play
                                            var groupeToi = $('#tonGroupe').val();
                                            serveurdejeu.server.actualiserJeu(p, groupeToi);
                                            // Gestion du clic unique
                                            switch (p) {
                                                case 0:
                                                    document.getElementById('<%=label0.ClientID%>').style.pointerEvents = "none";
                                            break;
                                        case 1:
                                            document.getElementById('<%=label1.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 2:
                                    document.getElementById('<%=label2.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 3:
                                    document.getElementById('<%=label3.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 4:
                                    document.getElementById('<%=label4.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 5:
                                    document.getElementById('<%=label5.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 6:
                                    document.getElementById('<%=label6.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 7:
                                    document.getElementById('<%=label7.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 8:
                                    document.getElementById('<%=label8.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 9:
                                    document.getElementById('<%=label9.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 10:
                                    document.getElementById('<%=label10.ClientID%>').style.pointerEvents = "none";
                                    break;
                                case 11:
                                    document.getElementById('<%=label11.ClientID%>').style.pointerEvents = "none";
                                    break;
                                default:
                                    break;
                            }
                        }
                        else if ($("#champMe").attr("value") == "0") {
                            if (trjoueur == 1) {
                                console2.textContent = "It's not your turn ! Wait...";
                            }
                            else if (trjoueur == 2) {
                                console1.textContent = "It's not your turn ! Wait...";
                            }
                        }
                                    };
                                })(t));
            }
                        });
                    });

                    function aleatoireJoueurId(min, max) {
                        return (Math.floor((max - min) * Math.random()) + min);
                    }

                    function htmlEncode(value) {
                        var encodedValue = $('<div />').text(value).html();
                        return encodedValue;
                    }

                    // Fonction pour arrêter de blinker
                    (function ($) {
                        $.fn.blink = function (options) {
                            var defaults = { delay: 500 };
                            var options = $.extend(defaults, options);

                            return this.each(function () {
                                var timerId;
                                var obj = $(this);
                                timerId = setInterval(function () {
                                    if ($(obj).css("visibility") == "visible") {
                                        $(obj).css('visibility', 'hidden');
                                    }
                                    else {
                                        $(obj).css('visibility', 'visible');
                                    }
                                }, options.delay);

                                obj.data("timerId", timerId);
                            });
                        }

                        $.fn.stopBlink = function () {
                            return this.each(function () {
                                clearInterval($(this).data("timerId"));
                            });
                        }
                    }(jQuery))
                });
//});

                </script>

       <div class="float-center">
            <div id="joueur1">
                <div id="detailsJoueur1">
                    <div id="detailsJoueur1_1"></div>
                    <div id="detailsJoueur1_2"></div>
                </div>
                <div id="tabletteGains1"></div>
                <div id="consoleJoueur1"></div>
            </div>

           <div id="awale2cool">
         <div id="awale">
             <asp:Label id="label0" CssClass="label0" runat="server" style="position : absolute;float:left;left: 558px;top : 27px;width : 70px;height : 70px;cursor: url('../Images/squirrel.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label1" CssClass="label1" runat="server" style="position : absolute;float:left;left: 452px;top : 27px;width : 70px;height : 70px;cursor: url('../Images/squirrel.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label2" CssClass="label2" runat="server" style="position : absolute;float:left;left: 346px;top : 27px;width : 70px;height : 70px;cursor: url('../Images/squirrel.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label3" CssClass="label3" runat="server" style="position : absolute;float:left;left: 237px;top : 27px;width : 70px;height : 70px;cursor: url('../Images/squirrel.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label4" CssClass="label4" runat="server" style="position : absolute;float:left;left: 132px;top : 27px;width : 70px;height : 70px;cursor: url('../Images/squirrel.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label5" CssClass="label5" runat="server" style="position : absolute;float:left;left: 25px;top : 27px;width : 70px;height : 70px;cursor: url('../Images/squirrel.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label6" CssClass="label6" runat="server" style="position : absolute;float:left;left: 25px;top : 126px;width : 70px;height : 70px;cursor: url('../Images/squirrel2.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label7" CssClass="label7" runat="server" style="position : absolute;float:left;left: 132px;top : 126px;width : 70px;height : 70px;cursor: url('../Images/squirrel2.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label8" CssClass="label8" runat="server" style="position : absolute;float:left;left: 237px;top : 126px;width : 70px;height : 70px;cursor: url('../Images/squirrel2.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label9" CssClass="label9" runat="server" style="position : absolute;float:left;left: 346px;top : 126px;width : 70px;height : 70px;cursor: url('../Images/squirrel2.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label10" CssClass="label10" runat="server" style="position : absolute;float:left;left: 452px;top : 126px;width : 70px;height : 70px;cursor: url('../Images/squirrel2.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             <asp:Label id="label11" CssClass="label11" runat="server" style="position : absolute;float:left;left: 558px;top : 126px;width : 70px;height : 70px;cursor: url('../Images/squirrel2.png'), default;">
                  <asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:20px;left:40px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:20px;"/><asp:Image CssClass="boule" ImageUrl="~/Images/boule1.png" runat="server" style="position:absolute;top:40px;left:40px;"/>
             </asp:Label>
             
         </div>
           <div id="consoleChat">
               <h2>Chat</h2>
                    <div class="containerChat">
                        <div id="groupeMonte">
                        <ul id="discussion">
                        </ul>
                            </div>
                        <div id="groupeDescend">
                            <input type="text" id="message" autocomplete="off" />
                            <input type="button" id="sendmessage" value="Send" />
                            <input type="hidden" id="displayname" />
                        </div>
                    </div>
           </div>

           </div>

         <div id="joueur2">
                <div id="consoleJoueur2"></div>
                <div id="tabletteGains2"></div>
                <div id="detailsJoueur2">
                    <div id="detailsJoueur2_1"></div>
                    <div id="detailsJoueur2_2"></div>
                </div>
         </div>
    </div>
        <br />
    <img id="langueimage" src="../../Images/drapfrance.jpg" style="margin : auto; text-align : center"/>
    <div id="rules2" style="color : white;font-family : Rockwell, Consolas, Courier, monospace;font-size : 15px;font-weight : bold;font-style : italic;">Collect nuts in a hole of your side and distribute them in the opposite direction of clockwise, one nut per hole, skipping the starting hole. You win two-nuts or three-nuts continuous holes at the end of your turn.</div>
    <input type="hidden" id="champMe" class="champMe" name="champMe" value="0">
    <input type="hidden" id="meId" class="meId" name="meId" value="">
    <input type="hidden" id="idFacebook" class="idFacebook" name="idFacebook" value="">
    <input type="hidden" id="tonGroupe" class="tonGroupe" name="tonGroupe" value="">
    <input type="hidden" id="order" class="order" name="order" value="">
    <input type="hidden" id="orderGameAsk" class="orderGameAsk" name="orderGameAsk" value="<%: ViewBag.ordrejeu %>">
    <input type="hidden" id="codeGameAsk" class="codeGameAsk" name="codeGameAsk" value="<%: ViewBag.codejeu %>">
    <input type="hidden" id="prenom1" class="prenom1" name="prenom1" value="<%: ViewBag.prenom1 %>">
    <input type="hidden" id="prenom2" class="prenom2" name="prenom2" value="<%: ViewBag.prenom2 %>">
    <input type="hidden" id="first1" class="first1" name="first1" value="">
    <input type="hidden" id="first2" class="first2" name="first2" value="">
    <input type="hidden" id="score1vrai" class="score1vrai" name="score1vrai" value="0">
    <input type="hidden" id="score2vrai" class="score2vrai" name="score2vrai" value="0">
    <input type="hidden" id="nom1vrai" class="nom1vrai" name="nom1vrai" value="0">
    <input type="hidden" id="nom2vrai" class="nom2vrai" name="nom2vrai" value="0">
   </div>
        <div class="boutons3">
            <!--<a class="boutondisparait" href="<%= Url.Action("Index", "Play2", new { levelniveau = 1, topalealevel = 10, agitation = 1000 }) %>"><img alt="Play2" class="bonneimage" src="../../Images/button_play_2.png" /></a>
            <% if (Convert.ToString(ViewData["ici"]) == "site") {
                        %>
                    <a class="boutondisparait" href="<%= Url.Action("Manage", "Account") %>"><img alt="Buy1" class="bonneimage" src="../../Images/buynuts.png" /></a>
    <% } else if(Convert.ToString(ViewData["ici"]) == "facebook") { %>
            <a class="boutondisparait" href="<%= Url.Action("Manage", "FacebookNutter", new { identifiant = ViewBag.idfbk })%>"><img class="bonneimage2" title="Buy nuts with facebook !" src="<%= Url.Content("../../Images/buynuts.png") %>" /></a>
        <% } %>    -->    </div>
    </div>
</asp:Content>