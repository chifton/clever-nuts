using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class SuccessPaiementFbkController : ApplicationRealController
    {
        //
        // GET: /SuccessPaiementFbk/

        public ActionResult Index(string identifiant, string montant, string devise, string itemnumber, string idnutter)
        {
            AWLFacture achat = new AWLFacture(); // this is something I have defined in order to save the order in the database            

                //validate the order
                string dateNumber = DateTime.Now.ToString();
                Decimal amountPaid = 0;
                Decimal.TryParse(montant, System.Globalization.NumberStyles.Number, System.Globalization.CultureInfo.InvariantCulture, out amountPaid);

                AWLFacturesContext contextFactures = new AWLFacturesContext();
                List<AWLFacture> tableFactures = contextFactures.FacturesTable.ToList();

                if (tableFactures.Count(d => d.IdPaiement == identifiant) < 1)
                {
                    //if the transactionID is not found in the database, add it
                    //then, add the additional features to the user account
                    AWLFacebookContext db = new AWLFacebookContext();
                    AWLFacebookProfile userBuyer = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(idnutter));

            
                    // Mise à jour des paramètres d'achat
                    achat.IdPaiement = identifiant;
                    achat.Buyer = userBuyer.UserName + "/" + idnutter;
                    string nomitem;
                    if(itemnumber == "1")
                    {
                        achat.Article = "Simple Nuts";
                    }
                    else if(itemnumber == "2")
                    {
                        achat.Article = "Bronze Nuts";
                    }
                    else if(itemnumber == "3")
                    {
                        achat.Article = "Gold Nuts";
                    }
                    else if(itemnumber == "4")
                    {
                        achat.Article = "Package Nuts";
                    }
                    
                    nomitem = achat.Article;
                    achat.Montant = amountPaid;
                    achat.Plateforme = dateNumber + " - with FACEBK";

                    // On ajoute l'entrée dans la table Factures et on sauve la base de données
                    contextFactures.FacturesTable.Add(achat);
                    contextFactures.SaveChanges();

                    // Génération du PDF et des emails

                    // Ajout des noix dans le compte du nutter
                    if (itemnumber == "1")
                    {
                        userBuyer.UserNuts1 = userBuyer.UserNuts1 + 30;
                    }
                    else if (itemnumber == "2")
                    {
                        userBuyer.UserNuts2 = userBuyer.UserNuts2 + 30;
                    }
                    else if (itemnumber == "3")
                    {
                        userBuyer.UserNuts3 = userBuyer.UserNuts3 + 30;
                    }
                    else if (itemnumber == "4")
                    {
                        userBuyer.UserNuts1 = userBuyer.UserNuts1 + 30;
                        userBuyer.UserNuts2 = userBuyer.UserNuts2 + 30;
                        userBuyer.UserNuts3 = userBuyer.UserNuts3 + 30;
                    }
                    db.SaveChanges();

                    // Mise à jour dans le panel d'en haut à droite
                    ViewData["noix1"] = userBuyer.UserNuts1;
                    ViewData["noix2"] = userBuyer.UserNuts2;
                    ViewData["noix3"] = userBuyer.UserNuts3;

                    // Pour la fenetre de confirmation et de succès
                    ViewBag.nomitem = nomitem;
                    ViewBag.identifiantcool = identifiant;
                    ViewBag.montantcool = montant;
                    ViewBag.devisecool = devise;

                    return View();
            }
            else
            {
                //error
                return View("ErrorBuy");
            }

        }

        public ActionResult ErrorBuy()
        {
            return View("ErrorBuy");
        }

    }
}
