using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Diagnostics;
using DotNetOpenAuth.AspNet;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;
using CleverNuts.Filters;
using CleverNuts.Models;
using CleverNuts.Services;
using System.Net;
using System.IO;

namespace CleverNuts.Controllers
{
    public class FacebookNutterController : ApplicationRealController
    {
        //
        // GET: /FacebookNutter/

        public ActionResult Index()
        {
            return View();
        }

        //
        // POST: /Account/Register

        public string RegisterFbk(string idfk, string usernamefk, string emailfk)
        {
                // Tentative d'inscription de l'utilisateur par Facebook
                try
                {
                    // On crée le compte facebook nutter dans notre base de données
                    AWLFacebookContext contextNuttersFacebook = new AWLFacebookContext();

                    if (!(contextNuttersFacebook.FacebookNuttersTable.Any(o => o.UserId.Equals(idfk))))
                    {
                        AWLFacebookProfile nutterDefacebook = new AWLFacebookProfile();
                        nutterDefacebook.UserId = idfk;
                        nutterDefacebook.UserName = usernamefk;
                        nutterDefacebook.Email = emailfk;
                        nutterDefacebook.UserNuts1 = 30;
                        nutterDefacebook.UserNuts2 = 0;
                        nutterDefacebook.UserNuts3 = 0;
                        nutterDefacebook.UserBonus = 0;
                        nutterDefacebook.UserLevel = 1;
                        contextNuttersFacebook.FacebookNuttersTable.Add(nutterDefacebook);


                        contextNuttersFacebook.SaveChanges();


                        // ... et on l'envoit à l'utilisateur facebook par email
                        // MailingService5 mailingService = new MailingService5();
                        // mailingService.SendTokenByEmail(confirmationToken, model.Email, model.UserName);

                        ViewData["ici"] = "facebook";
                        ViewData["idfbk"] = idfk;
                        ViewBag.idfbk = idfk;
                        System.Web.HttpContext.Current.Session["idfbk"] = idfk;
                        System.Web.HttpContext.Current.Session["fbkornot"] = "fbk";
                        return "OKRA";

                    }
                    else
                    {
                        ViewData["ici"] = "facebook";
                        ViewData["idfbk"] = idfk;
                        ViewBag.idfbk = idfk;
                        System.Web.HttpContext.Current.Session["idfbk"] = idfk;
                        System.Web.HttpContext.Current.Session["fbkornot"] = "fbk";
                        return "KO";
                    }
                }
                catch (Exception e)
                {
                    return "KOA";
                }
        }

        /*public string demandeCompteFacebook()
        {
            ViewData["fbk"] = "pauline";
            //ViewData["fbkOK"] = "OK";
            // Rafraichir la partial view

            return "OK";
        }*/

        public ActionResult partialfbk(string idnombre, string idnom)
        {
            AWLFacebookContext contextNuttersFacebook2 = new AWLFacebookContext();
            AWLFacebookProfile nutterDefacebookreel = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault((o => o.UserId.Equals(idnombre)));
            ViewData["noix1"] = nutterDefacebookreel.UserNuts1;
            ViewData["noix2"] = nutterDefacebookreel.UserNuts2;
            ViewData["noix3"] = nutterDefacebookreel.UserNuts3;
            ViewData["noixb"] = nutterDefacebookreel.UserBonus;

            ViewData["fbk"] = idnom;
            ViewData["idfbk"] = idnombre;
            ViewBag.idfbk = idnombre;
            System.Web.HttpContext.Current.Session["idfbk"] = idnombre;
            System.Web.HttpContext.Current.Session["fbkornot"] = "fbk";

            return PartialView("_LoginPartialFbk");
        }

        // GET: /Account/Manage

        public ActionResult Manage(string identifiant)
        {
            // Pour les scores du user facebook
            AWLFacebookContext contextNuttersFacebook2 = new AWLFacebookContext();
            AWLFacebookProfile nutterDefacebookreel = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault((o => o.UserId.Equals(identifiant)));
            ViewBag.n1 = nutterDefacebookreel.UserNuts1.ToString();
            ViewBag.n2 = nutterDefacebookreel.UserNuts2.ToString();
            ViewBag.n3 = nutterDefacebookreel.UserNuts3.ToString();
            ViewBag.b = nutterDefacebookreel.UserBonus.ToString();
            ViewBag.levelreached = nutterDefacebookreel.UserLevel.ToString();

            ViewBag.meilleurbonus = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserBonus).ToString();
            int j1 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserBonus);
            string jj1 = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault(u => u.UserBonus.Equals(j1)).UserName;
            ViewBag.meilleurn1 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserNuts1).ToString();
            int j2 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserNuts1);
            string jj2 = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault(u => u.UserNuts1.Equals(j2)).UserName;
            ViewBag.meilleurn2 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserNuts2).ToString();
            int j3 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserNuts2);
            string jj3 = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault(u => u.UserNuts2.Equals(j3)).UserName;
            ViewBag.meilleurn3 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserNuts3).ToString();
            int j4 = contextNuttersFacebook2.FacebookNuttersTable.Max(u => u.UserNuts3);
            string jj4 = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault(u => u.UserNuts3.Equals(j4)).UserName;

            ViewBag.meilleurn3user = jj4;
            ViewBag.meilleurn2user = jj3;
            ViewBag.meilleurn1user = jj2;
            ViewBag.meilleurbonususer = jj1;

            ViewBag.idnutterfacebook = identifiant;

            return View();
        }

        public string sendnotifications(string monid, string achat)
        {
            // variables to store parameter values
            string url = "https://graph.facebook.com/" + monid + "/notifications";
            string texte = "Congratulations @[" + monid + "] ! You bought 30 "+ achat +".\n Play awale and save squirrels !";

            // creates the post data for the POST request
            string postData = ("access_token=722884087782449|a75dcbaa4599d59a60c2440883e70c21&template=" + texte + "&href=https://clevernuts.org/Management2/");
            
            // create the POST request
            HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(url);
            webRequest.Method = "POST";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.ContentLength = postData.Length;

            // POST the data
            using (StreamWriter requestWriter2 = new StreamWriter(webRequest.GetRequestStream()))
            {
                requestWriter2.Write(postData);
            }

            //  This actually does the request and gets the response back
            HttpWebResponse resp = (HttpWebResponse)webRequest.GetResponse();

            string responseData = string.Empty;

            using (StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream()))
            {
                // dumps the HTML from the response into a string variable
                responseData = responseReader.ReadToEnd();
            }
            return "KO";
        }

    }
}