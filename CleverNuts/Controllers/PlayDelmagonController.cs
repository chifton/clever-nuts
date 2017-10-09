using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class PlayDelmagonController : ApplicationRealController
    {
        //
        // GET: /PlayDelmagon/
        // Pour créer lors du start de l'application sur le web
        // la liste de toutes les parties qui seront jouées
        // Liste de parties du jeu
        private static List<CreatePartie> PartiesCln = new List<CreatePartie>();
        private static List<string> PartiesNames = new List<string>();
        static CreatePartie partie;

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


        bool enregistre = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;

        public ActionResult Index(string joueurdelmagon)
        {

            string valeurglobale;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
            }

            ViewBag.joueurdelmagon = joueurdelmagon;
            partie = new CreatePartie(joueurdelmagon, "Delmagon");
            return View();
        }

        // On modifie la partie après récupération des adversaires
        public void modifPartie(string partiename)
        {
            // On ajoute la partie et son identifiant aux listes statiques de parties et d'ids
            PartiesCln.Add(partie);
            PartiesNames.Add(partiename);
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

        public string getNutterUser()
        {
            return System.Web.HttpContext.Current.User.Identity.Name;
        }

        public string Sequence(string possible, string nompartie)
        {
            //answer = ;
            if (PartiesCln.ElementAt(PartiesNames.IndexOf(nompartie)).SequenceJeu(possible))
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

        public string bonArgument(string nompartie)
        {
            return PartiesCln.ElementAt(PartiesNames.IndexOf(nompartie)).FindArgument();
        }


               public string score1(string jouant, string nompartie)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur1score = PartiesCln.ElementAt(PartiesNames.IndexOf(nompartie)).player1.score.ToString();
                return joueur1score;
            }
        }
               public string score2(string jouant, string nompartie)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur2score = PartiesCln.ElementAt(PartiesNames.IndexOf(nompartie)).player2.score.ToString();
                return joueur2score;
            }
        }

               public string scorebonus1(string jouant, string nompartie)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur1scorebonus = PartiesCln.ElementAt(PartiesNames.IndexOf(nompartie)).player1.scorebonus.ToString();
                return joueur1scorebonus;
            }
        }
               public string scorebonus2(string jouant, string nompartie)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur2scorebonus = PartiesCln.ElementAt(PartiesNames.IndexOf(nompartie)).player2.scorebonus.ToString();
                return joueur2scorebonus;
            }
        }

        public string EndGame(string idPartieOrdi, string position, int score1fin, int score2fin)
        {
            /*// Les scores sont là, il ne reste qu'à les mettre dans les VRAIS profils
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player1.score = score1fin;
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player2.score = score2fin;
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player1.scorebonus = score1fin * 100;
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player2.scorebonus = score2fin * 100;
            */
            string valeurglobale;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
                if (!string.IsNullOrEmpty(valeurglobale))
                {
                    // Si c'est un nutter facebook, on stocke les scores dans le modèle
                    AWLFacebookContext db = new AWLFacebookContext();
                    AWLFacebookProfile user = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeurglobale));
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
                        int positionmoi = PartiesNames.IndexOf(idPartieOrdi);
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
                }
            }
            else
            {
                if (enregistre)
                {
                    // Si c'est un nutter user, on stocke les scores dans le modèle du user courant
                    UsersContext db = new UsersContext();
                    UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(User.Identity.Name));
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
                        int positionmoi = PartiesNames.IndexOf(idPartieOrdi);
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
                }
                else
                {
                    // Création des variables de session pour les nutters anonymes et stockage des scores
                    if (position == "1")
                    {
                        if (System.Web.HttpContext.Current.Session["nutterAnonymous"] != null)
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = (int)System.Web.HttpContext.Current.Session["nutterAnonymous"] + score1fin;
                        }
                        else
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = score1fin;
                        }
                        // Destruction de la partie par l'initiateur seul de la partie
                        int positionmoi = PartiesNames.IndexOf(idPartieOrdi);
                        PartiesCln.RemoveAt(positionmoi);
                        PartiesNames.RemoveAt(positionmoi);
                    }
                    else if (position == "2")
                    {
                        if (System.Web.HttpContext.Current.Session["nutterAnonymous"] != null)
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = (int)System.Web.HttpContext.Current.Session["nutterAnonymous"] + score2fin;
                        }
                        else
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = score2fin;
                        }
                    }
                }
            }
            //System.Web.HttpContext.Current.User.Identity.Name
            return "Fin du jeu !";
        }
    }
}