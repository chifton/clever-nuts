using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class PlayFbkController : ApplicationRealController
    {

        //
        // GET: /PlayFbk/

        public ActionResult Index()
        {
            return View();
        }

        public string canyouplay(string idmoimatches)
        {
                AWLFacebookContext db = new AWLFacebookContext();
                AWLFacebookProfile user = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(idmoimatches));
                if ((user.UserNuts1 >= 15)
                    || (user.UserNuts1 < 15 && user.UserNuts2 >= 1) || (user.UserNuts1 < 15 && user.UserNuts2 < 1 && user.UserNuts3 >= 1))
                {
                    if (user.UserNuts1 >= 15)
                    {
                        user.UserNuts1 = user.UserNuts1 - 15;
                    }
                    else if (user.UserNuts1 < 15 && user.UserNuts2 >= 1)
                    {
                        user.UserNuts2 = user.UserNuts2 - 1;
                        user.UserNuts1 = user.UserNuts1 + 15;
                    }
                    else if (user.UserNuts1 < 15 && user.UserNuts2 < 1 && user.UserNuts3 >= 1)
                    {
                        user.UserNuts3 = user.UserNuts3 - 1;
                        user.UserNuts2 = user.UserNuts2 + 9; //(+10-1)
                        user.UserNuts1 = user.UserNuts1 + 15;
                    }

                    // Conversions
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

                    // Enregistrement
                    db.SaveChanges();

                    return "OK";
                }
                else
                {
                    return "KO";
                }
        }


        public string sendnotificationtoplay(string monid, string prenomMoi, string codetokenjeu)
        {
            try
            {
                // variables to store parameter values
                string url = "https://graph.facebook.com/" + monid + "/notifications";
                //string texte = " @[" + monid + "], you are invited by " + prenomMoi + " to play an Awalé session game !\nClick to accept !";
                //string autrePrenom = "@[" + monid + "]";
                string codeversjeu = "2" + codetokenjeu;
                string texte = "@[" + monid + "] ! " + prenomMoi + " wants to play with you ! \n Click here !";
                //string address = "https://clevernuts.org/PlayFbkFriend/Index?ordredemandejeugame=2&codejeuadeux=" + codetokenjeu + "&prenom1=" + autrePrenom + "&prenom2="+ prenomMoi;
                //string address2 = "https://clevernuts.org/PlayFbkFriend/Index?ordredemandejeugame=2&codejeuadeux=ds&prenom1=dfdf&prenom2=fdgdfg";
                //"/PlayFbkFriend/Index?ordredemandejeugame=1&codejeuadeux=" + codeunique + "&prenom1=" + friendCache2.me.first_name + "&prenom2=" + friendCache3.me;

                // creates the post data for the POST request
                string postData = ("access_token=722884087782449|a75dcbaa4599d59a60c2440883e70c21&template=" + texte + "&href=PlayFbkFriend/Index2?ordredemandejeugamecodejeuadeux=" + codeversjeu);

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
                return responseData;
            }
            catch(Exception ex)
            {
                return ex.ToString();
            }
        }
    }
}