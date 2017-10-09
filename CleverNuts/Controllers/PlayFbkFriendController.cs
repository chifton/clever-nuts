using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class PlayFbkFriendController : ApplicationRealController
    {
        // Pour créer lors du start de l'application sur le web
        // la liste de toutes les parties qui seront jouées
        // Liste de parties du jeu
        private static List<CreatePartie> PartiesCln = new List<CreatePartie>();
        private static List<string> PartiesNames = new List<string>();


        bool enregistre = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
        static CreatePartie partie = new CreatePartie("Anonymous1", "Anonymous2");


        bool answer;
        string joueur1nom;
        string joueur2nom;
        string joueur1score;
        string joueur2score;
        string joueur1scorebonus;
        string joueur2scorebonus;
        int nombreEnligne;
        int adversaireId;
        List<string> loggedInUsers;
        string adversaire;

        // Pour stocker l'identifiant de la partie en cours
        static string idPartieHub = "";

        //
        // GET: /PlayFbkFriend/

        public ActionResult Index(int ordredemandejeugame, string codejeuadeux, string prenom1, string prenom2)
        {
            string valeurglobale = string.Empty;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
            }

            ViewBag.ordrejeu = ordredemandejeugame;
            ViewBag.codejeu = codejeuadeux;
            ViewBag.prenom1 = prenom1;
            ViewBag.prenom2 = prenom2;
            return View();
        }

        public ActionResult Index2(string ordredemandejeugamecodejeuadeux)
        {
            try
            {
                AWLTokensContext contexteTokensJeux = new AWLTokensContext();
                string moncode = ordredemandejeugamecodejeuadeux.Substring(1, ordredemandejeugamecodejeuadeux.Length - 1);
                // On redirige vers la page d'accueil si la partie a déjà été jouée

                if (contexteTokensJeux.TokenGamesDuo.Any(u => u.Token.Equals(moncode)))
                {
                    return RedirectToAction("Index", "Home");
                }
                else // Sinon on joue
                {
                    AWLTokens tokenDeCeJeu = new AWLTokens();
                    tokenDeCeJeu.Token = moncode;
                    contexteTokensJeux.TokenGamesDuo.Add(tokenDeCeJeu);
                    contexteTokensJeux.SaveChanges();

                    string valeurglobale = string.Empty;
                    if (System.Web.HttpContext.Current.Session["idfbk"] != null)
                    {
                        valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                        ViewBag.idfbk = valeurglobale;
                    }

                    ViewBag.ordrejeu = ordredemandejeugamecodejeuadeux.Substring(0, 1);
                    ViewBag.codejeu = ordredemandejeugamecodejeuadeux.Substring(1, ordredemandejeugamecodejeuadeux.Length - 1);
                    ViewBag.prenom1 = string.Empty;
                    ViewBag.prenom2 = string.Empty;
                    return View("Index");
                }
            }
            catch(Exception exc)
            {
                //return RedirectToAction("Index", "Home");
                return RedirectToAction("About", "Home", new { erreur = exc.ToString() });
            }
        }

        // On modifie la partie après récupération des adversaires
        public void modifPartie(string j1, string j2, string partiename)
        {
            // On crée la bonne finale partie
            CreatePartie newpartie = new CreatePartie(j1, j2);
            // On stocke l'identifiant hub de la partie
            //idPartieHub = partiename;
            // On ajoute la partie et son identifiant aux listes statiques de parties et d'ids
            PartiesCln.Add(newpartie);
            PartiesNames.Add(partiename);
        }

        // On vérifie que la partie existe déjà pour le deuxième joueur
        public string createdPartie(string partiename)
        {
            bool existeDeja = PartiesNames.Any(o => o.Equals(partiename));
            if(existeDeja)
            {
                return "OK";
            }
            else
            {
                return "KO";
            }
        }

        public string getNutterUser()
        {
            return System.Web.HttpContext.Current.User.Identity.Name;
        }

        public string Sequence(string possible, string codepartiejeu)
        {
            //answer = ;
            if (PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).SequenceJeu(possible))
            {
                return "OK";
            }
            else
            {
                return "KO";
            }

            // Mettre le code à appeler à chaque fois
            // avec des paramètres peut être
        }

        public string nom1(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "Anonymous1";
            }
            else
            {
                joueur1nom = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player1.pseudo;
                return joueur1nom;
            }
        }
        public string nom2(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "Anonymous2";
            }
            else
            {
                joueur2nom = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player2.pseudo;
                return joueur2nom;
            }
        }

        public string score1(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur1score = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player1.score.ToString();
                return joueur1score;
            }
        }
        public string score2(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur2score = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player2.score.ToString();
                return joueur2score;
            }
        }

        public string scorebonus1(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur1scorebonus = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player1.scorebonus.ToString();
                return joueur1scorebonus;
            }
        }
        public string scorebonus2(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur2scorebonus = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player2.scorebonus.ToString();
                return joueur2scorebonus;
            }
        }

        public string bonArgument(string codepartiejeu)
        {
            return PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).FindArgument();
        }

        public string checkUserOrAnonymous()
        {
            bool enregistre2 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
            if (!enregistre2)
            {
                return "anonym";
            }
            else
            {
                return "user";
            }
        }

        public string EndGame(string idMoi, string idPartieJeu, string position, int score1fin, int score2fin)
        {
                // Si c'est un facebook user, on stocke les scores dans le modèle facebook
                string valeuridfacebook = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeuridfacebook;
                AWLFacebookContext db = new AWLFacebookContext();
                AWLFacebookProfile user = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeuridfacebook));
                if (position == "1")
                {
                    user.UserNuts1 = user.UserNuts1 + score1fin;
                    user.UserBonus = user.UserBonus + score1fin * 10;
                    // Mise à jour des noix d'or, de bronze et simples
                    while (user.UserNuts1 > 30)
                    {
                        int restesimple = user.UserNuts1 - 30;
                        user.UserNuts2 = user.UserNuts2 + 1;
                        user.UserNuts1 = restesimple;
                    }
                    while (user.UserNuts2 > 10)
                    {
                        int restesimple2 = user.UserNuts2 - 10;
                        user.UserNuts3 = user.UserNuts3 + 1;
                        user.UserNuts2 = restesimple2;
                    }
                    db.SaveChanges();
                    // Destruction de la partie par l'initiateur seul de la partie
                    int positionmoi = PartiesNames.IndexOf(idPartieJeu);
                    PartiesCln.RemoveAt(positionmoi);
                    PartiesNames.RemoveAt(positionmoi);
                }
                else if (position == "2")
                {
                    user.UserNuts1 = user.UserNuts1 + score2fin;
                    user.UserBonus = user.UserBonus + score2fin * 10;
                    // Mise à jour des noix d'or, de bronze et simples
                    while (user.UserNuts1 > 30)
                    {
                        int restesimple = user.UserNuts1 - 30;
                        user.UserNuts2 = user.UserNuts2 + 1;
                        user.UserNuts1 = restesimple;
                    }
                    while (user.UserNuts2 > 10)
                    {
                        int restesimple2 = user.UserNuts2 - 10;
                        user.UserNuts3 = user.UserNuts3 + 1;
                        user.UserNuts2 = restesimple2;
                    }
                    db.SaveChanges();
                }

            //System.Web.HttpContext.Current.User.Identity.Name
            return "Fin du jeu !";
        }

        private int RandomNumber(int min, int max)
        {
            Random random = new Random();
            return random.Next(min, max);
        }

        public int getmysession(string monid)
        {
            int resultatnoix = (int)System.Web.HttpContext.Current.Session[monid];
            return resultatnoix;
        }
    }
}