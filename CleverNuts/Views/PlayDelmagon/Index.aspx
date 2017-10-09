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
            <script type="text/javascript">


                document.addEventListener("DOMContentLoaded", function () {

                    // Récupération de tous les contrôles de la view
                    var redirectSiPasDeJoueurs;
                    var continueoupas;
                    var receveurContinueCherche;
                    var nbJoueursEnLigne;
                    var serveurdejeu;
                    var peutChatter = 0;
                    var nomdemonjoueur = $("#joueurcooldel").val();
                    var nomdujoueuradverse = "Delmagon";
                    // Pour la bouffe dans les tablettes
                    var solutiontablette = 250;
                    var solutiontablette2 = 250;
                    var tablette = document.querySelector("#awale");
                    var label = new Array(12);
                    var trjoueur = 1;
                    for (var t = 0; t < label.length; t++) {
                        label[t] = document.querySelector(".label" + t);
                    }


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

                    // Gestion du résumé des règles
                    var regleimage = document.querySelector("#langueimage");
                    regleimage.addEventListener("click", function () {
                        if ($("#langueimage").attr("src") == "../../Images/drapfrance.jpg") {
                            $("#langueimage").attr("src", "../../Images/drapanglais.jpg");
                            $("#rules2").text("Collectez les noix d'un trou et distribuez-les dans le sens opposé aux aiguilles d'une montre, en sautant le trou de départ. Vous gagnez les noix des trous s'ils ont deux ou trois noix à la fin de votre tour.");
                        }
                        else if ($("#langueimage").attr("src") == "../../Images/drapanglais.jpg")
                        {
                            $("#langueimage").attr("src", "../../Images/drapfrance.jpg");
                            $("#rules2").text("Collect nuts in a hole of your side and distribute them in the opposite direction of clockwise, one nut per hole, skipping the starting hole. You win two-nuts or three-nuts continuous holes at the end of your turn.");
                        }
                    });

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


                    // Initialisation des noms, des scores et des consoles
                    var sommeawale = 0;
                    var sommeawale1 = 0;
                    var sommeawale2 = 0;
                    var genereDelmagon;
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
                    var url1 = "/PlayDelmagon/nom1";
                    var url2 = "/PlayDelmagon/nom2";
                    var url3 = "/PlayDelmagon/score1";
                    var url4 = "/PlayDelmagon/score2";
                    var url5 = "/PlayDelmagon/scorebonus1";
                    var url6 = "/PlayDelmagon/scorebonus2";
                    console1.textContent = "It's your turn !";
                    //$.get(url1, { jouant: "KO" }, function (data1) {
                        panel1.textContent = nomdemonjoueur;
                        me1 = nomdemonjoueur;
                        playor1 = nomdemonjoueur;
                        $('input#nom1vrai').val(nomdemonjoueur);
                    //});
                    //$.get(url2, { jouant: "KO" }, function (data2) {
                        panel2.textContent = nomdujoueuradverse;
                        me2 = nomdujoueuradverse;
                        playor2 = nomdujoueuradverse;
                        $('input#nom2vrai').val("Delmagon");
                    //});
                    //$.get(url3, { jouant: "KO" }, function (data3) {
                        panel1.textContent = me1 + " : 0 nuts";
                        playorscore1 = "0";
                    //});
                    //$.get(url4, { jouant: "KO" }, function (data4) {
                        panel2.textContent = me2 + " : 0 nuts";
                        playorscore2 = "0";
                    //});
                    //$.get(url5, { jouant: "KO" }, function (data5) {
                        panel3.textContent = "Bonus : 0";
                        playorscorebonus1 = "0";
                    //});
                    //$.get(url6, { jouant: "KO" }, function (data6) {
                        panel4.textContent = "Bonus : 0";
                        playorscorebonus2 = "0";
                    //});

                    // Génération d'id unique pour la partie
                        var urlmodifpartie = "/PlayDelmagon/modifPartie";
                        var nompartie = partieJeuNom();
                        $("#partieNameOrdi").attr("value", nompartie);
                        $.get(urlmodifpartie, { partiename: nompartie }, function () {
                            // Après exécution du code serveur, on met à jour la partie
                        });

                    // C'est au joueur de jouer la première fois avant l'ordinateur
                        $("#champMe").attr("value", "1");

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
                        var playorscore2end;
                        //var url1end = "/Play/nom1";
                        //var url2end = "/Play/nom2";
                        var url3end = "/PlayDelmagon/score1";
                        var url4end = "/PlayDelmagon/score2";
                        //$.get(url1end, { jouant: "OK", codepartiejeu: $("#tonGroupe").val() }, function (data1) {
                            playor1end = $("#joueurcooldel").val();
                        //});
                        //$.get(url2end, { jouant: "OK", codepartiejeu: $("#tonGroupe").val() }, function (data2) {
                            playor2end = "Delmagon";
                        //});
                            $.get(url3end, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data3) {
                            playorscore1end = data3;
                        });
                            $.get(url4end, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data4) {
                            playorscore2end = data4;
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
                            var urlend = "/PlayDelmagon/EndGame";
                            $.get(urlend, { idPartieOrdi: $("#partieNameOrdi").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                console.log("Oyé");
                            });

                            clearInterval(myVar);

                            // Confirmation ou non de continuation de jeu
                            var reponsejeu = jConfirm(gagneur + " won ! Play again ?", 'Awale End !', function (r) {
                                if (r) {
                                    location.href = '<%= Page.ResolveUrl("~/Play/Index") %>';
                                }
                                else {
                                    location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                }
                            });
                            console1.textContent = "";
                            console2.textContent = "";
                        }
                        else if (parseInt($('input#score1vrai').val()) > 24 || parseInt($('input#score2vrai').val()) > 24 || sommeawale <= 6) {
                            console.log($('input#score1vrai').val() + " VS " + $('input#score2vrai').val());
                            jAlert("End of game, you share the rest !", "No nuch nuts !", function (r2) {
                                if (r2) {
                                    if (parseInt($('input#score1vrai').val()) > parseInt($('input#score2vrai').val())) {
                                        var scorefinal1 = parseInt($('input#score1vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        var scorefinal2 = parseInt($('input#score2vrai').val()) + Math.ceil(parseInt(sommeawale / 2));
                                        console.log(scorefinal1 + " VS " + scorefinal2);
                                        var gagneur = $('input#nom1vrai').val();
                                        // Envoi des deux scores au controlleur
                                        var urlend = "/PlayDelmagon/EndGame";
                                        $.get(urlend, { idPartieOrdi: $("#partieNameOrdi").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                            console.log("Oyé");
                                            // ICI
                                            /*var urlsessionGet = "/Play/getmysession";
                                            $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                                alert("Session N°" + datasessioncool);
                                            });*/
                                        });

                                        clearInterval(myVar);

                                        // Confirmation ou non de continuation de jeu
                                        var reponsejeu = jConfirm($('input#nom1vrai').val() + " won ! Play again ?", 'Awale End !', function (r) {
                                            if (r) {
                                                location.href = '<%= Page.ResolveUrl("~/Play/Index") %>';
                                            }
                                            else {
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
                                        console.log(scorefinal1 + " VS " + scorefinal2);
                                        var gagneur = $('input#nom2vrai').val();
                                        // Envoi des deux scores au controlleur
                                        var urlend = "/PlayDelmagon/EndGame";
                                        $.get(urlend, { idPartieOrdi: $("#partieNameOrdi").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                            console.log("Oyé");
                                            // ICI
                                            /*var urlsessionGet = "/Play/getmysession";
                                            $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                                alert("Session N°" + datasessioncool);
                                            });*/
                                        });

                                        clearInterval(myVar);

                                        // Confirmation ou non de continuation de jeu
                                        var reponsejeu = jConfirm($('input#nom2vrai').val() + " won ! Play again ?", 'Awale End !', function (r) {
                                            if (r) {
                                                location.href = '<%= Page.ResolveUrl("~/Play/Index") %>';
                                            }
                                            else {
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
                                        console.log(scorefinal1 + " VS " + scorefinal2);
                                        var gagneur = $('input#nom1vrai').val() + " and " + $('input#nom2vrai').val();
                                        // Envoi des deux scores au controlleur
                                        var urlend = "/PlayDelmagon/EndGame";
                                        $.get(urlend, { idPartieOrdi: $("#partieNameOrdi").val(), position: $("#order").val(), score1fin: scorefinal1, score2fin: scorefinal2 }, function (datareturnend) {
                                            console.log("Oyé");
                                            // ICI
                                            /*var urlsessionGet = "/Play/getmysession";
                                            $.get(urlsessionGet, { monid: $("#meId").val() }, function (datasessioncool) {
                                                alert("Session N°" + datasessioncool);
                                            });*/
                                        });

                                        clearInterval(myVar);

                                        // Confirmation ou non de continuation de jeu
                                        var reponsejeu = jConfirm($('input#nom1vrai').val() + " and " + $('input#nom2vrai').val() + " are in equality ! Play again ?", 'Awale End !', function (r) {
                                            if (r) {
                                                location.href = '<%= Page.ResolveUrl("~/Play/Index") %>';
                                            }
                                            else {
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
                        $("#awale3cool").append(explosion);
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


                    function jouerawale(p) {

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
                                var url = "/PlayDelmagon/Sequence";
                                var lettre = retourneLettre(p);
                                $.get(url, { possible: lettre, nompartie: $("#partieNameOrdi").val() }, function (data) {

                                    // FAIRE le déplacement en fonction de la condition d'en bas
                                    if (data == "OK") {

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
                                        tablebouffe = document.querySelector("#tabletteGains" + trjoueur);
                                        setTimeout(function () {
                                            if (trjoueur == 1) {
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
                                            else if (trjoueur == 2) {
                                                if (trou >= 0 && trou < 6) {
                                                    console.log(trou + "2");
                                                    for (var o = trou; o >= 0; o--) {
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
                                            $.get(url3, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data3) {
                                                panel1.textContent = me1 + " : " + data3 + " nuts";
                                                playorscore1 = data3;
                                                $('input#score1vrai').val(data3);
                                            });
                                            $.get(url4, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data4) {
                                                panel2.textContent = me2 + " : " + data4 + " nuts";
                                                playorscore2 = data4;
                                                $('input#score2vrai').val(data4);
                                            });
                                            $.get(url5, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data5) {
                                                panel3.textContent = "Bonus : " + data5;
                                                playorscorebonus1 = data5;
                                            });
                                            $.get(url6, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data6) {
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

                                            // On génère un nouveau p pour le jeu de l'ordinateur
                                            genereDelmagon = aleatoireJoueurId2(6, 11);
                                            while (label[genereDelmagon].childElementCount == 0)
                                            {
                                                genereDelmagon = aleatoireJoueurId2(6, 11);
                                            }
                                            // On lance le jeu de l'ordinateur Delmagon
                                            var lanceJeuDelmagon = setTimeout(function () {
                                                jouerawale2(genereDelmagon);
                                            }, 3000);

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
                                        }, temps + tempsboucle + 200);

                                    } // Fin du OK du jeu ici : retour serveur positif

                                        // S'il y a des couacs pour le retour serveur controlleur, on les gère
                                    else if (data == "KO") {
                                        var url10 = "/PlayDelmagon/bonArgument";
                                        $.get(url10, { nompartie: $("#partieNameOrdi").val() }, function (data10) {
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

                    function jouerawale2(p) {

                            // Si la fonction ajax retourne un ok c'est possible de joueur, on joue
                            // Interroger le controlleur et le serveur ici
                            var url = "/PlayDelmagon/Sequence";
                            var lettre = retourneLettre(p);
                            $.get(url, { possible: lettre, nompartie: $("#partieNameOrdi").val() }, function (data) {

                                // FAIRE le déplacement en fonction de la condition d'en bas
                                if (data == "OK") {

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
                                    tablebouffe = document.querySelector("#tabletteGains" + trjoueur);
                                    setTimeout(function () {
                                        if (trjoueur == 1) {
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
                                        else if (trjoueur == 2) {
                                            if (trou >= 0 && trou < 6) {
                                                console.log(trou + "2");
                                                for (var o = trou; o >= 0; o--) {
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
                                        $.get(url3, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data3) {
                                            panel1.textContent = me1 + " : " + data3 + " nuts";
                                            playorscore1 = data3;
                                            $('input#score1vrai').val(data3);
                                        });
                                        $.get(url4, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data4) {
                                            panel2.textContent = me2 + " : " + data4 + " nuts";
                                            playorscore2 = data4;
                                            $('input#score2vrai').val(data4);
                                        });
                                        $.get(url5, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data5) {
                                            panel3.textContent = "Bonus : " + data5;
                                            playorscorebonus1 = data5;
                                        });
                                        $.get(url6, { jouant: "OK", nompartie: $("#partieNameOrdi").val() }, function (data6) {
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

                                } // Fin du OK du jeu ici : retour serveur positif

                                    // S'il y a des couacs pour le retour serveur controlleur, on les gère
                                else if (data == "KO") {
                                    var url10 = "/PlayDelmagon/bonArgument";
                                    $.get(url10, { nompartie: $("#partieNameOrdi").val() }, function (data10) {
                                        if (data10 = "Pas de noix dans la case choisie !") {
                                            if (trjoueur == 1) {
                                                console1.textContent = data10;
                                            }
                                            else if (trjoueur == 2) {
                                                console2.textContent = data10;
                                            }
                                        }
                                    });
                                }
                            });
                    };

                    // Gérer les clics de jeu
                    for (var t = 0; t < label.length; t++) {
                        label[t].addEventListener("click", (function(p) {

                            // Il y a deux cas
                            return function () {
                                // Si c'est à son tour de jouer
                                if ($("#champMe").attr("value") == "1") {
                                    jouerawale(p);
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

                    function aleatoireJoueurId(min, max) {
                        return (Math.floor((max - min) * Math.random()) + min);
                    }

                    function aleatoireJoueurId2(min, max) {
                        return (Math.floor((max - min + 1) * Math.random()) + min);
                    }

                    function htmlEncode(value) {
                        var encodedValue = $('<div />').text(value).html();
                        return encodedValue;
                    }

                    function partieJeuNom() {
                        return '_' + Math.random().toString(36).substr(2, 9);
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

         <div id="awale3cool">
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
    <input type="hidden" id="champMe" class="champMe" name="champMe" value="">
    <input type="hidden" id="order" class="order" name="order" value="1">
    <input type="hidden" id="joueurcooldel" class="joueurcooldel" name="joueurcooldel" value="<%=  ViewBag.joueurdelmagon %>">
    <input type="hidden" id="partieNameOrdi" class="partieNameOrdi" name="partieNameOrdi" value="">
    <input type="hidden" id="score1vrai" class="score1vrai" name="score1vrai" value="0">
    <input type="hidden" id="score2vrai" class="score2vrai" name="score2vrai" value="0">
    <input type="hidden" id="nom1vrai" class="nom1vrai" name="nom1vrai" value="0">
    <input type="hidden" id="nom2vrai" class="nom2vrai" name="nom2vrai" value="0"><div>
    <div class="boutons3">
            <!--<a class="boutondisparait" href="<%= Url.Action("Index", "Play2", new { levelniveau = 1, topalealevel = 10, agitation = 1000 }) %>"><img alt="Play2" class="bonneimage" src="../../Images/button_play_2.png" /></a>
            <% if (Convert.ToString(ViewData["ici"]) == "site") {
                        %>
                    <a class="boutondisparait" href="<%= Url.Action("Manage", "Account") %>"><img alt="Buy1" class="bonneimage" src="../../Images/buynuts.png" /></a>
    <% } else if(Convert.ToString(ViewData["ici"]) == "facebook") { %>
            <a class="boutondisparait" href="<%= Url.Action("Manage", "FacebookNutter", new { identifiant = ViewBag.idfbk })%>"><img class="bonneimage2" title="Buy nuts with facebook !" src="<%= Url.Content("../../Images/buynuts.png") %>" /></a>
        <% } %>  -->      </div>
    </div>
</asp:Content>