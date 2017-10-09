using CleverNuts.Models;
using CleverNuts.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class SuccessPaiementController : ApplicationRealController
    {
        bool enregistre3 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
        //
        // GET: /SuccessPaiement/

        public ActionResult Index()
        {
            AWLFacture achat = new AWLFacture(); // this is something I have defined in order to save the order in the database

            // Receive IPN request from PayPal and parse all the variables returned
            var formVals = new Dictionary<string, string>();
            formVals.Add("cmd", "_notify-synch"); //notify-synch_notify-validate
            formVals.Add("at", "bUyBnYSISiK2AmXEowNt9s_CJ2EqzTc5ZETJ5bRQWFyQiiG4xJ8Kw2D9T00"); // this has to be adjusted
            formVals.Add("tx", Request["tx"]);

            // if you want to use the PayPal sandbox change this from false to true
            string response = GetPayPalResponse(formVals);

            if (response.Contains("SUCCESS"))
            {
                string transactionID = GetPDTValue(response, "txn_id"); // txn_id //d
                string sAmountPaid = GetPDTValue(response, "mc_gross"); // d
                string deviceID = GetPDTValue(response, "custom"); // d
                string payerEmail = GetPDTValue(response, "payer_email"); // d
                string Item = GetPDTValue(response, "item_name");
                string ItemNumber = GetPDTValue(response, "item_number");
                string dateNumber = DateTime.Now.ToString();

                //validate the order
                Decimal amountPaid = 0;
                Decimal.TryParse(sAmountPaid, System.Globalization.NumberStyles.Number, System.Globalization.CultureInfo.InvariantCulture, out amountPaid);

                AWLFacturesContext contextFactures = new AWLFacturesContext();
                List<AWLFacture> tableFactures = contextFactures.FacturesTable.ToList();

                if (tableFactures.Count(d => d.IdPaiement == transactionID) < 1)
                    {
                        //if the transactionID is not found in the database, add it
                        //then, add the additional features to the user account
                UsersContext db = new UsersContext();
                UserProfile userBuyer = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));

                        // Mise à jour des paramètres d'achat
                        achat.IdPaiement = transactionID;
                        achat.Buyer = userBuyer.UserName;
                        achat.Article = Item;
                        achat.Montant = amountPaid;
                        achat.Plateforme = dateNumber + " - with PAYPAL";

                        // On ajoute l'entrée dans la table Factures et on sauve la base de données
                        contextFactures.FacturesTable.Add(achat);
                        contextFactures.SaveChanges();

                        // Génération du PDF et des emails

                        // Ajout des noix dans le compte du nutter
                        if (ItemNumber == "1")
                        {
                            userBuyer.UserNuts1 = userBuyer.UserNuts1 + 30;
                        }
                        else if (ItemNumber == "2")
                        {
                            userBuyer.UserNuts2 = userBuyer.UserNuts2 + 30;
                        }
                        else if (ItemNumber == "3")
                        {
                            userBuyer.UserNuts3 = userBuyer.UserNuts3 + 30;
                        }
                        else if (ItemNumber == "4")
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

                    // On envoie un mail de confirmation
                    MailingService4 mailingService = new MailingService4();
                    mailingService.SendTokenByEmail("", userBuyer.Email, userBuyer.UserName, transactionID, Item, amountPaid.ToString(), dateNumber);
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
            else
            {
                //error
                return View("ErrorBuy");
            }
        }

        string GetPayPalResponse(Dictionary<string, string> formVals)
        {

            string paypalUrl = "https://www.paypal.com/cgi-bin/webscr";

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(paypalUrl);
            
            // Set values for the request back
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";

            byte[] param = Request.BinaryRead(Request.ContentLength);
            string strRequest = Encoding.ASCII.GetString(param);

            StringBuilder sb = new StringBuilder();
            sb.Append(strRequest);

            foreach (string key in formVals.Keys)
            {
                sb.AppendFormat("&{0}={1}", key, formVals[key]);
            }
            strRequest += sb.ToString();
            req.ContentLength = strRequest.Length;

            //for proxy
            //WebProxy proxy = new WebProxy(new Uri("http://urlort#");
            //req.Proxy = proxy;
            //Send the request to PayPal and get the response
            string response = "";
            using (StreamWriter streamOut = new StreamWriter(req.GetRequestStream(), System.Text.Encoding.ASCII))
            {
                streamOut.Write(strRequest);
                streamOut.Close();
                using (StreamReader streamIn = new StreamReader(req.GetResponse().GetResponseStream()))
                {
                    response = streamIn.ReadToEnd();
                }
            }

            return response;
        }

        string GetPDTValue(string pdt, string key)
        {

            string[] keys = pdt.Split('\n');
            string thisVal = "";
            string thisKey = "";
            foreach (string s in keys)
            {
                string[] bits = s.Split('=');
                if (bits.Length > 1)
                {
                    thisVal = bits[1];
                    thisKey = bits[0];
                    if (thisKey.Equals(key, StringComparison.InvariantCultureIgnoreCase))
                        break;
                }
            }
            return thisVal;
        }
    }
}
