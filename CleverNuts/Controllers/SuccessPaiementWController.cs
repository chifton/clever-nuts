using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Xml;

namespace CleverNuts.Controllers
{
    public class SuccessPaiementControllerW : ApplicationRealController
    {
        bool enregistre3 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
        //
        // GET: /SuccessPaiement/

        public ActionResult Index()
        {
            StreamReader reader = new StreamReader(HttpContext.Request.InputStream, System.Text.Encoding.UTF8);
            String sXMLRequest = reader.ReadToEnd();
            XmlDocument xmlRequest = new XmlDocument();
            xmlRequest.LoadXml(sXMLRequest);

            XmlNode xmlTransactionId = xmlRequest.SelectSingleNode("/mapi/result/transid");
            XmlNode xmlDate = xmlRequest.SelectSingleNode("/mapi/result/date");
            XmlNode xmlTime = xmlRequest.SelectSingleNode("/mapi/result/time");
            XmlNode xmlAmount = xmlRequest.SelectSingleNode("/mapi/result/origAmount");
            XmlNode xmlEmail = xmlRequest.SelectSingleNode("/mapi/result/emailClient");
            XmlNode xmlProduct = xmlRequest.SelectSingleNode("/mapi/result/merchantDatas/_aKey_nom1");
            XmlNode xmlIdProduct = xmlRequest.SelectSingleNode("/mapi/result/refProduct0");

            string sTransactionId = xmlTransactionId.ToString();
            string sDate = DateTime.Now.ToString();
            String sAmount = xmlAmount.ToString();
            string sEmail = xmlEmail.ToString();
            string sProduct = xmlProduct.ToString();
            string sIdProduct = xmlIdProduct.ToString();

            AWLFacture achat = new AWLFacture(); // this is something I have defined in order to save the order in the database

                AWLFacturesContext contextFactures = new AWLFacturesContext();
                List<AWLFacture> tableFactures = contextFactures.FacturesTable.ToList();

                if (tableFactures.Count(d => d.IdPaiement == sTransactionId) < 1)
                    {
                        //if the transactionID is not found in the database, add it
                        //then, add the additional features to the user account
                UsersContext db = new UsersContext();
                UserProfile userBuyer = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));

                        // Mise à jour des paramètres d'achat
                        achat.IdPaiement = sTransactionId;
                        achat.Buyer = userBuyer.UserName;
                        achat.Article = sProduct;
                        achat.Montant = Convert.ToDecimal(sAmount);
                        achat.Plateforme = sDate + " - with HIPAY WALLET";

                        // On ajoute l'entrée dans la table Factures et on sauve la base de données
                        contextFactures.FacturesTable.Add(achat);
                        contextFactures.SaveChanges();

                        // Génération du PDF et des emails

                        // Ajout des noix dans le compte du nutter
                        if (sIdProduct == "1")
                        {
                            userBuyer.UserNuts1 = userBuyer.UserNuts1 + 30;
                        }
                        else if (sIdProduct == "2")
                        {
                            userBuyer.UserNuts2 = userBuyer.UserNuts2 + 30;
                        }
                        else if (sIdProduct == "3")
                        {
                            userBuyer.UserNuts3 = userBuyer.UserNuts3 + 30;
                        }
                        else if (sIdProduct == "4")
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

                    }
                    else
                    {
                        //if we are here, the user must have already used the transaction ID for an account
                        //you might want to show the details of the order, but do not upgrade it!
                    }
                    // take the information returned and store this into a subscription table
                    // this is where you would update your database with the details of the tran

                    return View();
        }
    }
}